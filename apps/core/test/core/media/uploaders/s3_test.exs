defmodule Core.Media.Uploaders.S3Test do
  use Core.DataCase
  doctest Core.Uploaders.S3

  import Mox
  import SweetXml
  import ExUnit.CaptureLog

  alias Core.{
    Config,
    Upload,
    Uploaders.S3
  }

  @bucket Application.get_env(:core, S3)[:bucket]
  @image_path Path.absname("test/fixtures/image_tmp.jpg")
  @public_endpoint Application.get_env(:core, Core.Uploaders.S3)[:public_endpoint]

  clear_config([S3]) do
    Config.put([S3],
      bucket: @bucket,
      public_endpoint: @public_endpoint
    )
  end

  describe "get_file/1" do
    test "it returns link for files" do
      assert S3.get_file("corner.png") == {
        :ok,
        {:url, "https://nyc3.digitaloceanspaces.com/taxgig/corner.png"}
      }
    end

    test "it returns path without bucket when truncated_namespace set to ''" do
      Config.put([S3],
        bucket: @bucket,
        public_endpoint: @public_endpoint,
        truncated_namespace: ""
      )

      assert S3.get_file("corner.png") == {
        :ok,
        {:url, "https://nyc3.digitaloceanspaces.com/corner.png"}
      }
    end

    test "it returns path with bucket when truncated_namespace set to 'taxgig'" do
      Config.put([S3],
        bucket: @bucket,
        public_endpoint: @public_endpoint,
        truncated_namespace: @bucket
      )

      assert S3.get_file("corner.png") == {
        :ok,
        {:url, "https://nyc3.digitaloceanspaces.com/taxgig/corner.png"}
      }
    end

    test "it returns path with bucket namespace when namespace is set" do
      Config.put([S3],
        bucket: @bucket,
        public_endpoint: @public_endpoint,
        bucket_namespace: "avatar"
      )

      assert S3.get_file("corner.png") == {
        :ok,
        {:url, "https://nyc3.digitaloceanspaces.com/avatar:taxgig/corner.png"}
      }
    end
  end

  describe "list_objects/1" do
    test "it returns list the objects in body" do
      ExAws.S3.list_objects(@bucket)
      |> ExAws.request!
    end

    test "it returns list the objects in this space" do
      assert ExAws.S3.list_objects(@bucket)
        |> ExAws.request!()
        |> get_in([:body, :contents])
    end

    test "it returns list the objects via streem" do
      assert ExAws.S3.list_objects(@bucket)
        |> ExAws.stream!
        |> Enum.to_list
    end
  end

  describe "put_file/1" do
    setup do
      file_upload = %Upload{
        name: "image_tmp.jpg",
        content_type: "image/jpg",
        path: "image_tmp.jpg",
        tempfile: @image_path
      }

      [file_upload: file_upload]
    end

    test "save file", %{file_upload: file_upload} do
      HTTPoisonS3Mock
      |> expect(:put_file, fn _ -> {:ok, {:file, "image_tmp.jpg"}} end)

      assert HTTPoisonS3Mock.put_file(file_upload) == {:ok, {:file, "image_tmp.jpg"}}
    end

    test "save file with capture_log", %{file_upload: file_upload} do
      HTTPoisonS3Mock
      |> expect(:put_file, fn _ -> {:ok, {:file, "image_tmp.jpg"}} end)

      assert capture_log(fn ->
        assert HTTPoisonS3Mock.put_file(file_upload) == {:ok, {:file, "image_tmp.jpg"}}
      end)
    end

    test "returns error", %{file_upload: file_upload} do
      HTTPoisonS3Mock
      |> expect(:put_file, fn _ -> {:error, "S3 Upload failed"} end)

      assert HTTPoisonS3Mock.put_file(file_upload) == {:error, "S3 Upload failed"}
    end

    test "returns error with capture_log", %{file_upload: file_upload} do
      HTTPoisonS3Mock
      |> expect(:put_file, fn _ -> {:error, "S3 Upload failed"} end)

      assert capture_log(fn ->
        assert HTTPoisonS3Mock.put_file(file_upload) == {:error, "S3 Upload failed"}
      end) =~ ""

      doc = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Error><Code>InvalidAccessKeyId</Code><Message>The AWS Access Key Id you provided does not exist in our records.</Message><AWSAccessKeyId>AKIAIAOAONIULXQGMOUA</AWSAccessKeyId><RequestId>F31EBDE03D5F510F</RequestId><HostId>q6qnFuIpraNtY7RJ+Rab6wAKwRPZXGEGT9Cta+IFM1P26NgkFT4OqnFFN8NcSp+8wAiHgnkWuzw=</HostId></Error>"

      result1 = doc |> xpath(~x"//Error/Code/text()"s)
      result2 = doc |> xpath(~x"//Error/Message/text()"s)
      result3 = doc |> xpath(~x"//Error/AWSAccessKeyId/text()"s)
      result4 = doc |> xpath(~x"//Error/RequestId/text()"s)
      result5 = doc |> xpath(~x"//Error/HostId/text()"s)

      assert result1 == "InvalidAccessKeyId"
      assert result2 == "The AWS Access Key Id you provided does not exist in our records."
      assert result3 == "AKIAIAOAONIULXQGMOUA"
      assert result4 == "F31EBDE03D5F510F"
      assert result5 == "q6qnFuIpraNtY7RJ+Rab6wAKwRPZXGEGT9Cta+IFM1P26NgkFT4OqnFFN8NcSp+8wAiHgnkWuzw="
    end
  end

  describe "deleted_object/1" do
    setup do
      file_upload = %Upload{
        name: "image_tmp.jpg",
        content_type: "image/jpg",
        path: "image_tmp.jpg",
        tempfile: @image_path
      }

      [file_upload: file_upload]
    end

    test "delete file", %{file_upload: file_upload} do
      assert S3.put_file(file_upload) == {:ok, {:file, "image_tmp.jpg"}}
      assert S3.remove_file("image_tmp.jpg")
    end

    test "delete object", %{file_upload: file_upload} do
      assert S3.put_file(file_upload) == {:ok, {:file, "image_tmp.jpg"}}
      ExAws.S3.delete_object("taxgig", "image_tmp.jpg") |> ExAws.request!()
    end

    test "returns error", %{file_upload: _file_upload} do
      assert S3.remove_file("image.jpg") == {:error, "S3 Upload failed"}
    end
  end
end

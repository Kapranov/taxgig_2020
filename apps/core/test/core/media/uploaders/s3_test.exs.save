defmodule Core.Media.Uploaders.S3Test do
  use Core.DataCase
  doctest Core.Uploaders.S3

  import Mox
  import SweetXml

  alias Core.{
    Config,
    Upload,
    Uploaders.S3
  }

  import ExUnit.CaptureLog

  @image_path Path.absname("test/fixtures/image_tmp.jpg")

  clear_config([S3]) do
    Config.put([S3],
      bucket: "test_bucket",
      public_endpoint: "https://s3.amazonaws.com"
    )
  end

  describe "get_file/1" do
    test "it returns path to local folder for files" do
      assert S3.get_file("test_image.jpg") == {
        :ok,
        {:url, "https://s3.amazonaws.com/test_bucket/test_image.jpg"}
      }
    end

    test "it returns path without bucket when truncated_namespace set to ''" do
      Config.put([S3],
        bucket: "test_bucket",
        public_endpoint: "https://s3.amazonaws.com",
        truncated_namespace: ""
      )

      assert S3.get_file("test_image.jpg") == {
        :ok,
        {:url, "https://s3.amazonaws.com/test_image.jpg"}
      }
    end

    test "it returns path with bucket namespace when namespace is set" do
      Config.put([S3],
        bucket: "test_bucket",
        public_endpoint: "https://s3.amazonaws.com",
        bucket_namespace: "family"
      )

      assert S3.get_file("test_image.jpg") == {
        :ok,
        {:url, "https://s3.amazonaws.com/family:test_bucket/test_image.jpg"}
      }
    end
  end

  describe "put_file/1" do
    setup do
      file_upload = %Upload{
        name: "image-tet.jpg",
        content_type: "image/jpg",
        path: "test_folder/image-tet.jpg",
        tempfile: @image_path
      }

      [file_upload: file_upload]
    end

    test "save file", %{file_upload: file_upload} do
      # HTTPoisonS3Mock
      # |> expect(:put_file, fn _ -> {:ok, {:file, "test_folder/image-tet.jpg"}} end)

      # assert S3.put_file(file_upload) == "Elixir.CommunityWeb.Uploaders.S3: #{body}"

      assert capture_log(fn ->
        assert S3.put_file(file_upload) == {:error, "S3 Upload failed"}
      end) =~ "Elixir.Core.Uploaders.S3: {:error, {:http_error, 400, %{body:"

      # assert HTTPoisonS3Mock.put_file(file_upload) == S3.put_file(file_upload)
      # assert HTTPoisonS3Mock.put_file(file_upload) == {:ok, {:file, "test_folder/image-tet.jpg"}}
      # assert S3.put_file(file_upload) == {:ok, {:file, "test_folder/image-tet.jpg"}}
    end

    test "returns error", %{file_upload: file_upload} do
      HTTPoisonS3Mock
      |> expect(:put_file, fn _ -> {:error, "S3 Upload failed"} end)

      assert HTTPoisonS3Mock.put_file(file_upload) == {:error, "S3 Upload failed"}
      assert capture_log(fn ->
        assert S3.put_file(file_upload) == {:error, "S3 Upload failed"}
      end) =~ "Elixir.Core.Uploaders.S3: {:error, {:http_error, 400, %{body:"

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
end

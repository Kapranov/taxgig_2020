defmodule ServerWeb.Media.UploadTest do
  use Core.DataCase

  import ExUnit.CaptureLog

  alias Core.{
    Config,
    Upload,
    Upload.Filter,
    Uploaders.Local,
    Uploaders.S3
  }

  alias ServerWeb.Endpoint

  @bucket Config.get!([S3, :bucket])
  @public_endpoint Config.get!([S3, :public_endpoint])
  @image1_path Path.absname("../core/test/fixtures/image.jpg")
  @image2_path Path.absname("../core/test/fixtures/image_tmp.jpg")
  @file_path Path.absname("../core/test/fixtures/test_tmp.txt")
  @upload_file %Plug.Upload{
    content_type: "image/jpg",
    path: @image2_path,
    filename: "image.jpg"
  }

  describe "Storing a file with the Local uploader" do
    setup [:ensure_local_uploader]

    test "returns a media url" do
      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "image/jpg",
        filename: "image_tmp.jpg",
        path: @image2_path
      }

      {:ok, data} = Upload.store(file)

      <<"#{@public_endpoint}/#{@bucket}/", logo_id::binary-size(64), ".jpg" >> = data.url

      assert String.starts_with?(data.url, "#{@public_endpoint}" <> "/#{@bucket}/")
      assert S3.remove_file("#{logo_id}.jpg")
    end

    test "returns a media url with configured base_url" do
      base_url = "https://cache.mobilizon.social"

      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "image/jpg",
        filename: "image.jpg",
        path: @image2_path
      }

      {:ok, data} = Upload.store(file, base_url: base_url)

      <<"https://cache.mobilizon.social/#{@bucket}/", logo_id::binary-size(64), ".jpg" >> = data.url

      assert String.starts_with?(data.url, base_url <> "/#{@bucket}/")
      assert S3.remove_file("#{logo_id}.jpg")
    end

    test "copies the file to the configured folder with deduping" do
      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "image/jpg",
        filename: "an [image.jpg",
        path: @image2_path
      }

      {:ok, data} = Upload.store(file, filters: [Filter.Dedupe])

      <<"#{@public_endpoint}/#{@bucket}/", logo_id::binary-size(64), ".jpg" >> = data.url

      assert data.url == "#{@public_endpoint}" <> "/#{@bucket}/#{logo_id}.jpg"
      assert S3.remove_file("#{logo_id}.jpg")
    end

    test "copies the file to the configured folder without deduping" do
      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "image/jpg",
        filename: "an [image.jpg",
        path: @image2_path
      }

      {:ok, data} = Upload.store(file)

      <<"#{@public_endpoint}/#{@bucket}/", logo_id::binary-size(64), ".jpg" >> = data.url

      assert data.name == "an [image.jpg"
      assert S3.remove_file("#{logo_id}.jpg")
    end

    test "fixes incorrect content type" do
      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "application/octet-stream",
        filename: "an [image.jpg",
        path: @image2_path
      }

      {:ok, data} = Upload.store(file, filters: [Filter.Dedupe])
      <<"#{@public_endpoint}/#{@bucket}/", logo_id::binary-size(64), ".jpg" >> = data.url

      assert data.content_type == "image/jpg"
      assert S3.remove_file("#{logo_id}.jpg")
    end

    test "adds missing extension" do
      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "image/jpg",
        filename: "an [image",
        path: @image2_path
      }

      {:ok, data} = Upload.store(file)
      <<"#{@public_endpoint}/#{@bucket}/", logo_id::binary-size(64), ".jpg" >> = data.url

      assert data.name == "an [image.jpg"
      assert S3.remove_file("#{logo_id}.jpg")
    end

    test "fixes incorrect file extension" do
      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "image/jpg",
        filename: "an [image.blah",
        path: @image2_path
      }

      {:ok, data} = Upload.store(file)
      <<"#{@public_endpoint}/#{@bucket}/", logo_id::binary-size(64), ".jpg" >> = data.url

      assert data.name == "an [image.jpg"
      assert S3.remove_file("#{logo_id}.jpg")
    end

    test "don't modify filename of an unknown type" do
      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "text/plain",
        filename: "test.txt",
        path: @file_path
      }

      {:error, data} = Upload.store(file)
      assert data == :enoent
    end

    test "copies the file to the configured folder with anonymizing filename" do
      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "image/jpg",
        filename: "an [image.jpg",
        path: @image2_path
      }

      {:ok, data} = Upload.store(file, filters: [Filter.AnonymizeFilename])
      <<"#{@public_endpoint}/#{@bucket}/", logo_id::binary-size(36), "/an--image.jpg">> = data.url

      refute data.name == "an [image.jpg"
      assert S3.remove_file("#{logo_id}/an--image.jpg")
    end

    test "escapes invalid characters in url" do
      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "image/jpg",
        filename: "an… image.jpg",
        path: @image2_path
      }

      {:ok, data} = Upload.store(file)
      <<"#{@public_endpoint}/#{@bucket}/", logo_id::binary-size(64), ".jpg" >> = data.url

      assert Path.basename(data.url) == "#{logo_id}.jpg"
      assert S3.remove_file("#{logo_id}.jpg")
    end

    test "escapes reserved uri characters" do
      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "image/jpg",
        filename: ":?#[]@!$&\\'()*+,;=.jpg",
        path: @image2_path
      }

      {:ok, data} = Upload.store(file)
      <<"#{@public_endpoint}/#{@bucket}/", logo_id::binary-size(64), ".jpg" >> = data.url

      assert Path.basename(data.url) == "#{logo_id}.jpg"
      assert S3.remove_file("#{logo_id}.jpg")
    end

    test "upload and delete successfully a file" do
      {path, url} = upload()
      refute File.exists?(path)
      assert {:ok, _} = Upload.remove(url)
      refute File.exists?(path)
      path = path |> Path.split() |> Enum.reverse() |> tl |> Enum.reverse() |> Path.join()
      refute File.exists?(path)
    end

    test "delete a not existing file" do
      file =
        Config.get!([Local, :uploads]) <> "/not_existing/definitely.jpg"

      refute File.exists?(file)
      assert {:error, "S3 Upload failed"} = Upload.remove("#{@public_endpoint}/#{@bucket}/not_existing/definitely.jpg")
    end
  end

  defmodule TestUploaderBase do
    def put_file(%{path: path} = _upload, module_name) do
      task_pid =
        Task.async(fn ->
          :timer.sleep(10)

          {Uploader, path}
          |> :global.whereis_name()
          |> send({Uploader, self(), {:test}, %{}})

          assert_receive {Uploader, {:test}}, 4_000
        end)

      Agent.start(fn -> task_pid end, name: module_name)

      :wait_callback
    end
  end

  describe "Tried storing a file when http callback response success result" do
    defmodule TestUploaderSuccess do
      def http_callback(conn, _params),
        do: {:ok, conn, {:file, "post-process-file.jpg"}}

      def put_file(upload), do: TestUploaderBase.put_file(upload, __MODULE__)
    end

    setup do: [uploader: TestUploaderSuccess]
    setup [:ensure_local_uploader]

    test "it returns file" do
      File.cp!(@image1_path, @image2_path)

      assert Upload.store(@upload_file) == {
        :ok,
        %{
          content_type: "image/jpg",
          name: "image.jpg",
          size: 5024,
          url: "#{@public_endpoint}/#{@bucket}/225603daa1f4501e10312aef7d8eda2fae6264abb450b327ba6e51b35be1f79e.jpg"
        }
      }
    end
  end

  describe "Tried storing a file when http callback response error" do
    defmodule TestUploaderError do
      def http_callback(conn, _params), do: {:error, conn, "Errors"}
      def put_file(upload), do: TestUploaderBase.put_file(upload, __MODULE__)
    end

    setup do: [uploader: TestUploaderError]
    setup [:ensure_local_uploader]

    test "it returns error" do
      File.cp!(@image1_path, @image2_path)

      assert capture_log(fn ->
        assert Upload.store(@upload_file)
      end) =~ ""

      assert capture_log(fn ->
        assert Upload.store(@upload_file) == {:ok,
          %{
            content_type: "image/jpg",
            name: "image.jpg",
            size: 5024,
            url: "#{@public_endpoint}/#{@bucket}/225603daa1f4501e10312aef7d8eda2fae6264abb450b327ba6e51b35be1f79e.jpg"
          }
        }
      end) =~ ""
    end
  end

  describe "Tried storing a file when http callback doesn't response by timeout" do
    defmodule(TestUploader, do: def(put_file(_upload), do: :wait_callback))
    setup do: [uploader: TestUploader]
    setup [:ensure_local_uploader]

    test "it returns error" do
      File.cp!(@image1_path, @image2_path)

      assert capture_log(fn -> assert Upload.store(@upload_file) end) == ""

      assert capture_log(fn ->
        assert Upload.store(@upload_file) == {:ok,
          %{
            content_type: "image/jpg",
            name: "image.jpg",
            size: 5024,
            url: "#{@public_endpoint}/#{@bucket}/225603daa1f4501e10312aef7d8eda2fae6264abb450b327ba6e51b35be1f79e.jpg"
          }
        }
      end) == ""
    end
  end

  describe "Setting a custom base_url for uploaded media" do
    clear_config([Upload, :base_url]) do
      Config.put([Upload, :base_url], "https://taxgig.me:4001")
    end

    test "returns a media url with configured base_url" do
      base_url = Config.get([Upload, :base_url])

      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "image/jpg",
        path: @image2_path,
        filename: "image.jpg"
      }

      {:ok, data} = Upload.store(file, base_url: base_url)

      <<"https://taxgig.me:4001/#{@bucket}/", logo_id::binary-size(64), ".jpg" >> = data.url

      assert data.url == Endpoint.url() <> "/#{@bucket}/#{logo_id}.jpg"
      assert %{
        content_type: "image/jpg",
        name: "image.jpg",
        size: 5024,
        url: url
      } = data

      assert String.starts_with?(url, base_url <> "/#{@bucket}/#{logo_id}.jpg")
    end
  end

  defp upload do
    File.cp!(@image1_path, @image2_path)

    file = %Plug.Upload{
      content_type: "image/jpg",
      filename: "image_tmp.jpg",
      path: @image2_path
    }

    {:ok, data} = Upload.store(file)

     assert %{
       content_type: "image/jpg",
       name: "image_tmp.jpg",
       size: 5024,
       url: url,
     } = data

     assert String.starts_with?(url, "#{@public_endpoint}" <> "/#{@bucket}/")

     %URI{path: "/#{@bucket}/" <> path} = URI.parse(url)
     {Config.get!([Local, :uploads]) <> "/" <> path, url}
  end
end

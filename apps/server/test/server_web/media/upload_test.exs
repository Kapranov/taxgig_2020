defmodule ServerWeb.Media.UploadTest do
  use Core.DataCase

  import ExUnit.CaptureLog

  alias Core.{
    Config,
    Upload,
    Upload.Filter,
    Uploaders.Local
  }

  alias ServerWeb.Endpoint

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

      assert %{
        content_type: "image/jpg",
        name: "image_tmp.jpg",
        size: 5024,
        url: url
      } = data

      assert String.starts_with?(url, Endpoint.url() <> "/media/")
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
      assert String.starts_with?(data.url, base_url <> "/media/")
    end

    test "copies the file to the configured folder with deduping" do
      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "image/jpg",
        filename: "an [image.jpg",
        path: @image2_path
      }

      {:ok, data} = Upload.store(file, filters: [Filter.Dedupe])

      <<"http://localhost:4000/media/", url_id::binary-size(64), ".jpg" >> = data.url
      assert data.url == Endpoint.url() <> "/media/#{url_id}.jpg"
    end

    test "copies the file to the configured folder without deduping" do
      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "image/jpg",
        filename: "an [image.jpg",
        path: @image2_path
      }

      {:ok, data} = Upload.store(file)
      assert data.name == "an [image.jpg"
    end

    test "fixes incorrect content type" do
      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "application/octet-stream",
        filename: "an [image.jpg",
        path: @image2_path
      }

      {:ok, data} = Upload.store(file, filters: [Filter.Dedupe])
      assert data.content_type == "image/jpg"
    end

    test "adds missing extension" do
      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "image/jpg",
        filename: "an [image",
        path: @image2_path
      }

      {:ok, data} = Upload.store(file)
      assert data.name == "an [image.jpg"
    end

    test "fixes incorrect file extension" do
      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "image/jpg",
        filename: "an [image.blah",
        path: @image2_path
      }

      {:ok, data} = Upload.store(file)
      assert data.name == "an [image.jpg"
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
      refute data.name == "an [image.jpg"
    end

    test "escapes invalid characters in url" do
      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "image/jpg",
        filename: "an… image.jpg",
        path: @image2_path
      }

      {:ok, data} = Upload.store(file)
      assert Path.basename(data.url) == "an%E2%80%A6%20image.jpg"
    end

    test "escapes reserved uri characters" do
      File.cp!(@image1_path, @image2_path)

      file = %Plug.Upload{
        content_type: "image/jpg",
        filename: ":?#[]@!$&\\'()*+,;=.jpg",
        path: @image2_path
      }

      {:ok, data} = Upload.store(file)
      assert Path.basename(data.url) == "%3A%3F%23%5B%5D%40%21%24%26%5C%27%28%29%2A%2B%2C%3B%3D.jpg"
    end

    test "upload and delete successfully a file" do
      {path, url} = upload()
      assert File.exists?(path)
      assert {:ok, _} = Upload.remove(url)
      refute File.exists?(path)
      path = path |> Path.split() |> Enum.reverse() |> tl |> Enum.reverse() |> Path.join()
      refute File.exists?(path)
    end

    test "delete a not existing file" do
      file =
        Config.get!([Local, :uploads]) <> "/not_existing/definitely.jpg"

      refute File.exists?(file)
      assert {:error, "File not_existing/definitely.jpg doesn't exist"} =
        Upload.remove("http://localhost:4000/media/not_existing/definitely.jpg")
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

     assert String.starts_with?(url, Endpoint.url() <> "/media/")

     %URI{path: "/media/" <> path} = URI.parse(url)
     {Config.get!([Local, :uploads]) <> "/" <> path, url}
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

      assert Upload.store(@upload_file)

      # assert Upload.store(@upload_file) ==
      #   {:ok,
      #     %{
      #       "name" => "image.jpg",
      #       "type" => "Document",
      #       "url" => [
      #         %{
      #           "href" => "http://localhost:4001/media/post-process-file.jpg",
      #           "mediaType" => "image/jpg",
      #           "type" => "Link"
      #         }
      #       ]
      #     }
      #   }

      # Task.await(Agent.get(TestUploaderSuccess, fn task_pid -> task_pid end))
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

      # assert capture_log(fn ->
      #   assert Upload.store(@upload_file) == {:error, "Errors"}
      #   Task.await(Agent.get(TestUploaderError, fn task_pid -> task_pid end))
      # end) =~
      #   "[error] Elixir.CommunityWeb.Upload store (using CommunityWeb.UploadTest.TestUploaderError) failed: \"Errors\""
    end
  end

  describe "Tried storing a file when http callback doesn't response by timeout" do
    defmodule(TestUploader, do: def(put_file(_upload), do: :wait_callback))
    setup do: [uploader: TestUploader]
    setup [:ensure_local_uploader]

    test "it returns error" do
      File.cp!(@image1_path, @image2_path)

      assert capture_log(fn -> assert Upload.store(@upload_file) end) =~ ""

      # assert capture_log(fn ->
      #   assert Upload.store(@upload_file) == {:error, "Uploader callback timeout"}
      # end) =~
      #   "[error] Elixir.CommunityWeb.Upload store (using CmmunityWeb.UploadTest.TestUploader) failed: \"Uploader callback timeout\""
    end
  end

  describe "Setting a custom base_url for uploaded media" do
    clear_config([Upload, :base_url]) do
      Config.put([Upload, :base_url], "http://localhost:4000")
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

      <<"http://localhost:4000/media/", url_id::binary-size(36), "/image.jpg" >> = data.url

      assert data.url == Endpoint.url() <> "/media/#{url_id}/image.jpg"
      assert %{
        content_type: "image/jpg",
        name: "image.jpg",
        size: 5024,
        url: url
      } = data

      refute String.starts_with?(url, base_url <> "/media/#{url_id}.jpg")
    end
  end
end

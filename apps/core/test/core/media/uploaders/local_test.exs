defmodule Core.Media.Uploaders.LocalTest do
  use ExUnit.Case
  doctest Core.Uploaders.Local

  alias Core.Upload
  alias Core.Uploaders.Local

  @image_path Path.absname("test/fixtures/image_tmp.jpg")

  describe "get_file/1" do
    test "it returns path to local folder for files" do
      assert Local.get_file("") == {:ok, {:static_dir, "test/uploads"}}
    end
  end

  describe "put_file/1" do
    test "put file to local folder" do
      file_path = "local_upload/files/image.jpg"

      file = %Upload{
        name: "image.jpg",
        content_type: "image/jpg",
        path: file_path,
        tempfile: @image_path
      }


      assert Local.put_file(file) == :ok
      assert Path.join([Local.upload_path(), file_path])
             |> File.exists?()
    end
  end
end

defmodule Core.Media.Upload.FilterTest do
  use Core.DataCase

  alias Core.{
    Config,
    Upload,
    Upload.Filter
  }

  clear_config([Filter.AnonymizeFilename, :text])

  @image1_path Path.absname("test/fixtures/image.jpg")
  @image2_path Path.absname("test/fixtures/image_tmp.jpg")

  test "applies filters" do
    Config.put([Filter.AnonymizeFilename, :text], "custom-file.png")

    File.cp!(
      @image1_path,
      @image2_path
    )

    upload = %Upload{
      name: "an… image.jpg",
      content_type: "image/jpg",
      path: @image1_path,
      tempfile: @image2_path
    }

    assert Filter.filter([], upload) == {:ok, upload}

    assert {:ok, upload} = Filter.filter([Filter.AnonymizeFilename], upload)
    assert upload.name == "custom-file.png"
  end
end

defmodule Core.Media.Upload.Filter.AnonymizeFilenameTest do
  use Core.DataCase

  alias Core.{
    Config,
    Upload,
    Upload.Filter
  }

  @image_path Path.absname("test/fixtures/image_tmp.jpg")

  setup do
    upload_file = %Upload{
      name: "an… image.jpg",
      content_type: "image/jpg",
      path: @image_path
    }

    %{upload_file: upload_file}
  end

  clear_config([Filter.AnonymizeFilename, :text])

  test "it replaces filename on pre-defined text", %{upload_file: upload_file} do
    Config.put([Filter.AnonymizeFilename, :text], "custom-file.png")
    {:ok, %Upload{name: name}} = Filter.AnonymizeFilename.filter(upload_file)
    assert name == "custom-file.png"
  end

  test "it replaces filename on pre-defined text expression", %{upload_file: upload_file} do
    Config.put([Filter.AnonymizeFilename, :text], "custom-file.{extension}")
    {:ok, %Upload{name: name}} = Filter.AnonymizeFilename.filter(upload_file)
    assert name == "custom-file.jpg"
  end

  test "it replaces filename on random text", %{upload_file: upload_file} do
    {:ok, %Upload{name: name}} = Filter.AnonymizeFilename.filter(upload_file)
    assert <<_::bytes-size(14)>> <> ".jpg" = name
    refute name == "an… image.jpg"
  end
end

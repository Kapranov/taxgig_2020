defmodule Core.Media.Upload.Filter.DedupeTest do
  use Core.DataCase

  alias Core.{
    Upload,
    Upload.Filter.Dedupe
  }

  @shasum "225603daa1f4501e10312aef7d8eda2fae6264abb450b327ba6e51b35be1f79e"
  @image1_path Path.absname("test/fixtures/image.jpg")
  @image2_path Path.absname("test/fixtures/image_tmp.jpg")

  test "adds shasum" do
    File.cp!(
      @image1_path,
      @image2_path
    )

    upload = %Upload{
      name: "an… image.jpg",
      content_type: "image/jpg",
      path: @image2_path,
      size: 5024,
      tempfile: @image2_path
    }

    assert {
      :ok,
      %Upload{
        content_type: "image/jpg",
        id: @shasum,
        name: "an… image.jpg",
        path: @shasum <> ".jpg",
        size: 5024
      }
    } = Dedupe.filter(upload)
  end
end

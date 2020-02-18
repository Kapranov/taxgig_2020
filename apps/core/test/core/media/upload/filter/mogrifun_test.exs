defmodule Core.Media.Upload.Filter.MogrifunTest do
  use Core.DataCase

  alias Core.{
    Upload,
    Upload.Filter
  }

  @image1_path Path.absname("test/fixtures/image.jpg")
  @image2_path Path.absname("test/fixtures/image_tmp.jpg")

  test "apply mogrify filter" do
    File.cp!(
      @image1_path,
      @image2_path
    )

    upload = %Upload{
      name: "an… image.jpg",
      content_type: "image/jpg",
      path: @image2_path,
      tempfile: @image2_path
    }

    assert Filter.Mogrifun.filter(upload) == :ok
  end
end

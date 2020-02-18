defmodule Core.Media.Upload.Filter.MogrifyTest do
  use Core.DataCase

  alias Core.{
    Config,
    Upload,
    Upload.Filter
  }

  clear_config([Filter.Mogrify, :args])

  @image1_path Path.absname("test/fixtures/image.jpg")
  @image2_path Path.absname("test/fixtures/image_tmp.jpg")

  test "apply mogrify filter" do
    Config.put([Filter.Mogrify, :args], [{"tint", "40"}])

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

    assert Filter.Mogrify.filter(upload) == :ok
  end
end

defmodule Core.Media.PictureTest do
  use Core.DataCase

  alias Core.{
    Config,
    Media,
    Uploaders.Local,
    Uploaders.S3
  }

  import Core.Factory

  describe "media" do
    setup [:ensure_local_uploader]

    alias Core.Media.Picture

    @valid_attrs %{
      file: %{
        url: "https://something.tld/media/something",
        name: "something old"
      }
    }

    @update_attrs %{
      file: %{
        url: "https://something.tld/media/something_updated",
        name: "something new"
      }
    }

    @public_endpoint Application.compile_env(:core, Core.Uploaders.S3)[:public_endpoint]

    test "get_picture!/1 returns the picture with given user_id" do
      picture = insert(:picture)
      assert picture.file.content_type == "image/jpg"
      assert picture.file.name         == "image_tmp.jpg"
      assert picture.file.size         == 5024
      assert picture.file.url          =~ @public_endpoint
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(picture.file.url)
    end

    test "create_picture/1 with valid data creates a picture" do
      assert {:ok, %Picture{} = picture} =
        Media.create_picture(Map.put(@valid_attrs, :profile_id, insert(:profile).user_id))
      assert picture.file.name == "something old"
    end

    test "update_picture/2 with valid data updates the picture" do
      user = build(:user, email: "oleg@yahoo.com")
      profile = build(:profile, user: user)
      picture = insert(:picture, profile: profile)

      assert {:ok, %Picture{} = picture} =
        Media.update_picture(picture, Map.put(
          @update_attrs,
          :profile_id,
          insert(:profile).user_id
        ))
      assert picture.file.name == "something new"
    end

    test "delete_picture/1 deletes the picture" do
      picture = insert(:picture)

      %URI{path: "/taxgig/" <> path} = URI.parse(picture.file.url)

      refute File.exists?(Config.get!([Local, :uploads]) <> "/" <> path)
      assert {:ok, %Picture{}} = Media.delete_picture(picture)
      assert Media.get_picture!(picture.profile_id) == nil
      refute File.exists?(Config.get!([Local, :uploads]) <> "/" <> path)
      assert Core.Upload.remove(picture.file.url)
    end

    test "delete_picture/1 deletes the picture via S3" do
      picture = insert(:picture)

      %URI{path: "/taxgig/" <> path} = URI.parse(picture.file.url)

      refute File.exists?(Config.get!([S3, :public_endpoint]) <> "/" <> Config.get!([S3, :bucket]) <> "/" <> path)
      assert {:ok, %Picture{}} = Media.delete_picture(picture)
      assert Media.get_picture!(picture.profile_id) == nil
      refute File.exists?(Config.get!([S3, :public_endpoint]) <> "/" <> Config.get!([S3, :bucket]) <> "/" <> path)
      assert Core.Upload.remove(picture.file.url)
    end
  end
end

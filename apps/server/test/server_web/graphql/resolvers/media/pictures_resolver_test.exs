defmodule ServerWeb.GraphQL.Resolvers.Media.PicturesResolverTest do
  use ServerWeb.ConnCase

  alias Core.Accounts
  alias ServerWeb.GraphQL.Resolvers.Media.PicturesResolver

  @image_path Path.absname("../core/test/fixtures/picture.png")

  describe "#picture" do
    it "get picture for an event's pic" do
      picture = insert(:picture)
      {:ok, found} = PicturesResolver.picture(%{picture_id: picture.id}, nil, nil)
      assert found.id           == picture.id
      assert found.content_type == picture.file.content_type
      assert found.name         == picture.file.name
      assert found.size         == picture.file.size
      assert found.url          == picture.file.url
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

    it "get picture for an event that has an attached" do
      picture = insert(:picture)
      {:ok, found} = PicturesResolver.picture(nil, %{id: picture.id}, nil)
      assert found.id           == picture.id
      assert found.content_type == picture.file.content_type
      assert found.name         == picture.file.name
      assert found.size         == picture.file.size
      assert found.url          == picture.file.url
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

    it "returns not found when Picture does not exist for an event's pic" do
      id = FlakeId.get()
      {:error, error} = PicturesResolver.picture(%{picture_id: id}, nil, nil)
      assert error == "Picture with ID #{id} was not found"
    end

    it "returns not found when Picture does not exist for an event that has an attached" do
      id = FlakeId.get()
      {:error, error} = PicturesResolver.picture(nil, %{id: id}, nil)
      assert error == "Picture with ID #{id} was not found"
    end

    it "returns error for missing params for an event's pic" do
      args = %{picture_id: nil}
      {:error, error} = PicturesResolver.picture(args, nil, nil)
      assert error == nil
    end

    it "returns error for missing params for an event that has an attached" do
      picture = insert(:picture)
      args = %{id: nil}
      {:error, error} = PicturesResolver.picture(nil, args, nil)
      assert error == nil
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
  end

  describe "#uploadPicture" do
    it "uploads a new picture" do
      profile = insert(:profile)
      user = Accounts.get_user!(profile.user_id)
      public_endpoint = Application.get_env(:core, Core.Uploaders.S3)[:public_endpoint]
      authenticated = %{context: %{current_user: user}}
      picture = %{name: "my pic", alt: "represents something", file: "picture.png"}
      file = %Plug.Upload{
        content_type: "image/png",
        filename: picture.file,
        path: @image_path
      }

      {:ok, uploaded} = PicturesResolver.upload_picture(nil, %{
        file: file,
        name: picture.name,
        profile_id: user.id
      }, authenticated)

      assert uploaded.content_type == "image/png"
      assert uploaded.name         == picture.name
      assert uploaded.size         == 4002
      assert uploaded.url          =~ public_endpoint
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(profile.logo.url)
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(uploaded.url)
    end

    it "unauthenticated uploads a new picture" do
      profile = insert(:profile)
      user = Accounts.get_user!(profile.user_id)
      authenticated = %{context: %{}}
      picture = %{name: "my pic", alt: "represents something", file: "picture.png"}
      file = %Plug.Upload{
        content_type: "image/png",
        filename: picture.file,
        path: @image_path
      }

      {:error, error} =
        PicturesResolver.upload_picture(nil, %{
          file: file,
          name: picture.name,
          profile_id: user.id
        }, authenticated)

      assert error == "Unauthenticated"
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(profile.logo.url)
    end

    it "uploads a new picture when user id is not owned by authenticated" do
      profile = insert(:profile)
      user = Accounts.get_user!(profile.user_id)
      authenticated = %{context: %{current_user: user}}
      user_id = FlakeId.get()
      picture = %{name: "my pic", alt: "represents something", file: "picture.png"}
      file = %Plug.Upload{
        content_type: "image/png",
        filename: picture.file,
        path: @image_path
      }

      {:error, error} =
        PicturesResolver.upload_picture(nil, %{
          file: file,
          name: picture.name,
          profile_id: user_id
        }, authenticated)

      assert error == [[field: :profile_id, message: "Select the profile"]]
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(profile.logo.url)
    end

    it "returns error for missing params" do
      profile = insert(:profile)
      user = Accounts.get_user!(profile.user_id)
      authenticated = %{context: %{current_user: user}}
      picture = %{name: nil, alt: nil, file: nil}
      file = nil

      {:error, error} =
        PicturesResolver.upload_picture(nil, %{
          file: file,
          name: picture.name,
          profile_id: user.id
        }, authenticated)

      assert error == "Unauthenticated"
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(profile.logo.url)
    end

    it "returns error for missing params with current user is empty" do
      authenticated = %{context: %{current_user: nil}}
      picture = %{name: nil, alt: nil, file: nil}
      file = nil

      {:error, error} =
        PicturesResolver.upload_picture(nil, %{
          file: file,
          name: picture.name,
          profile_id: nil
        }, authenticated)

      assert error == "Unauthenticated"
    end
  end

  describe "#delete" do
    it "delete specific picture by profile_id" do
      picture = insert(:picture)
      user = Accounts.get_user!(picture.profile_id)
      context = %{context: %{current_user: user}}
      {:ok, deleted} =
        PicturesResolver.remove_picture(nil, %{profile_id: picture.profile_id}, context)
      assert deleted.id == picture.id
    end

    it "returns not found when picture does not exist" do
      id = FlakeId.get()
      struct = insert(:picture)
      user = Core.Accounts.User.find_by(id: struct.profile_id)
      context = %{context: %{current_user: user}}
      {:error, error} = PicturesResolver.remove_picture(nil, %{profile_id: id}, context)
      assert error == "permission denied"
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(struct.file.url)
    end

    it "returns error for missing params" do
      struct = insert(:picture)
      user = Core.Accounts.User.find_by(id: struct.profile_id)
      context = %{context: %{current_user: user}}
      args = %{profile_id: nil, file: nil, name: nil}
      {:error, error} = PicturesResolver.remove_picture(nil, args, context)
      assert error == [[field: :profile_id, message: "Can't be blank"]]
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(struct.file.url)
    end

    test "delete_picture/3 forbids deleting if no auth" do
      struct = insert(:picture)
      context = %{context: %{current_user: nil}}
      {:error, "permission denied"} =
        PicturesResolver.remove_picture(nil, %{profile_id: struct.profile_id}, context)
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(struct.file.url)
    end
  end
end

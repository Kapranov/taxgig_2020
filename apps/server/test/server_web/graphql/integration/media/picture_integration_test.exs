defmodule ServerWeb.GraphQL.Integration.Media.PictureIntegrationTest do
  use ServerWeb.ConnCase

  alias Core.{
    Accounts,
    Accounts.Profile,
    Media.Picture,
    Repo
  }
  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  @image_path Path.absname("../core/test/fixtures/picture.png")

  describe "Resolver: Get picture" do
    test "picture/3 returns the information on a picture - `AbsintheHelpers`" do
      %Picture{id: id} = picture = insert(:picture)

      public_endpoint = Application.get_env(:core, Core.Uploaders.S3)[:public_endpoint]

      query = """
      {
        picture(id: \"#{id}\") {
          id
          content_type
          name
          size
          url
        }
      }
      """

      res =
        build_conn()
        |> get("/graphiql", AbsintheHelpers.query_skeleton(query, "picture"))

      assert json_response(res, 200)["data"]["picture"]["id"]           == picture.id
      assert json_response(res, 200)["data"]["picture"]["content_type"] == picture.file.content_type
      assert json_response(res, 200)["data"]["picture"]["name"]         == picture.file.name
      assert json_response(res, 200)["data"]["picture"]["size"]         == 5024
      assert json_response(res, 200)["data"]["picture"]["url"]          =~ public_endpoint
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

    test "picture/3 returns the information on a picture - `Absinthe.run`" do
      %Picture{id: id} = picture = insert(:picture)
      context = %{}
      public_endpoint = Application.get_env(:core, Core.Uploaders.S3)[:public_endpoint]

      query = """
      {
        picture(id: \"#{id}\") {
          id
          content_type
          name
          size
          url
        }
      }
      """

      {:ok, %{data: %{"picture" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]           == picture.id
      assert found["content_type"] == picture.file.content_type
      assert found["name"]         == picture.file.name
      assert found["size"]         == 5024
      assert found["url"]          =~ public_endpoint
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

    test "picture/3 returns nothing on a non-existent picture - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      {
        picture(id: \"#{id}\") {
          id
          content_type
          name
          size
          url
        }
      }
      """

      res =
        build_conn()
        |> get("/graphiql", AbsintheHelpers.query_skeleton(query, "picture"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Picture with ID #{id} was not found"
    end

    test "picture/3 returns nothing on a non-existent picture - `Absinthe.run`" do
      id = FlakeId.get()
      context = %{}

      query = """
      {
        picture(id: \"#{id}\") {
          id
          content_type
          name
          size
          url
        }
      }
      """

      {:ok, %{data: %{"picture" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == nil
    end
  end

  describe "Resolver: Upload picture" do
    test "upload_picture/3 uploads a new picture - `AbsintheHelpers`" do
      profile = insert(:profile, logo: nil)
      user = Accounts.get_user!(profile.user_id)
      picture = %{name: "my pic", alt: "represents something", file: "picture.png"}

      query = """
      mutation { uploadPicture(
          alt: \"#{picture.alt}\",
          file: \"#{picture.file}\",
          name: \"#{picture.name}\",
          profileId: \"#{profile.user_id}\"
        ) {
          id
          content_type
          name
          size
          url
        }
      }
      """

      map = %{
        "query" => query,
        picture.file => %Plug.Upload{
          content_type: "image/png",
          filename: picture.file,
          path: @image_path
        }
      }

      res =
        build_conn()
        |> auth_conn(user)
        |> put_req_header("content-type", "multipart/form-data")
        |> post("/graphiql", map)

      assert json_response(res, 200)["data"]["uploadPicture"]["name"]         == picture.name
      assert json_response(res, 200)["data"]["uploadPicture"]["content_type"] == "image/png"
      assert json_response(res, 200)["data"]["uploadPicture"]["size"]         == 40_02
      assert json_response(res, 200)["data"]["uploadPicture"]["url"]
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(json_response(res, 200)["data"]["uploadPicture"]["url"])
    end

    test "upload_picture/3 uploads a new picture - `Absinthe.run`" do
    end

    test "upload_picture/3 forbids uploading if no auth - AbsintheHelpers" do
      profile = build(:profile)
      picture = %{name: "my pic", alt: "represents something", file: "picture.png"}

      query = """
      mutation { uploadPicture(
          alt: \"#{picture.alt}\",
          file: \"#{picture.file}\",
          name: \"#{picture.name}\",
          profileId: \"#{profile.user_id}\"
        ) {
          id
          content_type
          name
          size
          url
        }
      }
      """

      map = %{
        "query" => query,
        picture.file => %Plug.Upload{
          content_type: "image/png",
          filename: picture.file,
          path: @image_path
        }
      }

      res =
        build_conn()
        |> put_req_header("content-type", "multipart/form-data")
        |> post("/graphiql", map)

      assert hd(json_response(res, 200)["errors"])["message"] == "Unauthenticated"
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

    test "upload_picture/3 forbids uploading if no auth - Absinthe.run" do
    end
  end

  describe "Resolver: Update picture" do
  end

  describe "Resolver: Delete picture" do
    it "delete specific picture by profile_id - `AbsintheHelpers`" do
      %Picture{profile_id: profile_id} = picture = insert(:picture)
      user = Core.Accounts.User.find_by(id: picture.profile_id)

      query = """
      mutation { deletePicture(
          profileId: \"#{profile_id}\"
        ) {
          id
        }
      }
      """

      res =
        build_conn()
        |> auth_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deletePicture"]
      assert deleted["id"] == picture.id
    end

    it "delete specific picture by profile_id - `Absinthe.run`" do
      %Picture{profile_id: profile_id} = picture = insert(:picture)
      user = Core.Accounts.User.find_by(id: picture.profile_id)
      context = %{current_user: user}

      query = """
      mutation { deletePicture(
          profileId: \"#{profile_id}\"
        ) {
          id
        }
      }
      """

      {:ok, %{data: %{"deletePicture" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted["id"] == picture.id
    end

    it "returns not found when picture does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()
      %Picture{profile_id: profile_id} = insert(:picture)
      user = Core.Accounts.User.find_by(id: profile_id)

      query = """
      mutation { deletePicture(
          profileId: \"#{id}\"
        ) {
          id
        }
      }
      """

      res =
        build_conn()
        |> auth_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "permission denied"
    end

    it "returns not found when picture does not exist - `Absinthe.run" do
      id = FlakeId.get()
      %Picture{profile_id: profile_id} = insert(:picture)
      user = Core.Accounts.User.find_by(id: profile_id)
      context = %{current_user: user}

      query = """
      mutation { deletePicture(
          profileId: \"#{id}\"
        ) {
          id
        }
      }
      """

      {:ok, %{data: %{"deletePicture" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      %Picture{profile_id: profile_id} = insert(:picture)
      user = Core.Accounts.User.find_by(id: profile_id)

      query = """
      mutation { deletePicture(
          profileId: id
        ) {
          id
        }
      }
      """

      res =
        build_conn()
        |> auth_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == [%{
          "locations" => [%{
              "column" => 0,
              "line" => 2
            }],
          "message" => "Argument \"profileId\" has invalid value id."
        }]
    end
  end

  describe "#dataloads" do
    it "created Picture" do
      profile = insert(:profile)
      source = Dataloader.Ecto.new(Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:pictures, source)
        |> Dataloader.load(:pictures, Profile, profile.user_id)
        |> Dataloader.run

      data = Dataloader.get(loader, :pictures, Profile, profile.user_id)

      assert data.id == profile.user_id
    end
  end
end

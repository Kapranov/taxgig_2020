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

  @bernie_path Path.absname("../core/test/fixtures/bernie.jpg")
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
    it "update specific picture by id - `AbsintheHelpers`" do
      struct = insert(:picture)
      user = Core.Accounts.User.find_by(id: struct.profile_id)
      public_endpoint = Application.get_env(:core, Core.Uploaders.S3)[:public_endpoint]
      picture = %{name: "Time for #NeverBernie", alt: "I woke up this morning wondering whether it’s time to unfurl the #NeverBernie banner.", file: "bernie.jpg"}

      query = """
      {
        updatePicture(
          profileId: \"#{struct.profile_id}\",
          file: {
            picture: {
              alt: \"#{picture.alt}\",
              file: \"#{picture.file}\",
              name: \"#{picture.name}\"
            }
          }
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
        "query" => "mutation #{query}",
        picture.file => %Plug.Upload{
          filename: picture.file,
          path: @bernie_path
        }
      }

      res =
        build_conn()
        |> auth_conn(user)
        |> put_req_header("content-type", "multipart/form-data")
        |> post("/graphiql", map)

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updatePicture"]

      assert updated["id"]           == struct.id
      assert updated["content_type"] == "image/jpg"
      assert updated["name"]         == "Logo"
      assert updated["size"]         == 5024
      assert updated["url"]          =~ public_endpoint
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(updated["url"])
    end

    it "update specific picture by id - `Absinthe.run`" do
      struct = insert(:picture)
      user = Core.Accounts.User.find_by(id: struct.profile_id)
      public_endpoint = Application.get_env(:core, Core.Uploaders.S3)[:public_endpoint]
      context = %{current_user: user}
      picture = %{name: "Time for #NeverBernie", alt: "I woke up this morning wondering whether it’s time to unfurl the #NeverBernie banner.", file: "bernie.jpg"}

      query = """
      mutation f(
          $profile: String!,
          $input: PictureInputObject
        ) {
        updatePicture(
          profileId: $profile,
          file: {
            picture: $input
          }
        ) {
          id
          content_type
          name
          size
          url
        }
      }
      """

      variables = %{
        picture => %Plug.Upload{
          content_type: "image/jpg",
          filename: picture.file,
          path: @bernie_path
        },
        "profile" => struct.profile_id,
        "PictureInputObject" => %{
          "alt" => picture.alt,
          "file" => picture.file,
          "name" => picture.name
        },
      }

      {:ok, %{data: %{"updatePicture" => updated}}} =
        Absinthe.run(query, Schema, [context: context, operation_name: "f", variables: variables])

      assert updated["id"]           == struct.id
      assert updated["content_type"] == "image/jpg"
      assert updated["name"]         == "Logo"
      assert updated["size"]         == 5024
      assert updated["url"]          =~ public_endpoint
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(updated["url"])
    end

    it "nothing change for missing params - `AbsintheHelpers`" do
      struct = insert(:picture)
      user = Core.Accounts.User.find_by(id: struct.profile_id)

      query = """
      {
        updatePicture(
          profileId: \"#{struct.profile_id}\"
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
        "query" => "mutation #{query}"
      }

      res =
        build_conn()
        |> auth_conn(user)
        |> put_req_header("content-type", "multipart/form-data")
        |> post("/graphiql", map)

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updatePicture"]

      assert updated["id"]           == struct.id
      assert updated["content_type"] == struct.file.content_type
      assert updated["name"]         == struct.file.name
      assert updated["size"]         == struct.file.size
      assert updated["url"]          == struct.file.url
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(updated["url"])
    end

    it "nothing change for missing params - `Absinthe.run`" do
      struct = insert(:picture)
      user = Core.Accounts.User.find_by(id: struct.profile_id)
      context = %{current_user: user}

      query = """
      mutation f(
          $profile: String!
        ) {
        updatePicture(
          profileId: $profile
        ) {
          id
          content_type
          name
          size
          url
        }
      }
      """

      variables = %{"profile" => struct.profile_id}

      {:ok, %{data: %{"updatePicture" => updated}}} =
        Absinthe.run(query, Schema, [context: context, operation_name: "f", variables: variables])

      assert updated["id"]           == struct.id
      assert updated["content_type"] == struct.file.content_type
      assert updated["name"]         == struct.file.name
      assert updated["size"]         == struct.file.size
      assert updated["url"]          =~ struct.file.url
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(updated["url"])
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:picture)
      user = Core.Accounts.User.find_by(id: struct.profile_id)

      query = """
      mutation {
        updatePicture(
          profileId: nil,
          file: {
            picture: {
              alt: nil,
              file: nil,
              name: nil
            }
          }
        ) {
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
        |> auth_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == [
        %{"locations" => [%{
              "column" => 0,
              "line" => 3
            }
          ],
          "message" => "Argument \"profileId\" has invalid value nil."
        },
        %{
          "locations" => [%{
              "column" => 0,
              "line" => 4
            }
          ],
          "message" => "Argument \"file\" has invalid value {picture: {alt: nil, file: nil, name: nil}}.\nIn field \"picture\": Expected type \"PictureInputObject\", found {alt: nil, file: nil, name: nil}.\nIn field \"alt\": Expected type \"String\", found nil.\nIn field \"file\": Expected type \"Upload!\", found nil.\nIn field \"name\": Expected type \"String!\", found nil."
        }]
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

    it "returns error for missing params - `Absinthe.run`" do
      struct = insert(:picture)
      user = Core.Accounts.User.find_by(id: struct.profile_id)
      context = %{current_user: user}

      query = """
      mutation {
        updatePicture(
          profileId: nil,
          file: {
            picture: nil
          }
        ) {
          id
          content_type
          name
          size
          url
        }
      }
      """

      variables = %{}

      {:ok, %{errors: [%{
              locations: [%{column: 0, line: 3}],
              message: "Argument \"profileId\" has invalid value nil."
            }]
        }} = Absinthe.run(query, Schema, [context: context, variables: variables])

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

    test "update_picture/3 forbids uploading if no auth - AbsintheHelpers" do
      struct = insert(:picture)
      user = insert(:tp_user)
      picture = %{name: "Time for #NeverBernie", alt: "I woke up this morning wondering whether it’s time to unfurl the #NeverBernie banner.", file: "bernie.jpg"}

      query = """
      {
        updatePicture(
          profileId: \"#{struct.profile_id}\",
          file: {
            picture: {
              alt: \"#{picture.alt}\",
              file: \"#{picture.file}\",
              name: \"#{picture.name}\"
            }
          }
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
        "query" => "mutation #{query}",
        picture.file => %Plug.Upload{
          filename: picture.file,
          path: @bernie_path
        }
      }

      res =
        build_conn()
        |> auth_conn(user)
        |> put_req_header("content-type", "multipart/form-data")
        |> post("/graphiql", map)

      assert hd(json_response(res, 200)["errors"])["message"] == "permission denied"

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

    test "update_picture/3 forbids uploading if no auth - `Absinthe.run`" do
      struct = insert(:picture)
      user = insert(:tp_user)
      context = %{current_user: user}
      picture = %{name: "Time for #NeverBernie", alt: "I woke up this morning wondering whether it’s time to unfurl the #NeverBernie banner.", file: "bernie.jpg"}

      query = """
      mutation f(
          $profile: String!,
          $input: PictureInputObject
        ) {
        updatePicture(
          profileId: $profile,
          file: {
            picture: $input
          }
        ) {
          id
          content_type
          name
          size
          url
        }
      }
      """

      variables = %{
        picture => %Plug.Upload{
          content_type: "image/jpg",
          filename: picture.file,
          path: @bernie_path
        },
        "profile" => struct.profile_id,
        "PictureInputObject" => %{
          "alt" => picture.alt,
          "file" => picture.file,
          "name" => picture.name
        },
      }

      {:ok, %{data: %{"updatePicture" => updated}}} =
        Absinthe.run(query, Schema, [context: context, operation_name: "f", variables: variables])

      assert updated == nil

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

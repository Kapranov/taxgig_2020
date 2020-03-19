defmodule ServerWeb.GraphQL.Integration.Media.PictureIntegrationTest do
  use ServerWeb.ConnCase

  alias Core.{
    Accounts,
    Accounts.Profile,
    Media.Picture,
    Repo
  }
  alias Ecto.UUID
  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  @image_path Path.absname("../core/test/fixtures/picture.png")

  describe "Resolver: Get picture" do
    test "picture/3 returns the information on a picture - `AbsintheHelpers`" do
      %Picture{id: id} = picture = insert(:picture)

      query = """
      {
        picture(id: \"#{id}\") {
          alt
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

      assert json_response(res, 200)["data"]["picture"]["name"]         == picture.file.name
      assert json_response(res, 200)["data"]["picture"]["content_type"] == picture.file.content_type
      assert json_response(res, 200)["data"]["picture"]["size"]         == 5024
      assert json_response(res, 200)["data"]["picture"]["url"]          =~ ServerWeb.Endpoint.url()
    end

    test "picture/3 returns the information on a picture - `Absinthe.run`" do
      %Picture{id: id} = picture = insert(:picture)
      context = %{}

      query = """
      {
        picture(id: \"#{id}\") {
          alt
          content_type
          name
          size
          url
        }
      }
      """

      {:ok, %{data: %{"picture" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["content_type"] == picture.file.content_type
      assert found["name"]         == picture.file.name
      assert found["size"]         == 5024
      assert found["url"]          =~ ServerWeb.Endpoint.url()
    end


    test "picture/3 returns nothing on a non-existent picture - `AbsintheHelpers`" do
      id = UUID.generate()

      query = """
      {
        picture(id: \"#{id}\") {
          alt
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
      id = UUID.generate()
      context = %{}

      query = """
      {
        picture(id: \"#{id}\") {
          alt
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
      assert json_response(res, 200)["data"]["uploadPicture"]["size"]         == 10_097
      assert json_response(res, 200)["data"]["uploadPicture"]["url"]
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
    end

    test "upload_picture/3 forbids uploading if no auth - Absinthe.run" do
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

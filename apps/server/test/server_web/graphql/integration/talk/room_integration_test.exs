defmodule ServerWeb.GraphQL.Integration.Talk.RoomIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns rooms - `AbsintheHelpers`" do
      struct = insert(:room)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      {
        rooms {
          id
          description
          name
          topic
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "rooms"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["rooms"]

      assert List.first(data)["id"]          == struct.id
      assert List.first(data)["description"] == struct.description
      assert List.first(data)["name"]        == struct.name
      assert List.first(data)["topic"]       == struct.topic
    end

    it "returns rooms - `Absinthe.run`" do
      struct = insert(:room)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      {
        rooms{
          id
          description
          name
          topic
        }
      }
      """

      {:ok, %{data: %{"rooms" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]          == struct.id
      assert first["description"] == struct.description
      assert first["name"]        == struct.name
      assert first["topic"]       == struct.topic
    end
  end

  describe "#create" do
    it "creates room - `AbsintheHelpers`" do
      struct = insert(:user)
      user = Core.Accounts.User.find_by(id: struct.id)
      query = """
      mutation {
        createRoom(
          description: "some description",
          name: "some name",
          topic: "some topic"
        ) {
          id
          description
          name
          topic
        }
      }
      """

      res =
        build_conn()
        |> auth_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createRoom"]

      assert created["description"] == "some description"
      assert created["name"]        == "some name"
      assert created["topic"]       == "some topic"
    end

    it "creates faq category - `Absinthe.run`" do
      struct = insert(:user)
      user = Core.Accounts.User.find_by(id: struct.id)
      context = %{current_user: user}
      query = """
      mutation {
        createRoom(
          description: "some description",
          name: "some name",
          topic: "some topic"
        ) {
          id
          description
          name
          topic
        }
      }
      """

      {:ok, %{data: %{"createRoom" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["description"] == "some description"
      assert created["name"]        == "some name"
      assert created["topic"]       == "some topic"
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:user)
      user = Core.Accounts.User.find_by(id: struct.id)
      query = """
      mutation {
        createRoom(
          description: nil,
          name: nil,
          topic: nil
        ) {
          description
          name
          topic
        }
      }
      """

      res =
        build_conn()
        |> auth_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"description\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      struct = insert(:user)
      user = Core.Accounts.User.find_by(id: struct.id)
      context = %{current_user: user}

      query = """
      mutation{
        createRoom(
          description: nil,
          name: nil,
          topic: nil
        ) {
          description
          name
          topic
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"description\" has invalid value nil."
    end
  end
end

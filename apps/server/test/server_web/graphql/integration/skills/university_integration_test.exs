defmodule ServerWeb.GraphQL.Integration.Skills.UniversityIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns universities - `AbsintheHelpers`" do
      struct = insert(:university)

      query = """
      { allUniversities { id name } }
      """
      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allUniversities"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allUniversities"]

      assert List.first(data)["id"]   == struct.id
      assert List.first(data)["name"] == struct.name

      assert List.last(data)["id"]   == struct.id
      assert List.last(data)["name"] == struct.name
    end

    it "returns universities - `Absinthe.run`" do
      struct = insert(:university)

      query = """
      { allUniversities { id name } }
      """

      {:ok, %{data: %{"allUniversities" => data}}} =
        Absinthe.run(query, Schema, context: %{})

      first = hd(data)

      assert first["id"]   == struct.id
      assert first["name"] == struct.name
    end
  end

  describe "#show" do
    it "returns specific university by id - `AbsintheHelpers`" do
      struct = insert(:university)

      query = """
      { showUniversity(id: \"#{struct.id}\") { id name } }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showUniversity"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showUniversity"]

      assert found["id"]   == struct.id
      assert found["name"] == struct.name
    end

    it "returns specific university by id - `Absinthe.run`" do
      struct = insert(:university)

      query = """
      { showUniversity(id: \"#{struct.id}\") { id name } }
      """

      {:ok, %{data: %{"showUniversity" => found}}} =
        Absinthe.run(query, Schema, context: %{})

      assert found["id"]   == struct.id
      assert found["name"] == struct.name
    end

    it "returns not found when university does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      { showUniversity(id: \"#{id}\") { id name } }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showUniversity"))

      assert hd(json_response(res, 200)["errors"])["message"] == "The University #{id} not found!"
    end

    it "returns not found when university does not exist - `Absinthe.run`" do
      id = FlakeId.get()

      query = """
      { showUniversity(id: \"#{id}\") { id name } }
      """

      {:ok, %{data: %{"showUniversity" => found}}} =
        Absinthe.run(query, Schema, context: %{})

      assert found == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      insert(:university)

      query = """
      { showUniversity(id: nil) { id name } }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showUniversity"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      query = """
      { showUniversity(id: nil) { id name } }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: %{})

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  describe "#create" do
    it "creates university - `AbsintheHelpers`" do
      query = """
      mutation {createUniversity(name: "some text") { id name }}
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createUniversity"]

      assert created["name"] == "some text"
    end

    it "creates university - `Absinthe.run`" do
      query = """
      mutation {createUniversity(name: "some text") { id name }}
      """

      {:ok, %{data: %{"createUniversity" => created}}} =
        Absinthe.run(query, Schema, context: %{})

      assert created["name"] == "some text"
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {createUniversity(name: nil) { id name }}
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"name\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      query = """
      mutation {createUniversity(name: nil) { id name }}
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: %{})

      assert hd(error).message == "Argument \"name\" has invalid value nil."
    end
  end

  describe "#delete" do
    it "delete specific university by id - `AbsintheHelpers`" do
      struct = insert(:university)

      query = """
      mutation {deleteUniversity(id: \"#{struct.id}\") {id}}
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteUniversity"]
      assert deleted["id"] == struct.id
    end

    it "delete specific university by id - `Absinthe.run`" do
      struct = insert(:university)

      query = """
      mutation {deleteUniversity(id: \"#{struct.id}\") {id}}
      """

      {:ok, %{data: %{"deleteUniversity" => deleted}}} =
        Absinthe.run(query, Schema, context: %{})

      assert deleted["id"] == struct.id
    end

    it "returns not found when university does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      mutation {deleteUniversity(id: \"#{id}\") {id}}
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "The University #{id} not found!"
    end

    it "returns not found when university does not exist - `Absinthe.run`" do
      id = FlakeId.get()

      query = """
      mutation {deleteUniversity(id: \"#{id}\") {id}}
      """

      {:ok, %{data: %{"deleteUniversity" => deleted}}} =
        Absinthe.run(query, Schema, context: %{})

      assert deleted == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {deleteUniversity(id: nil) {id}}
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      query = """
      mutation {deleteUniversity(id: nil) {id}}
      """

      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: %{})
      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end
end

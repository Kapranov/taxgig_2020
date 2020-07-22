defmodule ServerWeb.GraphQL.Integration.Localization.LanguageIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns languages - `AbsintheHelpers`" do
      struct_a = insert(:language)
      struct_b = insert(:language, abbr: "fra", name: "french")

      query = """
      {
        allLanguages{
          id
          abbr
          name
        }
      }
      """
      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allLanguages"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allLanguages"]

      assert List.first(data)["id"]          == struct_a.id
      assert List.first(data)["abbr"]        == struct_a.abbr
      assert List.first(data)["name"]        == struct_a.name

      assert List.last(data)["id"]          == struct_b.id
      assert List.last(data)["abbr"]        == struct_b.abbr
      assert List.last(data)["name"]        == struct_b.name
    end

    it "returns languages - `Absinthe.run`" do
      struct_a = insert(:language)
      struct_b = insert(:language, abbr: "fra", name: "french")

      context = %{}

      query = """
      {
        allLanguages{
          id
          abbr
          name
        }
      }
      """

      {:ok, %{data: %{"allLanguages" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]          == struct_a.id
      assert first["abbr"]        == struct_a.abbr
      assert first["name"]        == struct_a.name

      [second] = tl(data)

      assert second["id"]          == struct_b.id
      assert second["abbr"]        == struct_b.abbr
      assert second["name"]        == struct_b.name
    end
  end

  describe "#show" do
    it "returns specific language by id - `AbsintheHelpers`" do
      struct = insert(:language)

      query = """
      {
        showLanguage(id: \"#{struct.id}\") {
          id
          abbr
          name
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showLanguage"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showLanguage"]

      assert found["id"]          == struct.id
      assert found["abbr"]        == struct.abbr
      assert found["name"]        == struct.name
    end

    it "returns specific language by id - `Absinthe.run`" do
      struct = insert(:language)

      context = %{}

      query = """
      {
        showLanguage(id: \"#{struct.id}\") {
          id
          abbr
          name
        }
      }
      """

      {:ok, %{data: %{"showLanguage" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]          == struct.id
      assert found["abbr"]        == struct.abbr
      assert found["name"]        == struct.name
    end

    it "returns not found when language does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      {
        showLanguage(id: \"#{id}\") {
          id
          abbr
          name
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showLanguage"))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Language #{id} not found!"
    end

    it "returns not found when language does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      context = %{}

      query = """
      {
        showLanguage(id: \"#{id}\") {
          id
          abbr
          name
        }
      }
      """

      {:ok, %{data: %{"showLanguage" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      {
        showLanguage(id: nil) {
          id
          abbr
          name
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showLanguage"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      {
        showLanguage(id: nil) {
          id
          abbr
          name
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  describe "#create" do
    it "creates language - `AbsintheHelpers`" do
      query = """
      mutation {
        createLanguage(
          abbr: "some text",
          name: "some text"
        ) {
          id
          abbr
          name
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createLanguage"]

      assert created["abbr"] == "some text"
      assert created["name"] == "some text"
    end

    it "creates language - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        createLanguage(
          abbr: "some text",
          name: "some text"
        ) {
          id
          abbr
          name
        }
      }
      """

      {:ok, %{data: %{"createLanguage" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["abbr"] == "some text"
      assert created["name"] == "some text"
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        createLanguage(
          abbr: nil,
          name: nil
        ) {
          id
          abbr
          name
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"abbr\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        createLanguage(
          abbr: nil,
          name: nil
        ) {
          id
          abbr
          name
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"abbr\" has invalid value nil."
    end
  end

  describe "#update" do
    it "update specific language by id - `AbsintheHelpers`" do
      struct = insert(:language)

      query = """
      mutation {
        updateLanguage(
          id: \"#{struct.id}\",
          language: {
            abbr: "updated text",
            name: "updated text"
          }
        ) {
          id
          abbr
          name
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateLanguage"]

      assert updated["id"]          == struct.id
      assert updated["abbr"]        == "updated text"
      assert updated["name"]        == "updated text"
    end

    it "update specific language by id - `Absinthe.run`" do
      struct = insert(:language)
      context = %{}

      query = """
      mutation {
        updateLanguage(
          id: \"#{struct.id}\",
          language: {
            abbr: "updated text",
            name: "updated text"
          }
        ) {
          id
          abbr
          name
        }
      }
      """

      {:ok, %{data: %{"updateLanguage" => updated}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]          == struct.id
      assert updated["abbr"]        == "updated text"
      assert updated["name"]        == "updated text"
    end

    it "nothing change for missing params - `AbsintheHelpers`" do
      struct = insert(:language)

      query = """
      mutation {
        updateLanguage(
          id: \"#{struct.id}\",
          language: {}
        ) {
          id
          abbr
          name
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateLanguage"]

      assert updated["id"]          == struct.id
      assert updated["abbr"]        == struct.abbr
      assert updated["name"]        == struct.name
    end

    it "nothing change for missing params - `Absinthe.run`" do
      struct = insert(:language)
      context = %{}

      query = """
      mutation {
        updateLanguage(
          id: \"#{struct.id}\",
          language: {}
        ) {
          id
          abbr
          name
        }
      }
      """

      {:ok, %{data: %{"updateLanguage" => updated}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]          == struct.id
      assert updated["abbr"]        == struct.abbr
      assert updated["name"]        == struct.name
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        updateLanguage(
          id: nil,
          language: {}
        ) {
          id
          abbr
          name
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        updateLanguage(
          id: nil,
          language: {}
        ) {
          id
          abbr
          name
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  describe "#delete" do
    it "delete specific language by id - `AbsintheHelpers`" do
      struct = insert(:language)

      query = """
      mutation {
        deleteLanguage(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteLanguage"]
      assert deleted["id"] == struct.id
    end

    it "delete specific language by id - `Absinthe.run`" do
      struct = insert(:language)
      context = %{}

      query = """
      mutation {
        deleteLanguage(id: \"#{struct.id}\") {id}
      }
      """

      {:ok, %{data: %{"deleteLanguage" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted["id"] == struct.id
    end

    it "returns not found when language does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      mutation {
        deleteLanguage(id: \"#{id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Language #{id} not found!"
    end

    it "returns not found when language does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      context = %{}

      query = """
      mutation {
        deleteLanguage(id: \"#{id}\") {id}
      }
      """

      {:ok, %{data: %{"deleteLanguage" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        deleteLanguage(id: nil) {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        deleteLanguage(id: nil) {id}
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end
end

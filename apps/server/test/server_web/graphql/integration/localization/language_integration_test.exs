defmodule ServerWeb.GraphQL.Integration.Localization.LanguageIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns languages" do
      struct_a = insert(:language)
      struct_b = insert(:language, abbr: "fra", name: "french")

      context = %{}

      query = """
      {
        allLanguages{
          id
          abbr
          name
          inserted_at
          updated_at
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
      assert List.first(data)["inserted_at"] == format_time(struct_a.inserted_at)
      assert List.first(data)["updated_at"]  == format_time(struct_a.updated_at)

      assert List.last(data)["id"]          == struct_b.id
      assert List.last(data)["abbr"]        == struct_b.abbr
      assert List.last(data)["name"]        == struct_b.name
      assert List.last(data)["inserted_at"] == format_time(struct_b.inserted_at)
      assert List.last(data)["updated_at"]  == format_time(struct_b.updated_at)

      {:ok, %{data: %{"allLanguages" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]          == struct_a.id
      assert first["abbr"]        == struct_a.abbr
      assert first["name"]        == struct_a.name
      assert first["inserted_at"] == format_time(struct_a.inserted_at)
      assert first["updated_at"]  == format_time(struct_a.updated_at)

      [second] = tl(data)

      assert second["id"]          == struct_b.id
      assert second["abbr"]        == struct_b.abbr
      assert second["name"]        == struct_b.name
      assert second["inserted_at"] == format_time(struct_b.inserted_at)
      assert second["updated_at"]  == format_time(struct_b.updated_at)
    end
  end

  describe "#show" do
    it "returns specific language by id" do
      struct = insert(:language)

      context = %{}

      query = """
      {
        showLanguage(id: \"#{struct.id}\") {
          id
          abbr
          name
          inserted_at
          updated_at
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
      assert found["inserted_at"] == format_time(struct.inserted_at)
      assert found["updated_at"]  == format_time(struct.updated_at)

      {:ok, %{data: %{"showLanguage" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]          == struct.id
      assert found["abbr"]        == struct.abbr
      assert found["name"]        == struct.name
      assert found["inserted_at"] == format_time(struct.inserted_at)
      assert found["updated_at"]  == format_time(struct.updated_at)
    end

    it "returns not found when language does not exist" do
      id =  Ecto.UUID.generate()

      query = """
      {
        showLanguage(id: \"#{id}\") {
          id
          abbr
          name
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showLanguage"))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Language #{id} not found!"
    end

    it "returns error for missing params" do
    end
  end

  describe "#create" do
    it "creates language" do
      mutation = """
      {
        createLanguage(
          abbr: "some text",
          name: "some text"
        ) {
          id
          abbr
          name
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createLanguage"]

      assert created["abbr"] == "some text"
      assert created["name"] == "some text"
    end

    it "returns error for missing params" do
    end
  end

  describe "#update" do
    it "update specific language by id" do
      struct = insert(:language)

      mutation = """
      {
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
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateLanguage"]

      assert updated["id"]          == struct.id
      assert updated["abbr"]        == "updated text"
      assert updated["name"]        == "updated text"
    end

    it "nothing change for missing params" do
    end

    it "returns error for missing params" do
    end
  end

  describe "#delete" do
    it "delete specific language by id" do
      struct = insert(:language)

      mutation = """
      {
        deleteLanguage(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteLanguage"]
      assert deleted["id"] == struct.id
    end

    it "returns not found when language does not exist" do
      id = Ecto.UUID.generate()

      mutation = """
      {
        deleteLanguage(id: \"#{id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Language #{id} not found!"
    end

    it "returns error for missing params" do
    end
  end

  defp format_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

defmodule ServerWeb.GraphQL.Integration.Landing.VacancyIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns vacancies" do
      struct_a = insert(:vacancy)
      struct_b = insert(:vacancy)

      context = %{}

      query = """
      {
        allVacancies{
          id
          content
          department
          title
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allVacancies"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allVacancies"]

      assert List.first(data)["id"]          == struct_a.id
      assert List.first(data)["content"]     == struct_a.content
      assert List.first(data)["department"]  == struct_a.department
      assert List.first(data)["title"]       == struct_a.title
      assert List.first(data)["inserted_at"] == format_time(struct_a.inserted_at)
      assert List.first(data)["updated_at"]  == format_time(struct_a.updated_at)

      assert List.last(data)["id"]          == struct_b.id
      assert List.last(data)["content"]     == struct_b.content
      assert List.last(data)["department"]  == struct_b.department
      assert List.last(data)["title"]       == struct_b.title
      assert List.last(data)["inserted_at"] == format_time(struct_b.inserted_at)
      assert List.last(data)["updated_at"]  == format_time(struct_b.updated_at)

      {:ok, %{data: %{"allVacancies" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]          == struct_a.id
      assert first["content"]     == struct_a.content
      assert first["department"]  == struct_a.department
      assert first["title"]       == struct_a.title
      assert first["inserted_at"] == format_time(struct_a.inserted_at)
      assert first["updated_at"]  == format_time(struct_a.updated_at)

      [second] = tl(data)

      assert second["id"]          == struct_b.id
      assert second["content"]     == struct_b.content
      assert second["department"]  == struct_b.department
      assert second["title"]       == struct_b.title
      assert second["inserted_at"] == format_time(struct_b.inserted_at)
      assert second["updated_at"]  == format_time(struct_b.updated_at)
    end
  end

  describe "#show" do
    it "returns specific vacancy by id" do
      struct = insert(:vacancy)

      context = %{}

      query = """
      {
        showVacancy(id: \"#{struct.id}\") {
          id
          content
          department
          title
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showVacancy"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showVacancy"]

      assert found["id"]          == struct.id
      assert found["content"]     == struct.content
      assert found["department"]  == struct.department
      assert found["title"]       == struct.title
      assert found["inserted_at"] == format_time(struct.inserted_at)
      assert found["updated_at"]  == format_time(struct.updated_at)

      {:ok, %{data: %{"showVacancy" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]          == struct.id
      assert found["content"]     == struct.content
      assert found["department"]  == struct.department
      assert found["title"]       == struct.title
      assert found["inserted_at"] == format_time(struct.inserted_at)
      assert found["updated_at"]  == format_time(struct.updated_at)
    end

    it "returns not found when vacancy does not exist" do
      id =  Ecto.UUID.generate()

      query = """
      {
        showVacancy(id: \"#{id}\") {
          id
          content
          department
          title
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showVacancy"))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Vacancy #{id} not found!"
    end

    it "returns error for missing params" do
    end
  end

  describe "#create" do
    it "creates vacancy" do
      mutation = """
      {
        createVacancy(
          content: "some text",
          department: "some text",
          title: "some text"
        ) {
          id
          content
          department
          title
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createVacancy"]

      assert created["content"]    == "some text"
      assert created["department"] == "some text"
      assert created["title"]      == "some text"
    end

    it "returns error for missing params" do
    end
  end

  describe "#update" do
    it "update specific vacancy by id" do
      struct = insert(:vacancy)

      mutation = """
      {
        updateVacancy(
          id: \"#{struct.id}\",
          vacancy: {
            content: "updated text",
            department: "updated text",
            title: "updated text"
          }
        ) {
          id
          content
          department
          title
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateVacancy"]

      assert updated["id"]          == struct.id
      assert updated["content"]     == "updated text"
      assert updated["department"]  == "updated text"
      assert updated["title"]       == "updated text"
      assert updated["inserted_at"] == format_time(struct.inserted_at)
      assert updated["updated_at"]  == format_time(struct.updated_at)
    end

    it "nothing change for missing params" do
    end

    it "returns error for missing params" do
    end
  end

  describe "#delete" do
    it "delete specific vacancy by id" do
      struct = insert(:vacancy)

      mutation = """
      {
        deleteVacancy(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteVacancy"]
      assert deleted["id"] == struct.id
    end

    it "returns not found when vacancy does not exist" do
      id = Ecto.UUID.generate()

      mutation = """
      {
        deleteVacancy(id: \"#{id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Vacancy #{id} not found!"
    end

    it "returns error for missing params" do
    end
  end

  defp format_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

defmodule ServerWeb.GraphQL.Integration.Landing.VacancyIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns vacancies - `AbsintheHelpers`" do
      struct_a = insert(:vacancy)
      struct_b = insert(:vacancy)

      query = """
      {
        allVacancies{
          id
          content
          department
          title
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

      assert List.last(data)["id"]          == struct_b.id
      assert List.last(data)["content"]     == struct_b.content
      assert List.last(data)["department"]  == struct_b.department
      assert List.last(data)["title"]       == struct_b.title
    end

    it "returns vacancies - `Absinthe.run`" do
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
        }
      }
      """

      {:ok, %{data: %{"allVacancies" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]          == struct_a.id
      assert first["content"]     == struct_a.content
      assert first["department"]  == struct_a.department
      assert first["title"]       == struct_a.title

      [second] = tl(data)

      assert second["id"]          == struct_b.id
      assert second["content"]     == struct_b.content
      assert second["department"]  == struct_b.department
      assert second["title"]       == struct_b.title
    end
  end

  describe "#show" do
    it "returns specific vacancy by id - `AbsintheHelpers`" do
      struct = insert(:vacancy)

      query = """
      {
        showVacancy(id: \"#{struct.id}\") {
          id
          content
          department
          title
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
    end

    it "returns specific vacancy by id - `Absinthe.run`" do
      struct = insert(:vacancy)
      context = %{}

      query = """
      {
        showVacancy(id: \"#{struct.id}\") {
          id
          content
          department
          title
        }
      }
      """

      {:ok, %{data: %{"showVacancy" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]          == struct.id
      assert found["content"]     == struct.content
      assert found["department"]  == struct.department
      assert found["title"]       == struct.title
    end

    it "returns not found when vacancy does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      {
        showVacancy(id: \"#{id}\") {
          id
          content
          department
          title
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showVacancy"))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Vacancy #{id} not found!"
    end

    it "returns not found when vacancy does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      context = %{}

      query = """
      {
        showVacancy(id: \"#{id}\") {
          id
          content
          department
          title
        }
      }
      """

      {:ok, %{data: %{"showVacancy" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      {
        showVacancy(id: nil) {
          id
          content
          department
          title
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showVacancy"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      {
        showVacancy(id: nil) {
          id
          content
          department
          title
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  describe "#create" do
    it "creates vacancy - `AbsintheHelpers`" do
      query = """
      mutation {
        createVacancy(
          content: "some text",
          department: "some text",
          title: "some text"
        ) {
          id
          content
          department
          title
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createVacancy"]

      assert created["content"]    == "some text"
      assert created["department"] == "some text"
      assert created["title"]      == "some text"
    end

    it "creates vacancy - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        createVacancy(
          content: "some text",
          department: "some text",
          title: "some text"
        ) {
          id
          content
          department
          title
        }
      }
      """

      {:ok, %{data: %{"createVacancy" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["content"]    == "some text"
      assert created["department"] == "some text"
      assert created["title"]      == "some text"
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        createVacancy(
          content: nil,
          department: nil,
          title: nil
        ) {
          id
          content
          department
          title
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"content\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        createVacancy(
          content: nil,
          department: nil,
          title: nil
        ) {
          id
          content
          department
          title
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"content\" has invalid value nil."
    end
  end

  describe "#update" do
    it "update specific vacancy by id - `AbsintheHelpers`" do
      struct = insert(:vacancy)

      query = """
      mutation {
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
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateVacancy"]

      assert updated["id"]          == struct.id
      assert updated["content"]     == "updated text"
      assert updated["department"]  == "updated text"
      assert updated["title"]       == "updated text"
    end

    it "update specific vacancy by id - `Absinthe.run`" do
      struct = insert(:vacancy)
      context = %{}

      query = """
      mutation {
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
        }
      }
      """

      {:ok, %{data: %{"updateVacancy" => updated}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]          == struct.id
      assert updated["content"]     == "updated text"
      assert updated["department"]  == "updated text"
      assert updated["title"]       == "updated text"
    end

    it "nothing change for missing params - `AbsintheHelpers`" do
      struct = insert(:vacancy)

      query = """
      mutation {
        updateVacancy(
          id: \"#{struct.id}\",
          vacancy: {}
        ) {
          id
          content
          department
          title
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateVacancy"]

      assert updated["id"]          == struct.id
      assert updated["content"]     == struct.content
      assert updated["department"]  == struct.department
      assert updated["title"]       == struct.title
    end

    it "nothing change for missing params - `Absinthe.run`" do
      struct = insert(:vacancy)
      context = %{}

      query = """
      mutation {
        updateVacancy(
          id: \"#{struct.id}\",
          vacancy: {}
        ) {
          id
          content
          department
          title
        }
      }
      """

      {:ok, %{data: %{"updateVacancy" => updated}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]          == struct.id
      assert updated["content"]     == struct.content
      assert updated["department"]  == struct.department
      assert updated["title"]       == struct.title
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        updateVacancy(
          id: nil,
          vacancy: {}
        ) {
          id
          content
          department
          title
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
        updateVacancy(
          id: nil,
          vacancy: {}
        ) {
          id
          content
          department
          title
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  describe "#delete" do
    it "delete specific vacancy by id - `AbsintheHelpers`" do
      struct = insert(:vacancy)

      query = """
      mutation {
        deleteVacancy(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteVacancy"]
      assert deleted["id"] == struct.id
    end

    it "delete specific vacancy by id - `Absinthe.run`" do
      struct = insert(:vacancy)
      context = %{}

      query = """
      mutation {
        deleteVacancy(id: \"#{struct.id}\") {id}
      }
      """

      {:ok, %{data: %{"deleteVacancy" => deleted}}} =
        Absinthe.run(query, Schema, context: context)
      assert deleted["id"] == struct.id
    end

    it "returns not found when vacancy does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      mutation {
        deleteVacancy(id: \"#{id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Vacancy #{id} not found!"
    end

    it "returns not found when vacancy does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      context = %{}

      query = """
      mutation {
        deleteVacancy(id: \"#{id}\") {id}
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "The Vacancy #{id} not found!"
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        deleteVacancy(id: nil) {id}
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
        deleteVacancy(id: nil) {id}
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end
end

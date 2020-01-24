defmodule ServerWeb.GraphQL.Integration.Landing.FaqCategoryIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns faq categories" do
      struct_a = insert(:faq_category)
      struct_b = insert(:faq_category)

      context = %{}

      query = """
      {
        allFaqCategories {
          id
          title
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allFaqCategories"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allFaqCategories"]

      assert List.first(data)["id"]          == struct_a.id
      assert List.first(data)["title"]       == struct_a.title
      assert List.first(data)["inserted_at"] == format_time(struct_a.inserted_at)
      assert List.first(data)["updated_at"]  == format_time(struct_a.updated_at)

      assert List.last(data)["id"]          == struct_b.id
      assert List.last(data)["title"]       == struct_b.title
      assert List.last(data)["inserted_at"] == format_time(struct_b.inserted_at)
      assert List.last(data)["updated_at"]  == format_time(struct_b.updated_at)

      {:ok, %{data: %{"allFaqCategories" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]          == struct_a.id
      assert first["title"]       == struct_a.title
      assert first["inserted_at"] == format_time(struct_a.inserted_at)
      assert first["updated_at"]  == format_time(struct_a.updated_at)

      [second] = tl(data)

      assert second["id"]          == struct_b.id
      assert second["title"]       == struct_b.title
      assert second["inserted_at"] == format_time(struct_b.inserted_at)
      assert second["updated_at"]  == format_time(struct_b.updated_at)
    end
  end

  describe "#show" do
    it "returns specific FaqCategory by id" do
      struct = insert(:faq_category)

      context = %{}

      query = """
      {
        showFaqCategory(id: \"#{struct.id}\") {
          id
          title
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showFaqCategory"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showFaqCategory"]

      assert found["id"]          == struct.id
      assert found["title"]       == struct.title
      assert found["inserted_at"] == format_time(struct.inserted_at)
      assert found["updated_at"]  == format_time(struct.updated_at)

      {:ok, %{data: %{"showFaqCategory" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]          == struct.id
      assert found["title"]       == struct.title
      assert found["inserted_at"] == format_time(struct.inserted_at)
      assert found["updated_at"]  == format_time(struct.updated_at)
    end

    it "returns not found when FaqCategory does not exist" do
      id =  Ecto.UUID.generate()

      query = """
      {
        showFaqCategory(id: \"#{id}\") {
          id
          title
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showFaqCategory"))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Faq Category #{id} not found!"
    end

    it "returns error for missing params" do
    end
  end

  describe "#create" do
    it "creates FaqCategory" do
      mutation = """
      {
        createFaqCategory(
          title: "some text"
        ) {
          id
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

      created = json_response(res, 200)["data"]["createFaqCategory"]

      assert created["title"] == "some text"
    end

    it "returns error for missing params" do
    end
  end

  describe "#update" do
    it "update specific FaqCategory by id" do
      struct = insert(:faq_category)

      mutation = """
      {
        updateFaqCategory(
          id: \"#{struct.id}\",
          faq_category: {
            title: "updated text"
          }
        ) {
          id
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

      updated = json_response(res, 200)["data"]["updateFaqCategory"]

      assert updated["id"]          == struct.id
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
    it "delete specific FaqCategory by id" do
      struct = insert(:faq_category)

      mutation = """
      {
        deleteFaqCategory(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteFaqCategory"]
      assert deleted["id"] == struct.id
    end

    it "returns not found when FaqCategory does not exist" do
      id = Ecto.UUID.generate()

      mutation = """
      {
        deleteFaqCategory(id: \"#{id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Faq Category #{id} not found!"
    end

    it "returns error for missing params" do
    end
  end

  defp format_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

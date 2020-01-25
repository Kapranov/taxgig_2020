defmodule ServerWeb.GraphQL.Integration.Landing.FaqIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns faqs" do
      struct_a = insert(:faq_category)
      struct_b = insert(:faq_category)
      struct_c = insert(:faq, %{faq_categories: struct_a})
      struct_d = insert(:faq, %{faq_categories: struct_b})

      context = %{}

      query = """
      {
        allFaqs {
          id
          content
          title
          inserted_at
          updated_at
          faq_categories {
            id
            title
            inserted_at
            updated_at
          }
        }
      }
      """
      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allFaqs"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allFaqs"]

      assert List.first(data)["id"]          == struct_c.id
      assert List.first(data)["content"]     == struct_c.content
      assert List.first(data)["title"]       == struct_c.title
      assert List.first(data)["inserted_at"] == format_time(struct_c.inserted_at)
      assert List.first(data)["updated_at"]  == format_time(struct_c.updated_at)

      assert List.first(data)["faq_categories"]["id"]          == struct_a.id
      assert List.first(data)["faq_categories"]["title"]       == struct_a.title
      assert List.first(data)["faq_categories"]["inserted_at"] == format_time(struct_a.inserted_at)
      assert List.first(data)["faq_categories"]["updated_at"]  == format_time(struct_a.updated_at)

      assert List.last(data)["id"]          == struct_d.id
      assert List.last(data)["content"]     == struct_d.content
      assert List.last(data)["title"]       == struct_d.title
      assert List.last(data)["inserted_at"] == format_time(struct_d.inserted_at)
      assert List.last(data)["updated_at"]  == format_time(struct_d.updated_at)

      assert List.last(data)["faq_categories"]["id"]          == struct_b.id
      assert List.last(data)["faq_categories"]["title"]       == struct_b.title
      assert List.last(data)["faq_categories"]["inserted_at"] == format_time(struct_b.inserted_at)
      assert List.last(data)["faq_categories"]["updated_at"]  == format_time(struct_b.updated_at)

      {:ok, %{data: %{"allFaqs" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]          == struct_c.id
      assert first["content"]     == struct_c.content
      assert first["title"]       == struct_c.title
      assert first["inserted_at"] == format_time(struct_c.inserted_at)
      assert first["updated_at"]  == format_time(struct_c.updated_at)

      assert first["faq_categories"]["id"]          == struct_a.id
      assert first["faq_categories"]["title"]       == struct_a.title
      assert first["faq_categories"]["inserted_at"] == format_time(struct_a.inserted_at)
      assert first["faq_categories"]["updated_at"]  == format_time(struct_a.updated_at)

      [second] = tl(data)

      assert second["id"]          == struct_d.id
      assert second["content"]     == struct_d.content
      assert second["title"]       == struct_d.title
      assert second["inserted_at"] == format_time(struct_d.inserted_at)
      assert second["updated_at"]  == format_time(struct_d.updated_at)

      assert second["faq_categories"]["id"]          == struct_b.id
      assert second["faq_categories"]["title"]       == struct_b.title
      assert second["faq_categories"]["inserted_at"] == format_time(struct_b.inserted_at)
      assert second["faq_categories"]["updated_at"]  == format_time(struct_b.updated_at)
    end
  end

  describe "#show" do
    it "returns specific faq by id" do
      struct_a = insert(:faq_category)
      struct_b = insert(:faq, %{faq_categories: struct_a})

      context = %{}

      query = """
      {
        showFaq(id: \"#{struct_b.id}\") {
          id
          content
          title
          inserted_at
          updated_at
          faq_categories {
            id
            title
            inserted_at
            updated_at
          }
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showFaq"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showFaq"]

      assert found["id"]          == struct_b.id
      assert found["content"]     == struct_b.content
      assert found["title"]       == struct_b.title
      assert found["inserted_at"] == format_time(struct_b.inserted_at)
      assert found["updated_at"]  == format_time(struct_b.updated_at)

      assert found["faq_categories"]["id"]          == struct_a.id
      assert found["faq_categories"]["title"]       == struct_a.title
      assert found["faq_categories"]["inserted_at"] == format_time(struct_a.inserted_at)
      assert found["faq_categories"]["updated_at"]  == format_time(struct_a.updated_at)

      {:ok, %{data: %{"showFaq" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]          == struct_b.id
      assert found["content"]     == struct_b.content
      assert found["title"]       == struct_b.title
      assert found["inserted_at"] == format_time(struct_b.inserted_at)
      assert found["updated_at"]  == format_time(struct_b.updated_at)
    end

    it "returns not found when faq does not exist" do
      id =  Ecto.UUID.generate()

      query = """
      {
        showFaq(id: \"#{id}\") {
          id
          content
          title
          faq_categories {
            id
            title
            inserted_at
            updated_at
          }
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showFaq"))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Faq #{id} not found!"
    end

    it "returns error for missing params" do
    end
  end

  describe "#search_titles" do
    it "returns searched faq's title" do
      struct_a = insert(:faq_category)
      struct_b = insert(:faq, %{faq_categories: struct_a})

      context = %{}

      query = """
      {
        searchTitles(title: \"#{struct_b.title}\") {
          id
          content
          title
          inserted_at
          updated_at
          faq_categories {
            id
            title
            inserted_at
            updated_at
          }
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "searchTitles"))

      assert json_response(res, 200)["errors"] == nil

      [found] = json_response(res, 200)["data"]["searchTitles"]

      assert found["id"]          == struct_b.id
      assert found["title"]       == struct_b.title
      assert found["content"]     == struct_b.content
      assert found["title"]       == struct_b.title
      assert found["inserted_at"] == format_time(struct_b.inserted_at)
      assert found["updated_at"]  == format_time(struct_b.updated_at)

      assert found["faq_categories"]["id"]          == struct_a.id
      assert found["faq_categories"]["title"]       == struct_a.title
      assert found["faq_categories"]["inserted_at"] == format_time(struct_a.inserted_at)
      assert found["faq_categories"]["updated_at"]  == format_time(struct_a.updated_at)

      {:ok, %{data: %{"searchTitles" => [found]}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]          == struct_b.id
      assert found["content"]     == struct_b.content
      assert found["title"]       == struct_b.title
      assert found["inserted_at"] == format_time(struct_b.inserted_at)
      assert found["updated_at"]  == format_time(struct_b.updated_at)
    end

    it "returns not found when title does not exist" do
      insert(:faq)
      word = "Aloha"

      context = %{}

      query = """
      {
        searchTitles(title: \"#{word}\") {
          id
          content
          title
          inserted_at
          updated_at
          faq_categories {
            id
            title
            inserted_at
            updated_at
          }
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "searchTitles"))

      assert json_response(res, 200)["errors"] == nil
      found = json_response(res, 200)["data"]["searchTitles"]
      assert found == []

      {:ok, %{data: %{"searchTitles" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == []
    end
  end

  describe "#create" do
    it "creates faq" do
      struct = insert(:faq_category)

      mutation = """
      {
        createFaq(
          content: "some text",
          title: "some text",
          faq_categoryId: \"#{struct.id}\"
        ) {
          id
          content
          title
          inserted_at
          updated_at
          faq_categories {
            id
            title
            inserted_at
            updated_at
          }
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createFaq"]

      assert created["content"] == "some text"
      assert created["title"]   == "some text"

      assert created["faq_categories"]["id"]          == struct.id
      assert created["faq_categories"]["title"]       == struct.title
      assert created["faq_categories"]["inserted_at"] == format_time(struct.inserted_at)
      assert created["faq_categories"]["updated_at"]  == format_time(struct.updated_at)
    end

    it "returns error for missing params" do
    end
  end

  describe "#update" do
    it "update specific faq by id" do
      struct_a = insert(:faq_category)
      struct_b = insert(:faq)

      mutation = """
      {
        updateFaq(
          id: \"#{struct_b.id}\",
          faq: {
            content: "updated text",
            title: "updated text",
            faq_categoryId: \"#{struct_a.id}\"
          }
        ) {
          id
          content
          title
          inserted_at
          updated_at
          faq_categories {
            id
            title
            inserted_at
            updated_at
          }
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateFaq"]

      assert updated["id"]          == struct_b.id
      assert updated["content"]     == "updated text"
      assert updated["title"]       == "updated text"
      assert updated["inserted_at"] == format_time(struct_b.inserted_at)
      assert updated["updated_at"]  == format_time(struct_b.updated_at)

      assert updated["faq_categories"]["id"]          == struct_a.id
      assert updated["faq_categories"]["title"]       == struct_a.title
      assert updated["faq_categories"]["inserted_at"] == format_time(struct_a.inserted_at)
      assert updated["faq_categories"]["updated_at"]  == format_time(struct_a.updated_at)
    end

    it "nothing change for missing params" do
    end

    it "returns error for missing params" do
    end
  end

  describe "#delete" do
    it "delete specific faq by id" do
      struct = insert(:faq)

      mutation = """
      {
        deleteFaq(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteFaq"]
      assert deleted["id"] == struct.id
    end

    it "returns not found when FaqCategory does not exist" do
      id = Ecto.UUID.generate()

      mutation = """
      {
        deleteFaq(id: \"#{id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Faq #{id} not found!"
    end

    it "returns error for missing params" do
    end
  end

  defp format_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

defmodule ServerWeb.GraphQL.Integration.Landing.FaqCategoryIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns faq categories - `AbsintheHelpers`" do
      struct = insert(:faq_category)

      query = """
      {
        allFaqCategories {
          id
          faqs_count
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

      assert List.first(data)["id"]          == struct.id
      assert List.first(data)["faqs_count"]  == struct.faqs_count
      assert List.first(data)["title"]       == struct.title
      assert List.first(data)["inserted_at"] == format_time(struct.inserted_at)
      assert List.first(data)["updated_at"]  == format_time(struct.updated_at)

      assert List.last(data)["id"]          == struct.id
      assert List.last(data)["faqs_count"]  == struct.faqs_count
      assert List.last(data)["title"]       == struct.title
      assert List.last(data)["inserted_at"] == format_time(struct.inserted_at)
      assert List.last(data)["updated_at"]  == format_time(struct.updated_at)
    end

    it "returns faq categories - `Absinthe.run`" do
      struct = insert(:faq_category)
      context = %{}

      query = """
      {
        allFaqCategories {
          id
          faqs_count
          title
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{data: %{"allFaqCategories" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]          == struct.id
      assert first["faqs_count"]  == struct.faqs_count
      assert first["title"]       == struct.title
      assert first["inserted_at"] == format_time(struct.inserted_at)
      assert first["updated_at"]  == format_time(struct.updated_at)
    end
  end

  describe "#findFaqCategory" do
    it "found Faq with specific FaqCategory by id - `AbsintheHelpers`" do
      struct_a = insert(:faq_category)
      struct_b = insert(:faq, faq_categories: struct_a)

      query = """
      {
        findFaqCategory(id: \"#{struct_a.id}\") {
          id
          content
          title
          inserted_at
          updated_at
          faq_categories {
            id
            faqs_count
            title
            inserted_at
            updated_at
          }
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findFaqCategory"))

      assert json_response(res, 200)["errors"] == nil

      [found] = json_response(res, 200)["data"]["findFaqCategory"]

      assert json_response(res, 200)["errors"] == nil

      assert found["content"]     == struct_b.content
      assert found["title"]       == struct_b.title
      assert found["inserted_at"] == format_time(struct_b.inserted_at)
      assert found["updated_at"]  == format_time(struct_b.updated_at)

      assert found["faq_categories"]["id"]          == struct_a.id
      assert found["faq_categories"]["faqs_count"]  == 0
      assert found["faq_categories"]["title"]       == struct_a.title
      assert found["faq_categories"]["inserted_at"] == format_time(struct_a.inserted_at)
      assert found["faq_categories"]["updated_at"]  == format_time(struct_a.updated_at)
    end

    it "found Faq with specific FaqCategory by id - `Absinthe.run`" do
      struct_a = insert(:faq_category)
      struct_b = insert(:faq, faq_categories: struct_a)

      context = %{}

      query = """
      {
        findFaqCategory(id: \"#{struct_a.id}\") {
          id
          content
          title
          inserted_at
          updated_at
          faq_categories {
            id
            faqs_count
            title
            inserted_at
            updated_at
          }
        }
      }
      """

      {:ok, %{data: %{"findFaqCategory" => [found]}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["content"]     == struct_b.content
      assert found["title"]       == struct_b.title
      assert found["inserted_at"] == format_time(struct_b.inserted_at)
      assert found["updated_at"]  == format_time(struct_b.updated_at)

      assert found["faq_categories"]["id"]          == struct_a.id
      assert found["faq_categories"]["faqs_count"]  == 0
      assert found["faq_categories"]["title"]       == struct_a.title
      assert found["faq_categories"]["inserted_at"] == format_time(struct_a.inserted_at)
      assert found["faq_categories"]["updated_at"]  == format_time(struct_a.updated_at)
    end

    it "returns not found Faq with specific FaqCategory by id - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      {
        findFaqCategory(id: \"#{id}\") {
          id
          content
          title
          inserted_at
          updated_at
          faq_categories {
            id
            faqs_count
            title
            inserted_at
            updated_at
          }
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findFaqCategory"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findFaqCategory"]

      assert found == []
    end

    it "returns not found Faq with specific FaqCategory by id - `Absinthe.run`" do
      id = FlakeId.get()
      context = %{}

      query = """
      {
        findFaqCategory(id: \"#{id}\") {
          id
          content
          title
          inserted_at
          updated_at
          faq_categories {
            id
            faqs_count
            title
            inserted_at
            updated_at
          }
        }
      }
      """

      {:ok, %{data: %{"findFaqCategory" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == []
    end

    it "returns error when nil FaqCategory by id - `AbsintheHelpers`" do
      query = """
      {
        findFaqCategory(id: nil) {
          id
          content
          title
          inserted_at
          updated_at
          faq_categories {
            id
            faqs_count
            title
            inserted_at
            updated_at
          }
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findFaqCategory"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error when nil FaqCategory by id - `Absinthe.run`" do
      context = %{}

      query = """
      {
        findFaqCategory(id: nil) {
          id
          content
          title
          inserted_at
          updated_at
          faq_categories {
            id
            faqs_count
            title
            inserted_at
            updated_at
          }
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  describe "#show" do
    it "returns specific faq category by id - `AbsintheHelpers`" do
      struct = insert(:faq_category)

      query = """
      {
        showFaqCategory(id: \"#{struct.id}\") {
          id
          faqs_count
          title
          inserted_at
          updated_at
          faqs {
            id
            title
            content
          }
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showFaqCategory"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showFaqCategory"]

      assert found["id"]          == struct.id
      assert found["faqs_count"]  == struct.faqs_count
      assert found["title"]       == struct.title
      assert found["inserted_at"] == format_time(struct.inserted_at)
      assert found["updated_at"]  == format_time(struct.updated_at)
      assert found["faqs"]        == []

    end

    it "returns specific faq category by id - `Absinthe.run`" do
      struct = insert(:faq_category)
      context = %{}

      query = """
      {
        showFaqCategory(id: \"#{struct.id}\") {
          id
          faqs_count
          title
          inserted_at
          updated_at
          faqs {
            id
            title
            content
          }
        }
      }
      """

      {:ok, %{data: %{"showFaqCategory" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]          == struct.id
      assert found["faqs_count"]  == struct.faqs_count
      assert found["title"]       == struct.title
      assert found["inserted_at"] == format_time(struct.inserted_at)
      assert found["updated_at"]  == format_time(struct.updated_at)
      assert found["faqs"]        == []
    end

    it "returns not found when faq category does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      {
        showFaqCategory(id: \"#{id}\") {
          id
          faqs_count
          title
          inserted_at
          updated_at
          faqs {
            id
            title
            content
          }
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showFaqCategory"))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Faq Category #{id} not found!"
    end

    it "returns not found when faq category does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      context = %{}

      query = """
      {
        showFaqCategory(id: \"#{id}\") {
          id
          faqs_count
          title
          inserted_at
          updated_at
          faqs {
            id
            title
            content
          }
        }
      }
      """

      {:ok, %{data: %{"showFaqCategory" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      {
        showFaqCategory(id: nil) {
          id
          faqs_count
          title
          inserted_at
          updated_at
          faqs {
            id
            title
            content
          }
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showFaqCategory"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      {
        showFaqCategory(id: nil) {
          id
          faqs_count
          title
          inserted_at
          updated_at
          faqs {
            id
            title
            content
          }
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  describe "#create" do
    it "creates faq category - `AbsintheHelpers`" do
      query = """
      mutation {
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
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createFaqCategory"]

      assert created["title"]      == "some text"
      assert created["faqs_count"] == nil
    end

    it "creates faq category - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
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

      {:ok, %{data: %{"createFaqCategory" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["title"]      == "some text"
      assert created["faqs_count"] == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        createFaqCategory(
          title: nil
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
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"title\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        createFaqCategory(
          title: nil
        ) {
          id
          title
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

        assert hd(error).message == "Argument \"title\" has invalid value nil."
    end
  end

  describe "#update" do
    it "update specific faq category by id - `AbsintheHelpers`" do
      struct = insert(:faq_category)

      query = """
      mutation {
        updateFaqCategory(
          id: \"#{struct.id}\",
          faq_category: {
            title: "updated text"
          }
        ) {
          id
          faqs_count
          title
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateFaqCategory"]

      assert updated["id"]          == struct.id
      assert updated["faqs_count"]  == 0
      assert updated["title"]       == "updated text"
      assert updated["inserted_at"] == format_time(struct.inserted_at)
      assert updated["updated_at"]  == format_time(struct.updated_at)
    end

    it "update specific faq category by id - `Absinthe.run`" do
      struct = insert(:faq_category)
      context = %{}

      query = """
      mutation {
        updateFaqCategory(
          id: \"#{struct.id}\",
          faq_category: {
            title: "updated text"
          }
        ) {
          id
          faqs_count
          title
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{data: %{"updateFaqCategory" => updated}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]          == struct.id
      assert updated["faqs_count"]  == 0
      assert updated["title"]       == "updated text"
      assert updated["inserted_at"] == format_time(struct.inserted_at)
      assert updated["updated_at"]  == format_time(struct.updated_at)
    end

    it "return error when title for missing params - `AbsintheHelpers`" do
      struct = insert(:faq_category)

      query = """
      mutation {
        updateFaqCategory(
          id: \"#{struct.id}\",
          faq_category: {}
        ) {
          id
          faqs_count
          title
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"faq_category\" has invalid value {}.\nIn field \"title\": Expected type \"String!\", found null."
    end

    it "return error when title for missing params - `Absinthe.run`" do
      struct = insert(:faq_category)
      context = %{}

      query = """
      mutation {
        updateFaqCategory(
          id: \"#{struct.id}\",
          faq_category: {}
        ) {
          id
          faqs_count
          title
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"faq_category\" has invalid value {}.\nIn field \"title\": Expected type \"String!\", found null."
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        updateFaqCategory(
          id: nil,
          faq_category: {
            title: nil
          }
        ) {
          id
          faqs_count
          title
          inserted_at
          updated_at
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
        updateFaqCategory(
          id: nil,
          faq_category: {
            title: nil
          }
        ) {
          id
          faqs_count
          title
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  describe "#delete" do
    it "delete specific faq category by id - `AbsintheHelpers`" do
      struct = insert(:faq_category)

      query = """
      mutation {
        deleteFaqCategory(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteFaqCategory"]
      assert deleted["id"] == struct.id
    end

    it "delete specific faq category by id - `Absinthe.run`" do
      struct = insert(:faq_category)
      context = %{}

      query = """
      mutation {
        deleteFaqCategory(id: \"#{struct.id}\") {id}
      }
      """

      {:ok, %{data: %{"deleteFaqCategory" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted["id"] == struct.id
    end


    it "returns not found when FaqCategory does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      mutation {
        deleteFaqCategory(id: \"#{id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Faq Category #{id} not found!"
    end

    it "returns not found when FaqCategory does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      context = %{}

      query = """
      mutation {
        deleteFaqCategory(id: \"#{id}\") {id}
      }
      """

      {:ok, %{data: %{"deleteFaqCategory" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted == nil
    end


    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        deleteFaqCategory(id: nil) {id}
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
        deleteFaqCategory(id: nil) {id}
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  defp format_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

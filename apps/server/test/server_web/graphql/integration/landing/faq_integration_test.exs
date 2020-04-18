defmodule ServerWeb.GraphQL.Integration.Landing.FaqIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns faqs - `AbsintheHelpers`" do
      struct_a = insert(:faq_category)
      struct_b = insert(:faq_category)
      struct_c = insert(:faq, %{faq_categories: struct_a})
      struct_d = insert(:faq, %{faq_categories: struct_b})

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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allFaqs"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allFaqs"]

      assert List.first(data)["id"]          == struct_c.id
      assert List.first(data)["content"]     == struct_c.content
      assert List.first(data)["title"]       == struct_c.title
      assert List.first(data)["inserted_at"] == format_time(struct_c.inserted_at)
      assert List.first(data)["updated_at"]  == format_time(struct_c.updated_at)

      assert List.first(data)["faq_categories"]["id"]          == struct_a.id
      assert List.first(data)["faq_categories"]["faqs_count"]  == 0
      assert List.first(data)["faq_categories"]["title"]       == struct_a.title
      assert List.first(data)["faq_categories"]["inserted_at"] == format_time(struct_a.inserted_at)
      assert List.first(data)["faq_categories"]["updated_at"]  == format_time(struct_a.updated_at)

      assert List.last(data)["id"]          == struct_d.id
      assert List.last(data)["content"]     == struct_d.content
      assert List.last(data)["title"]       == struct_d.title
      assert List.last(data)["inserted_at"] == format_time(struct_d.inserted_at)
      assert List.last(data)["updated_at"]  == format_time(struct_d.updated_at)

      assert List.last(data)["faq_categories"]["id"]          == struct_b.id
      assert List.last(data)["faq_categories"]["faqs_count"]  == 0
      assert List.last(data)["faq_categories"]["title"]       == struct_b.title
      assert List.last(data)["faq_categories"]["inserted_at"] == format_time(struct_b.inserted_at)
      assert List.last(data)["faq_categories"]["updated_at"]  == format_time(struct_b.updated_at)
    end

    it "returns faqs - `Absinthe.run`" do
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
            faqs_count
            title
            inserted_at
            updated_at
          }
        }
      }
      """

      {:ok, %{data: %{"allFaqs" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]          == struct_c.id
      assert first["content"]     == struct_c.content
      assert first["title"]       == struct_c.title
      assert first["inserted_at"] == format_time(struct_c.inserted_at)
      assert first["updated_at"]  == format_time(struct_c.updated_at)

      assert first["faq_categories"]["id"]          == struct_a.id
      assert first["faq_categories"]["faqs_count"]  == 0
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
      assert second["faq_categories"]["faqs_count"]  == 0
      assert second["faq_categories"]["title"]       == struct_b.title
      assert second["faq_categories"]["inserted_at"] == format_time(struct_b.inserted_at)
      assert second["faq_categories"]["updated_at"]  == format_time(struct_b.updated_at)
    end
  end

  describe "#show" do
    it "returns specific faq by id - `AbsintheHelpers`" do
      struct_a = insert(:faq_category)
      struct_b = insert(:faq, %{faq_categories: struct_a})

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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showFaq"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showFaq"]

      assert found["id"]          == struct_b.id
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

    it "returns specific faq by id - `Absinthe.run`" do
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
            faqs_count
            title
            inserted_at
            updated_at
          }
        }
      }
      """

      {:ok, %{data: %{"showFaq" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]          == struct_b.id
      assert found["content"]     == struct_b.content
      assert found["title"]       == struct_b.title
      assert found["inserted_at"] == format_time(struct_b.inserted_at)
      assert found["updated_at"]  == format_time(struct_b.updated_at)
    end

    it "returns not found when faq does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      {
        showFaq(id: \"#{id}\") {
          id
          content
          title
          faq_categories {
            id
            faqs_count
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

    it "returns not found when faq does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      context = %{}

      query = """
      {
        showFaq(id: \"#{id}\") {
          id
          content
          title
          faq_categories {
            id
            faqs_count
            title
            inserted_at
            updated_at
          }
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{data: %{"showFaq" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      {
        showFaq(id: nil) {
          id
          content
          title
          faq_categories {
            id
            faqs_count
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

      assert json_response(res, 200)["errors"] == [
        %{"locations" => [%{"column" => 0, "line" => 2}],
          "message" => "Argument \"id\" has invalid value nil."}
      ]
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      {
        showFaq(id: nil) {
          id
          content
          title
          faq_categories {
            id
            faqs_count
            title
            inserted_at
            updated_at
          }
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert error == [
        %{locations: [%{column: 0, line: 2}],
          message: "Argument \"id\" has invalid value nil."}
      ]
    end
  end

  describe "#search_titles" do
    it "returns searched faq's title - `AbsintheHelpers`" do
      struct_a = insert(:faq_category)
      struct_b = insert(:faq, %{faq_categories: struct_a})

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
      assert found["faq_categories"]["faqs_count"]  == 0
      assert found["faq_categories"]["title"]       == struct_a.title
      assert found["faq_categories"]["inserted_at"] == format_time(struct_a.inserted_at)
      assert found["faq_categories"]["updated_at"]  == format_time(struct_a.updated_at)
    end

    it "returns searched faq's title - `Absinthe.run`" do
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
            faqs_count
            title
            inserted_at
            updated_at
          }
        }
      }
      """

      {:ok, %{data: %{"searchTitles" => [found]}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]          == struct_b.id
      assert found["content"]     == struct_b.content
      assert found["title"]       == struct_b.title
      assert found["inserted_at"] == format_time(struct_b.inserted_at)
      assert found["updated_at"]  == format_time(struct_b.updated_at)
    end

    it "returns not found when title does not exist - `AbsintheHelpers`" do
      insert(:faq)
      word = "Aloha"

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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "searchTitles"))

      assert json_response(res, 200)["errors"] == nil
      found = json_response(res, 200)["data"]["searchTitles"]
      assert found == []
    end

    it "returns not found when title does not exist - `Absinthe.run`" do
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
            faqs_count
            title
            inserted_at
            updated_at
          }
        }
      }
      """

      {:ok, %{data: %{"searchTitles" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == []
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      {
        searchTitles(title: nil) {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "searchTitles"))

      assert json_response(res, 200)["errors"] == [
        %{"locations" => [%{"column" => 0, "line" => 2}],
          "message" => "Argument \"title\" has invalid value nil."}
      ]
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      {
        searchTitles(title: nil) {
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

      assert error == [
        %{locations: [%{column: 0, line: 2}],
          message: "Argument \"title\" has invalid value nil."}
      ]
    end
  end

  describe "#create" do
    it "creates faq - `AbsintheHelpers`" do
      struct = insert(:faq_category)

      query = """
      mutation {
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
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createFaq"]

      assert created["content"] == "some text"
      assert created["title"]   == "some text"

      assert created["faq_categories"]["id"]          == struct.id
      assert created["faq_categories"]["faqs_count"]  == 0
      assert created["faq_categories"]["title"]       == struct.title
      assert created["faq_categories"]["inserted_at"] == format_time(struct.inserted_at)
      assert created["faq_categories"]["updated_at"]  == format_time(struct.updated_at)
    end

    it "creates faq - `Absinthe.run`" do
      struct = insert(:faq_category)
      context = %{}

      query = """
      mutation {
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
            faqs_count
            title
            inserted_at
            updated_at
          }
        }
      }
      """

      {:ok, %{data: %{"createFaq" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["content"] == "some text"
      assert created["title"]   == "some text"

      assert created["faq_categories"]["id"]          == struct.id
      assert created["faq_categories"]["faqs_count"]  == 0
      assert created["faq_categories"]["title"]       == struct.title
      assert created["faq_categories"]["inserted_at"] == format_time(struct.inserted_at)
      assert created["faq_categories"]["updated_at"]  == format_time(struct.updated_at)
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        createFaq(
          content: nil,
          title: nil,
          faq_categoryId: nil
        ) {
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
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == [
        %{"locations" => [%{"column" => 0, "line" => 3}],
          "message" => "Argument \"content\" has invalid value nil."},
        %{"locations" => [%{"column" => 0, "line" => 4}],
          "message" => "Argument \"title\" has invalid value nil."},
        %{"locations" => [%{"column" => 0, "line" => 5}],
          "message" => "Argument \"faq_categoryId\" has invalid value nil."}
      ]
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        createFaq(
          content: nil,
          title: nil,
          faq_categoryId: nil
        ) {
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

      assert error == [
        %{locations: [%{column: 0, line: 3}],
          message: "Argument \"content\" has invalid value nil."},
        %{locations: [%{column: 0, line: 4}],
          message: "Argument \"title\" has invalid value nil."},
        %{locations: [%{column: 0, line: 5}],
          message: "Argument \"faq_categoryId\" has invalid value nil."}
      ]
    end
  end

  describe "#update" do
    it "update specific faq by id - `AbsintheHelpers`" do
      struct_a = insert(:faq_category)
      struct_b = insert(:faq)

      query = """
      mutation {
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
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateFaq"]

      assert updated["id"]          == struct_b.id
      assert updated["content"]     == "updated text"
      assert updated["title"]       == "updated text"
      assert updated["inserted_at"] == format_time(struct_b.inserted_at)
      assert updated["updated_at"]  == format_time(struct_b.updated_at)

      assert updated["faq_categories"]["id"]          == struct_a.id
      assert updated["faq_categories"]["faqs_count"]  == 0
      assert updated["faq_categories"]["title"]       == struct_a.title
      assert updated["faq_categories"]["inserted_at"] == format_time(struct_a.inserted_at)
      assert updated["faq_categories"]["updated_at"]  == format_time(struct_a.updated_at)
    end

    it "update specific faq by id - `Absinthe.run`" do
      struct_a = insert(:faq_category)
      struct_b = insert(:faq)
      context = %{}

      query = """
      mutation {
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
            faqs_count
            title
            inserted_at
            updated_at
          }
        }
      }
      """

      {:ok, %{data: %{"updateFaq" => updated}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]          == struct_b.id
      assert updated["content"]     == "updated text"
      assert updated["title"]       == "updated text"
      assert updated["inserted_at"] == format_time(struct_b.inserted_at)
      assert updated["updated_at"]  == format_time(struct_b.updated_at)

      assert updated["faq_categories"]["id"]          == struct_a.id
      assert updated["faq_categories"]["faqs_count"]  == 0
      assert updated["faq_categories"]["title"]       == struct_a.title
      assert updated["faq_categories"]["inserted_at"] == format_time(struct_a.inserted_at)
      assert updated["faq_categories"]["updated_at"]  == format_time(struct_a.updated_at)
    end

    it "return error faq for missing params - `AbsintheHelpers`" do
      struct = insert(:faq)

      query = """
      mutation {
        updateFaq(
          id: \"#{struct.id}\",
          faq: {}
        ) {
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
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == [
        %{"locations" => [%{"column" => 0, "line" => 4}],
          "message" => "Argument \"faq\" has invalid value {}.\nIn field \"faqCategoryId\": Expected type \"String!\", found null."}
      ]
    end

    it "return error faq for missing params - `Absinthe.run`" do
      struct = insert(:faq)
      context = %{}

      query = """
      mutation {
        updateFaq(
          id: \"#{struct.id}\",
          faq: {}
        ) {
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

      assert error == [
        %{locations: [%{column: 0, line: 4}],
          message: "Argument \"faq\" has invalid value {}.\nIn field \"faqCategoryId\": Expected type \"String!\", found null."}
      ]
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        updateFaq(
          id: nil,
          faq: {
            content: nil,
            title: nil,
            faq_categoryId: nil
          }
        ) {
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
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == [
        %{"locations" => [%{"column" => 0, "line" => 3}],
          "message" => "Argument \"id\" has invalid value nil."},
        %{"locations" => [%{"column" => 0, "line" => 4}],
          "message" => "Argument \"faq\" has invalid value {content: nil, title: nil, faq_categoryId: nil}.\nIn field \"content\": Expected type \"String\", found nil.\nIn field \"title\": Expected type \"String\", found nil.\nIn field \"faq_categoryId\": Expected type \"String!\", found nil."}
      ]
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        updateFaq(
          id: nil,
          faq: {
            content: nil,
            title: nil,
            faq_categoryId: nil
          }
        ) {
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

      assert error == [
        %{locations: [%{column: 0, line: 3}],
          message: "Argument \"id\" has invalid value nil."},
        %{locations: [%{column: 0, line: 4}],
          message: "Argument \"faq\" has invalid value {content: nil, title: nil, faq_categoryId: nil}.\nIn field \"content\": Expected type \"String\", found nil.\nIn field \"title\": Expected type \"String\", found nil.\nIn field \"faq_categoryId\": Expected type \"String!\", found nil."}
      ]
    end
  end

  describe "#delete" do
    it "delete specific faq by id - `AbsintheHelpers`" do
      struct = insert(:faq)

      query = """
      mutation {
        deleteFaq(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteFaq"]
      assert deleted["id"] == struct.id
    end

    it "delete specific faq by id - `Absinthe.run`" do
      struct = insert(:faq)
      context = %{}

      query = """
      mutation {
        deleteFaq(id: \"#{struct.id}\") {id}
      }
      """

      {:ok, %{data: %{"deleteFaq" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted["id"] == struct.id
    end

    it "returns not found when FaqCategory does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      mutation {
        deleteFaq(id: \"#{id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Faq #{id} not found!"
    end

    it "returns not found when FaqCategory does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      context = %{}

      query = """
      mutation {
        deleteFaq(id: \"#{id}\") {id}
      }
      """

      {:ok, %{data: %{"deleteFaq" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        deleteFaq(id: nil) {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == [
        %{"locations" => [%{"column" => 0, "line" => 2}],
          "message" => "Argument \"id\" has invalid value nil."}
      ]
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        deleteFaq(id: nil) {id}
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert error == [
        %{locations: [%{column: 0, line: 2}],
          message: "Argument \"id\" has invalid value nil."}
      ]
    end
  end

  defp format_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

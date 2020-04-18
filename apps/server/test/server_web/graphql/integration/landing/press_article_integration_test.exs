defmodule ServerWeb.GraphQL.Integration.Landing.PressArticleIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns press articles - `AbsintheHelpers`" do
      struct_a = insert(:press_article)
      struct_b = insert(:press_article)

      query = """
      {
        allPressArticles{
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allPressArticles"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allPressArticles"]

      assert List.first(data)["id"]           == struct_a.id
      assert List.first(data)["author"]       == struct_a.author
      assert List.first(data)["img_url"]      == struct_a.img_url
      assert List.first(data)["preview_text"] == struct_a.preview_text
      assert List.first(data)["title"]        == struct_a.title
      assert List.first(data)["url"]          == struct_a.url
      assert List.first(data)["inserted_at"]  == format_time(struct_a.inserted_at)
      assert List.first(data)["updated_at"]   == format_time(struct_a.updated_at)

      assert List.last(data)["id"]           == struct_b.id
      assert List.last(data)["author"]       == struct_b.author
      assert List.last(data)["img_url"]      == struct_b.img_url
      assert List.last(data)["preview_text"] == struct_b.preview_text
      assert List.last(data)["title"]        == struct_b.title
      assert List.last(data)["url"]          == struct_b.url
      assert List.last(data)["inserted_at"]  == format_time(struct_b.inserted_at)
      assert List.last(data)["updated_at"]   == format_time(struct_b.updated_at)
    end

    it "returns press articles - `Absinthe.run`" do
      struct_a = insert(:press_article)
      struct_b = insert(:press_article)

      context = %{}

      query = """
      {
        allPressArticles{
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{data: %{"allPressArticles" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]           == struct_a.id
      assert first["author"]       == struct_a.author
      assert first["img_url"]      == struct_a.img_url
      assert first["preview_text"] == struct_a.preview_text
      assert first["title"]        == struct_a.title
      assert first["url"]          == struct_a.url
      assert first["inserted_at"]  == format_time(struct_a.inserted_at)
      assert first["updated_at"]   == format_time(struct_a.updated_at)

      [second] = tl(data)

      assert second["id"]           == struct_b.id
      assert second["author"]       == struct_b.author
      assert second["img_url"]      == struct_b.img_url
      assert second["preview_text"] == struct_b.preview_text
      assert second["title"]        == struct_b.title
      assert second["url"]          == struct_b.url
      assert second["inserted_at"]  == format_time(struct_b.inserted_at)
      assert second["updated_at"]   == format_time(struct_b.updated_at)
    end
  end

  describe "#show" do
    it "returns specific press article by id - `AbsintheHelpers`" do
      struct = insert(:press_article)

      query = """
      {
        showPressArticle(id: \"#{struct.id}\") {
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showPressArticle"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showPressArticle"]

      assert found["id"]           == struct.id
      assert found["author"]       == struct.author
      assert found["img_url"]      == struct.img_url
      assert found["preview_text"] == struct.preview_text
      assert found["title"]        == struct.title
      assert found["url"]          == struct.url
      assert found["inserted_at"]  == format_time(struct.inserted_at)
      assert found["updated_at"]   == format_time(struct.updated_at)
    end

    it "returns specific press article by id - `Absinthe.run`" do
      struct = insert(:press_article)

      context = %{}

      query = """
      {
        showPressArticle(id: \"#{struct.id}\") {
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{data: %{"showPressArticle" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]           == struct.id
      assert found["author"]       == struct.author
      assert found["img_url"]      == struct.img_url
      assert found["preview_text"] == struct.preview_text
      assert found["title"]        == struct.title
      assert found["url"]          == struct.url
      assert found["inserted_at"]  == format_time(struct.inserted_at)
      assert found["updated_at"]   == format_time(struct.updated_at)
    end

    it "returns not found when press article does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      {
        showPressArticle(id: \"#{id}\") {
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showPressArticle"))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Press Article #{id} not found!"
    end

    it "returns not found when press article does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      context = %{}

      query = """
      {
        showPressArticle(id: \"#{id}\") {
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{data: %{"showPressArticle" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      {
        showPressArticle(id: nil) {
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showPressArticle"))

      assert json_response(res, 200)["errors"] == [
        %{"locations" => [%{"column" => 0, "line" => 2}],
          "message" => "Argument \"id\" has invalid value nil."}
      ]
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      {
        showPressArticle(id: nil) {
          id
          author
          img_url
          preview_text
          title
          url
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

  describe "#create" do
    it "creates press article - `AbsintheHelpers`" do
      query = """
      mutation {
        createPressArticle(
          author: "some text",
          img_url: "some text",
          preview_text: "some text",
          title: "some text",
          url: "some text"
        ) {
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createPressArticle"]

      assert created["author"]       == "some text"
      assert created["img_url"]      == "some text"
      assert created["preview_text"] == "some text"
      assert created["title"]        == "some text"
      assert created["url"]          == "some text"
    end

    it "creates press article - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        createPressArticle(
          author: "some text",
          img_url: "some text",
          preview_text: "some text",
          title: "some text",
          url: "some text"
        ) {
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{data: %{"createPressArticle" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["author"]       == "some text"
      assert created["img_url"]      == "some text"
      assert created["preview_text"] == "some text"
      assert created["title"]        == "some text"
      assert created["url"]          == "some text"
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        createPressArticle(
          author: nil,
          img_url: nil,
          preview_text: nil,
          title: nil,
          url: nil
        ) {
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == [
        %{"locations" => [%{"column" => 0, "line" => 3}],
          "message" => "Argument \"author\" has invalid value nil."},
        %{"locations" => [%{"column" => 0, "line" => 4}],
          "message" => "Argument \"img_url\" has invalid value nil."},
        %{"locations" => [%{"column" => 0, "line" => 5}],
          "message" => "Argument \"preview_text\" has invalid value nil."},
        %{"locations" => [%{"column" => 0, "line" => 6}],
          "message" => "Argument \"title\" has invalid value nil."},
        %{"locations" => [%{"column" => 0, "line" => 7}],
          "message" => "Argument \"url\" has invalid value nil."}
      ]
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        createPressArticle(
          author: nil,
          img_url: nil,
          preview_text: nil,
          title: nil,
          url: nil
        ) {
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

        assert error == [
          %{locations: [%{column: 0, line: 3}],
            message: "Argument \"author\" has invalid value nil."},
          %{locations: [%{column: 0, line: 4}],
            message: "Argument \"img_url\" has invalid value nil."},
          %{locations: [%{column: 0, line: 5}],
            message: "Argument \"preview_text\" has invalid value nil."},
          %{locations: [%{column: 0, line: 6}],
            message: "Argument \"title\" has invalid value nil."},
          %{locations: [%{column: 0, line: 7}],
            message: "Argument \"url\" has invalid value nil."}
        ]
    end
  end

  describe "#update" do
    it "update specific press article by id - `AbsintheHelpers`" do
      struct = insert(:press_article)

      query = """
      mutation {
        updatePressArticle(
          id: \"#{struct.id}\",
          press_article: {
            author: "updated text",
            img_url: "updated text",
            preview_text: "updated text",
            title: "updated text",
            url: "updated text"
          }
        ) {
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updatePressArticle"]

      assert updated["id"]           == struct.id
      assert updated["author"]       == "updated text"
      assert updated["img_url"]      == "updated text"
      assert updated["preview_text"] == "updated text"
      assert updated["title"]        == "updated text"
      assert updated["url"]          == "updated text"
      assert updated["inserted_at"]  == format_time(struct.inserted_at)
      assert updated["updated_at"]   == format_time(struct.updated_at)
    end

    it "update specific press article by id - `Absinthe.run`" do
      struct = insert(:press_article)
      context = %{}

      query = """
      mutation {
        updatePressArticle(
          id: \"#{struct.id}\",
          press_article: {
            author: "updated text",
            img_url: "updated text",
            preview_text: "updated text",
            title: "updated text",
            url: "updated text"
          }
        ) {
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{data: %{"updatePressArticle" => updated}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]           == struct.id
      assert updated["author"]       == "updated text"
      assert updated["img_url"]      == "updated text"
      assert updated["preview_text"] == "updated text"
      assert updated["title"]        == "updated text"
      assert updated["url"]          == "updated text"
      assert updated["inserted_at"]  == format_time(struct.inserted_at)
      assert updated["updated_at"]   == format_time(struct.updated_at)
    end

    it "nothing change for missing params - `AbsintheHelpers`" do
      struct = insert(:press_article)

      query = """
      mutation {
        updatePressArticle(
          id: \"#{struct.id}\",
          press_article: {}
        ) {
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updatePressArticle"]

      assert updated["id"]           == struct.id
      assert updated["author"]       == struct.author
      assert updated["img_url"]      == struct.img_url
      assert updated["preview_text"] == struct.preview_text
      assert updated["title"]        == struct.title
      assert updated["url"]          == struct.url
      assert updated["inserted_at"]  == format_time(struct.inserted_at)
      assert updated["updated_at"]   == format_time(struct.updated_at)
    end

    it "nothing change for missing params - `Absinthe.run`" do
      struct = insert(:press_article)
      context = %{}

      query = """
      mutation {
        updatePressArticle(
          id: \"#{struct.id}\",
          press_article: {}
        ) {
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{data: %{"updatePressArticle" => updated}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]           == struct.id
      assert updated["author"]       == struct.author
      assert updated["img_url"]      == struct.img_url
      assert updated["preview_text"] == struct.preview_text
      assert updated["title"]        == struct.title
      assert updated["url"]          == struct.url
      assert updated["inserted_at"]  == format_time(struct.inserted_at)
      assert updated["updated_at"]   == format_time(struct.updated_at)
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        updatePressArticle(
          id: nil,
          press_article: {}
        ) {
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == [
        %{"locations" => [%{"column" => 0, "line" => 3}],
          "message" => "Argument \"id\" has invalid value nil."}
      ]
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        updatePressArticle(
          id: nil,
          press_article: {}
        ) {
          id
          author
          img_url
          preview_text
          title
          url
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert error == [
        %{locations: [%{column: 0, line: 3}],
          message: "Argument \"id\" has invalid value nil."}
      ]
    end
  end

  describe "#delete" do
    it "delete specific press article by id - `AbsintheHelpers`" do
      struct = insert(:press_article)

      query = """
      mutation {
        deletePressArticle(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deletePressArticle"]
      assert deleted["id"] == struct.id
    end

    it "delete specific press article by id - `Absinthe.run`" do
      struct = insert(:press_article)
      context = %{}

      query = """
      mutation {
        deletePressArticle(id: \"#{struct.id}\") {id}
      }
      """

      {:ok, %{data: %{"deletePressArticle" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted["id"] == struct.id
    end

    it "returns not found when press article does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      mutation {
        deletePressArticle(id: \"#{id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Press Article #{id} not found!"
    end

    it "returns not found when press article does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      context = %{}

      query = """
      mutation {
        deletePressArticle(id: \"#{id}\") {id}
      }
      """

      {:ok, %{data: %{"deletePressArticle" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        deletePressArticle(id: nil) {id}
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
        deletePressArticle(id: nil) {id}
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

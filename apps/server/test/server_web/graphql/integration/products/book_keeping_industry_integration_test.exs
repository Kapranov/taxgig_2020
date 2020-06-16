defmodule ServerWeb.GraphQL.Integration.Products.BookKeepingIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns BookKeepingIndustry by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      book_keeping_industry = insert(:tp_book_keeping_industry, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        allBookKeepingIndustries {
          id
          inserted_at
          name
          updated_at
          book_keepings {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBookKeepingIndustries"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBookKeepingIndustries"]

      assert List.first(data)["id"]                           == book_keeping_industry.id
      assert List.first(data)["book_keepings"]["id"]          == book_keeping_industry.book_keepings.id
      assert List.first(data)["book_keepings"]["inserted_at"] == formatting_time(book_keeping_industry.book_keepings.inserted_at)
      assert List.first(data)["book_keepings"]["updated_at"]  == formatting_time(book_keeping_industry.book_keepings.updated_at)
      assert List.first(data)["inserted_at"]                  == formatting_time(book_keeping_industry.inserted_at)
      assert List.first(data)["name"]                         == book_keeping_industry.name
      assert List.first(data)["updated_at"]                   == formatting_time(book_keeping_industry.updated_at)

      {:ok, %{data: %{"allBookKeepingIndustries" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                           == book_keeping_industry.id
      assert first["book_keepings"]["id"]          == book_keeping_industry.book_keepings.id
      assert first["book_keepings"]["inserted_at"] == formatting_time(book_keeping_industry.book_keepings.inserted_at)
      assert first["book_keepings"]["updated_at"]  == formatting_time(book_keeping_industry.book_keepings.updated_at)
      assert first["inserted_at"]                  == formatting_time(book_keeping_industry.inserted_at)
      assert first["name"]                         == book_keeping_industry.name
      assert first["updated_at"]                   == formatting_time(book_keeping_industry.updated_at)
    end

    it "returns BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      book_keeping_industry = insert(:pro_book_keeping_industry, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        allBookKeepingIndustries {
          id
          inserted_at
          name
          updated_at
          book_keepings {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBookKeepingIndustries"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBookKeepingIndustries"]

      assert List.first(data)["id"]                           == book_keeping_industry.id
      assert List.first(data)["book_keepings"]["id"]          == book_keeping_industry.book_keepings.id
      assert List.first(data)["book_keepings"]["inserted_at"] == formatting_time(book_keeping_industry.book_keepings.inserted_at)
      assert List.first(data)["book_keepings"]["updated_at"]  == formatting_time(book_keeping_industry.book_keepings.updated_at)
      assert List.first(data)["inserted_at"]                  == formatting_time(book_keeping_industry.inserted_at)
      assert List.first(data)["name"]                         == book_keeping_industry.name
      assert List.first(data)["updated_at"]                   == formatting_time(book_keeping_industry.updated_at)

      {:ok, %{data: %{"allBookKeepingIndustries" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                           == book_keeping_industry.id
      assert first["book_keepings"]["id"]          == book_keeping_industry.book_keepings.id
      assert first["book_keepings"]["inserted_at"] == formatting_time(book_keeping_industry.book_keepings.inserted_at)
      assert first["book_keepings"]["updated_at"]  == formatting_time(book_keeping_industry.book_keepings.updated_at)
      assert first["inserted_at"]                  == formatting_time(book_keeping_industry.inserted_at)
      assert first["name"]                         == book_keeping_industry.name
      assert first["updated_at"]                   == formatting_time(book_keeping_industry.updated_at)
    end
  end

  describe "#show" do
    it "returns specific BookKeepingIndustry by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      book_keeping_industry = insert(:tp_book_keeping_industry, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        showBookKeepingIndustry(id: \"#{book_keeping_industry.id}\") {
          id
          inserted_at
          name
          updated_at
          book_keepings {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      {:ok, %{data: %{"showBookKeepingIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                           == book_keeping_industry.id
      assert found["book_keepings"]["id"]          == book_keeping_industry.book_keepings.id
      assert found["book_keepings"]["inserted_at"] == formatting_time(book_keeping_industry.book_keepings.inserted_at)
      assert found["book_keepings"]["updated_at"]  == formatting_time(book_keeping_industry.book_keepings.updated_at)
      assert found["inserted_at"]                  == formatting_time(book_keeping_industry.inserted_at)
      assert found["name"]                         == book_keeping_industry.name
      assert found["updated_at"]                   == formatting_time(book_keeping_industry.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBookKeepingIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBookKeepingIndustry"]

      assert found["id"]                           == book_keeping_industry.id
      assert found["book_keepings"]["id"]          == book_keeping_industry.book_keepings.id
      assert found["book_keepings"]["inserted_at"] == formatting_time(book_keeping_industry.book_keepings.inserted_at)
      assert found["book_keepings"]["updated_at"]  == formatting_time(book_keeping_industry.book_keepings.updated_at)
      assert found["inserted_at"]                  == formatting_time(book_keeping_industry.inserted_at)
      assert found["name"]                         == book_keeping_industry.name
      assert found["updated_at"]                   == formatting_time(book_keeping_industry.updated_at)
    end

    it "returns specific BookKeepingIndustry by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      book_keeping_industry = insert(:pro_book_keeping_industry, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        showBookKeepingIndustry(id: \"#{book_keeping_industry.id}\") {
          id
          inserted_at
          name
          updated_at
          book_keepings {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      {:ok, %{data: %{"showBookKeepingIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                           == book_keeping_industry.id
      assert found["book_keepings"]["id"]          == book_keeping_industry.book_keepings.id
      assert found["book_keepings"]["inserted_at"] == formatting_time(book_keeping_industry.book_keepings.inserted_at)
      assert found["book_keepings"]["updated_at"]  == formatting_time(book_keeping_industry.book_keepings.updated_at)
      assert found["inserted_at"]                  == formatting_time(book_keeping_industry.inserted_at)
      assert found["name"]                         == book_keeping_industry.name
      assert found["updated_at"]                   == formatting_time(book_keeping_industry.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBookKeepingIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBookKeepingIndustry"]

      assert found["id"]                           == book_keeping_industry.id
      assert found["book_keepings"]["id"]          == book_keeping_industry.book_keepings.id
      assert found["book_keepings"]["inserted_at"] == formatting_time(book_keeping_industry.book_keepings.inserted_at)
      assert found["book_keepings"]["updated_at"]  == formatting_time(book_keeping_industry.book_keepings.updated_at)
      assert found["inserted_at"]                  == formatting_time(book_keeping_industry.inserted_at)
      assert found["name"]                         == book_keeping_industry.name
      assert found["updated_at"]                   == formatting_time(book_keeping_industry.updated_at)
    end
  end

  describe "#find" do
    it "find specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      book_keeping_industry = insert(:tp_book_keeping_industry, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        findBookKeepingIndustry(id: \"#{book_keeping_industry.id}\") {
          id
          inserted_at
          name
          updated_at
          book_keepings {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      {:ok, %{data: %{"findBookKeepingIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                           == book_keeping_industry.id
      assert found["book_keepings"]["id"]          == book_keeping_industry.book_keepings.id
      assert found["book_keepings"]["inserted_at"] == formatting_time(book_keeping_industry.book_keepings.inserted_at)
      assert found["book_keepings"]["updated_at"]  == formatting_time(book_keeping_industry.book_keepings.updated_at)
      assert found["inserted_at"]                  == formatting_time(book_keeping_industry.inserted_at)
      assert found["name"]                         == book_keeping_industry.name
      assert found["updated_at"]                   == formatting_time(book_keeping_industry.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBookKeepingIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBookKeepingIndustry"]

      assert found["id"]                           == book_keeping_industry.id
      assert found["book_keepings"]["id"]          == book_keeping_industry.book_keepings.id
      assert found["book_keepings"]["inserted_at"] == formatting_time(book_keeping_industry.book_keepings.inserted_at)
      assert found["book_keepings"]["updated_at"]  == formatting_time(book_keeping_industry.book_keepings.updated_at)
      assert found["inserted_at"]                  == formatting_time(book_keeping_industry.inserted_at)
      assert found["name"]                         == book_keeping_industry.name
      assert found["updated_at"]                   == formatting_time(book_keeping_industry.updated_at)
    end

    it "find specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      book_keeping_industry = insert(:pro_book_keeping_industry, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        findBookKeepingIndustry(id: \"#{book_keeping_industry.id}\") {
          id
          inserted_at
          name
          updated_at
          book_keepings {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      {:ok, %{data: %{"findBookKeepingIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                           == book_keeping_industry.id
      assert found["book_keepings"]["id"]          == book_keeping_industry.book_keepings.id
      assert found["book_keepings"]["inserted_at"] == formatting_time(book_keeping_industry.book_keepings.inserted_at)
      assert found["book_keepings"]["updated_at"]  == formatting_time(book_keeping_industry.book_keepings.updated_at)
      assert found["inserted_at"]                  == formatting_time(book_keeping_industry.inserted_at)
      assert found["name"]                         == book_keeping_industry.name
      assert found["updated_at"]                   == formatting_time(book_keeping_industry.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBookKeepingIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBookKeepingIndustry"]

      assert found["id"]                           == book_keeping_industry.id
      assert found["book_keepings"]["id"]          == book_keeping_industry.book_keepings.id
      assert found["book_keepings"]["inserted_at"] == formatting_time(book_keeping_industry.book_keepings.inserted_at)
      assert found["book_keepings"]["updated_at"]  == formatting_time(book_keeping_industry.book_keepings.updated_at)
      assert found["inserted_at"]                  == formatting_time(book_keeping_industry.inserted_at)
      assert found["name"]                         == book_keeping_industry.name
      assert found["updated_at"]                   == formatting_time(book_keeping_industry.updated_at)
    end
  end

  describe "#create" do
    it "created BookKeepingIndustry by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})

      mutation = """
      {
        createBookKeepingIndustry(
          name: ["some name"],
          book_keepingId: \"#{book_keeping.id}\"
        ) {
          id
          inserted_at
          name
          updated_at
          book_keepings {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createBookKeepingIndustry"]

      assert created["book_keepings"]["id"] == book_keeping.id
      assert created["inserted_at"]         == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                == ["some name"]
      assert created["updated_at"]          == formatting_time(DateTime.truncate(Timex.now(), :second))
    end

    it "created BookKeepingIndustry by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})

      mutation = """
      {
        createBookKeepingIndustry(
          name: ["some name"],
          book_keepingId: \"#{book_keeping.id}\"
        ) {
          id
          inserted_at
          name
          updated_at
          book_keepings {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createBookKeepingIndustry"]

      assert created["book_keepings"]["id"] == book_keeping.id
      assert created["inserted_at"]         == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                == ["some name"]
      assert created["updated_at"]          == formatting_time(DateTime.truncate(Timex.now(), :second))
    end
  end

  describe "#update" do
    it "updated specific BookKeepingIndustry by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      book_keeping_industry = insert(:book_keeping_industry, %{book_keepings: book_keeping})

      mutation = """
      {
        updateBookKeepingIndustry(
          id: \"#{book_keeping_industry.id}\",
          book_keeping_industry: {
            name: ["updated some name"],
            book_keepingId: \"#{book_keeping.id}\"
          }
        )
        {
          id
          inserted_at
          name
          updated_at
          book_keepings {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateBookKeepingIndustry"]

      assert updated["id"]                           == book_keeping_industry.id
      assert updated["book_keepings"]["id"]          == book_keeping.id
      assert updated["book_keepings"]["inserted_at"] == formatting_time(book_keeping_industry.book_keepings.inserted_at)
      assert updated["book_keepings"]["updated_at"]  == formatting_time(book_keeping_industry.book_keepings.updated_at)
      assert updated["inserted_at"]                  == formatting_time(book_keeping_industry.inserted_at)
      assert updated["name"]                         == ["updated some name"]
    end

    it "updated specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      book_keeping_industry = insert(:book_keeping_industry, %{book_keepings: book_keeping})

      mutation = """
      {
        updateBookKeepingIndustry(
          id: \"#{book_keeping_industry.id}\",
          book_keeping_industry: {
            book_keepingId: \"#{book_keeping.id}\"
            name: ["updated some name"],
          }
        )
        {
          id
          inserted_at
          name
          updated_at
          book_keepings {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateBookKeepingIndustry"]

      assert updated["id"]                           == book_keeping_industry.id
      assert updated["book_keepings"]["id"]          == book_keeping.id
      assert updated["book_keepings"]["inserted_at"] == formatting_time(book_keeping_industry.book_keepings.inserted_at)
      assert updated["book_keepings"]["updated_at"]  == formatting_time(book_keeping_industry.book_keepings.updated_at)
      assert updated["inserted_at"]                  == formatting_time(book_keeping_industry.inserted_at)
      assert updated["name"]                         == ["updated some name"]
      assert updated["updated_at"]                   == formatting_time(book_keeping_industry.updated_at)
    end
  end

  describe "#delete" do
    it "delete specific BookKeepingIndustry" do
      user = insert(:user)
      book_keeping = insert(:book_keeping, %{user: user})
      book_keeping_industry = insert(:book_keeping_industry, %{book_keepings: book_keeping})

      mutation = """
      {
        deleteBookKeepingIndustry(id: \"#{book_keeping_industry.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteBookKeepingIndustry"]
      assert deleted["id"] == book_keeping_industry.id
    end
  end

  describe "#dataloads" do
    it "created BookKeepingIndustry by role's Tp" do
       user = insert(:tp_user)
       %{id: book_keeping_id} = insert(:tp_book_keeping, user: user)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:book_keeping_industries, source)
        |> Dataloader.load(:book_keeping_industries, Core.Services.BookKeeping, book_keeping_id)
        |> Dataloader.run

      data = Dataloader.get(loader, :book_keeping_industries, Core.Services.BookKeeping, book_keeping_id)

      assert data.id == book_keeping_id
    end
  end

  defp formatting_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

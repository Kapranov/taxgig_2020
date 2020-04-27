defmodule ServerWeb.GraphQL.Integration.Products.IndividualStockTransactionCountIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns IndividualStockTransactionCount by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_stock_transaction_count = insert(:tp_individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        allIndividualStockTransactionCounts {
          id
          inserted_at
          name
          updated_at
          individual_tax_returns {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allIndividualStockTransactionCounts"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allIndividualStockTransactionCounts"]

      assert List.first(data)["id"]                                    == individual_stock_transaction_count.id
      assert List.first(data)["inserted_at"]                           == formatting_time(individual_stock_transaction_count.inserted_at)
      assert List.first(data)["name"]                                  == individual_stock_transaction_count.name
      assert List.first(data)["updated_at"]                            == formatting_time(individual_stock_transaction_count.updated_at)
      assert List.first(data)["individual_tax_returns"]["id"]          == individual_stock_transaction_count.individual_tax_returns.id
      assert List.first(data)["individual_tax_returns"]["inserted_at"] == formatting_time(individual_stock_transaction_count.individual_tax_returns.inserted_at)
      assert List.first(data)["individual_tax_returns"]["updated_at"]  == formatting_time(individual_stock_transaction_count.individual_tax_returns.updated_at)

      {:ok, %{data: %{"allIndividualStockTransactionCounts" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == individual_stock_transaction_count.id
      assert first["inserted_at"]                           == formatting_time(individual_stock_transaction_count.inserted_at)
      assert first["name"]                                  == individual_stock_transaction_count.name
      assert first["updated_at"]                            == formatting_time(individual_stock_transaction_count.updated_at)
      assert first["individual_tax_returns"]["id"]          == individual_stock_transaction_count.individual_tax_returns.id
      assert first["individual_tax_returns"]["inserted_at"] == formatting_time(individual_stock_transaction_count.individual_tax_returns.inserted_at)
      assert first["individual_tax_returns"]["updated_at"]  == formatting_time(individual_stock_transaction_count.individual_tax_returns.updated_at)
    end

    it "returns BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_stock_transaction_count = insert(:pro_individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        allIndividualStockTransactionCounts {
          id
          inserted_at
          name
          updated_at
          individual_tax_returns {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allIndividualStockTransactionCounts"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allIndividualStockTransactionCounts"]

      assert List.first(data)["id"]                                    == individual_stock_transaction_count.id
      assert List.first(data)["inserted_at"]                           == formatting_time(individual_stock_transaction_count.inserted_at)
      assert List.first(data)["name"]                                  == individual_stock_transaction_count.name
      assert List.first(data)["updated_at"]                            == formatting_time(individual_stock_transaction_count.updated_at)
      assert List.first(data)["individual_tax_returns"]["id"]          == individual_stock_transaction_count.individual_tax_returns.id
      assert List.first(data)["individual_tax_returns"]["inserted_at"] == formatting_time(individual_stock_transaction_count.individual_tax_returns.inserted_at)
      assert List.first(data)["individual_tax_returns"]["updated_at"]  == formatting_time(individual_stock_transaction_count.individual_tax_returns.updated_at)

      {:ok, %{data: %{"allIndividualStockTransactionCounts" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == individual_stock_transaction_count.id
      assert first["inserted_at"]                           == formatting_time(individual_stock_transaction_count.inserted_at)
      assert first["name"]                                  == individual_stock_transaction_count.name
      assert first["updated_at"]                            == formatting_time(individual_stock_transaction_count.updated_at)
      assert first["individual_tax_returns"]["id"]          == individual_stock_transaction_count.individual_tax_returns.id
      assert first["individual_tax_returns"]["inserted_at"] == formatting_time(individual_stock_transaction_count.individual_tax_returns.inserted_at)
      assert first["individual_tax_returns"]["updated_at"]  == formatting_time(individual_stock_transaction_count.individual_tax_returns.updated_at)
    end
  end

  describe "#show" do
    it "returns specific IndividualStockTransactionCount by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_stock_transaction_count = insert(:tp_individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        showIndividualStockTransactionCount(id: \"#{individual_stock_transaction_count.id}\") {
          id
          inserted_at
          name
          updated_at
          individual_tax_returns {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      {:ok, %{data: %{"showIndividualStockTransactionCount" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_stock_transaction_count.id
      assert found["inserted_at"]                           == formatting_time(individual_stock_transaction_count.inserted_at)
      assert found["name"]                                  == individual_stock_transaction_count.name
      assert found["updated_at"]                            == formatting_time(individual_stock_transaction_count.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_stock_transaction_count.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_stock_transaction_count.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_stock_transaction_count.individual_tax_returns.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showIndividualStockTransactionCount"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showIndividualStockTransactionCount"]

      assert found["id"]                                    == individual_stock_transaction_count.id
      assert found["inserted_at"]                           == formatting_time(individual_stock_transaction_count.inserted_at)
      assert found["name"]                                  == individual_stock_transaction_count.name
      assert found["updated_at"]                            == formatting_time(individual_stock_transaction_count.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_stock_transaction_count.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_stock_transaction_count.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_stock_transaction_count.individual_tax_returns.updated_at)
    end

    it "returns specific IndividualStockTransactionCount by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_stock_transaction_count = insert(:pro_individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        showIndividualStockTransactionCount(id: \"#{individual_stock_transaction_count.id}\") {
          id
          inserted_at
          name
          updated_at
          individual_tax_returns {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      {:ok, %{data: %{"showIndividualStockTransactionCount" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_stock_transaction_count.id
      assert found["inserted_at"]                           == formatting_time(individual_stock_transaction_count.inserted_at)
      assert found["name"]                                  == individual_stock_transaction_count.name
      assert found["updated_at"]                            == formatting_time(individual_stock_transaction_count.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_stock_transaction_count.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_stock_transaction_count.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_stock_transaction_count.individual_tax_returns.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showIndividualStockTransactionCount"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showIndividualStockTransactionCount"]

      assert found["id"]                                    == individual_stock_transaction_count.id
      assert found["inserted_at"]                           == formatting_time(individual_stock_transaction_count.inserted_at)
      assert found["name"]                                  == individual_stock_transaction_count.name
      assert found["updated_at"]                            == formatting_time(individual_stock_transaction_count.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_stock_transaction_count.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_stock_transaction_count.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_stock_transaction_count.individual_tax_returns.updated_at)
    end
  end

  describe "#find" do
    it "find specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_stock_transaction_count = insert(:tp_individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        findIndividualStockTransactionCount(id: \"#{individual_stock_transaction_count.id}\") {
          id
          inserted_at
          name
          updated_at
          individual_tax_returns {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      {:ok, %{data: %{"findIndividualStockTransactionCount" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_stock_transaction_count.id
      assert found["inserted_at"]                           == formatting_time(individual_stock_transaction_count.inserted_at)
      assert found["name"]                                  == individual_stock_transaction_count.name
      assert found["updated_at"]                            == formatting_time(individual_stock_transaction_count.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_stock_transaction_count.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_stock_transaction_count.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_stock_transaction_count.individual_tax_returns.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualStockTransactionCount"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualStockTransactionCount"]

      assert found["id"]                                    == individual_stock_transaction_count.id
      assert found["inserted_at"]                           == formatting_time(individual_stock_transaction_count.inserted_at)
      assert found["name"]                                  == individual_stock_transaction_count.name
      assert found["updated_at"]                            == formatting_time(individual_stock_transaction_count.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_stock_transaction_count.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_stock_transaction_count.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_stock_transaction_count.individual_tax_returns.updated_at)
    end

    it "find specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_stock_transaction_count = insert(:pro_individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        findIndividualStockTransactionCount(id: \"#{individual_stock_transaction_count.id}\") {
          id
          inserted_at
          name
          updated_at
          individual_tax_returns {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      {:ok, %{data: %{"findIndividualStockTransactionCount" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_stock_transaction_count.id
      assert found["inserted_at"]                           == formatting_time(individual_stock_transaction_count.inserted_at)
      assert found["name"]                                  == individual_stock_transaction_count.name
      assert found["updated_at"]                            == formatting_time(individual_stock_transaction_count.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_stock_transaction_count.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_stock_transaction_count.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_stock_transaction_count.individual_tax_returns.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualStockTransactionCount"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualStockTransactionCount"]

      assert found["id"]                                    == individual_stock_transaction_count.id
      assert found["inserted_at"]                           == formatting_time(individual_stock_transaction_count.inserted_at)
      assert found["name"]                                  == individual_stock_transaction_count.name
      assert found["updated_at"]                            == formatting_time(individual_stock_transaction_count.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_stock_transaction_count.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_stock_transaction_count.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_stock_transaction_count.individual_tax_returns.updated_at)
    end
  end

  describe "#create" do
    it "created IndividualStockTransactionCount by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})

      mutation = """
      {
        createIndividualStockTransactionCount(
          individual_tax_returnId: \"#{individual_tax_return.id}\",
          name: "some name"
        ) {
          id
          inserted_at
          name
          updated_at
          individual_tax_returns {
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

      created = json_response(res, 200)["data"]["createIndividualStockTransactionCount"]

      assert created["individual_tax_returns"]["id"] == individual_tax_return.id
      assert created["inserted_at"]                  == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                         == "some name"
      assert created["updated_at"]                   == formatting_time(DateTime.truncate(Timex.now(), :second))
    end

    it "created IndividualStockTransactionCount by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})

      mutation = """
      {
        createIndividualStockTransactionCount(
          individual_tax_returnId: \"#{individual_tax_return.id}\",
          name: "some name"
        ) {
          id
          inserted_at
          name
          updated_at
          individual_tax_returns {
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

      created = json_response(res, 200)["data"]["createIndividualStockTransactionCount"]

      assert created["individual_tax_returns"]["id"] == individual_tax_return.id
      assert created["inserted_at"]                  == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                         == "some name"
      assert created["updated_at"]                   == formatting_time(DateTime.truncate(Timex.now(), :second))
    end
  end

  describe "#update" do
    it "updated specific IndividualStockTransactionCount by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_stock_transaction_count = insert(:individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})

      mutation = """
      {
        updateIndividualStockTransactionCount(
          id: \"#{individual_stock_transaction_count.id}\",
          individual_stock_transaction_count: {
            individual_tax_returnId: \"#{individual_tax_return.id}\",
            name: "updated some name"
          }
        )
        {
          id
          inserted_at
          name
          updated_at
          individual_tax_returns {
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

      updated = json_response(res, 200)["data"]["updateIndividualStockTransactionCount"]

      assert updated["id"]                                    == individual_stock_transaction_count.id
      assert updated["inserted_at"]                           == formatting_time(individual_stock_transaction_count.inserted_at)
      assert updated["name"]                                  == "updated some name"
      assert updated["updated_at"]                            == formatting_time(individual_stock_transaction_count.updated_at)
      assert updated["individual_tax_returns"]["id"]          == individual_tax_return.id
      assert updated["individual_tax_returns"]["inserted_at"] == formatting_time(individual_stock_transaction_count.individual_tax_returns.inserted_at)
      assert updated["individual_tax_returns"]["updated_at"]  == formatting_time(individual_stock_transaction_count.individual_tax_returns.updated_at)
    end

    it "updated specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_stock_transaction_count = insert(:individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})

      mutation = """
      {
        updateIndividualStockTransactionCount(
          id: \"#{individual_stock_transaction_count.id}\",
          individual_stock_transaction_count: {
            individual_tax_returnId: \"#{individual_tax_return.id}\",
            name: "updated some name"
          }
        )
        {
          id
          inserted_at
          name
          updated_at
          individual_tax_returns {
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

      updated = json_response(res, 200)["data"]["updateIndividualStockTransactionCount"]

      assert updated["id"]                                    == individual_stock_transaction_count.id
      assert updated["inserted_at"]                           == formatting_time(individual_stock_transaction_count.inserted_at)
      assert updated["name"]                                  == "updated some name"
      assert updated["updated_at"]                            == formatting_time(individual_stock_transaction_count.updated_at)
      assert updated["individual_tax_returns"]["id"]          == individual_tax_return.id
      assert updated["individual_tax_returns"]["inserted_at"] == formatting_time(individual_stock_transaction_count.individual_tax_returns.inserted_at)
      assert updated["individual_tax_returns"]["updated_at"]  == formatting_time(individual_stock_transaction_count.individual_tax_returns.updated_at)
    end
  end

  describe "#delete" do
    it "delete specific IndividualStockTransactionCount" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, %{user: user})
      individual_stock_transaction_count = insert(:individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})

      mutation = """
      {
        deleteIndividualStockTransactionCount(id: \"#{individual_stock_transaction_count.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteIndividualStockTransactionCount"]
      assert deleted["id"] == individual_stock_transaction_count.id
    end
  end

  describe "#dataloads" do
    it "created IndividualStockTransactionCount" do
       user = insert(:user)
       %{id: individual_tax_return_id} = insert(:individual_tax_return, user: user)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:individual_stock_transaction_counts, source)
        |> Dataloader.load(:individual_stock_transaction_counts, Core.Services.IndividualTaxReturn, individual_tax_return_id)
        |> Dataloader.run

      data = Dataloader.get(loader, :individual_stock_transaction_counts, Core.Services.IndividualTaxReturn, individual_tax_return_id)

      assert data.id == individual_tax_return_id
    end
  end

  defp formatting_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

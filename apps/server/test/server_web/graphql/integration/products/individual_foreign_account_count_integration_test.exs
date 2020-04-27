defmodule ServerWeb.GraphQL.Integration.Products.IndividualForeignAccountCountIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns IndividualForeignAccountCount by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_foreign_account_count = insert(:tp_individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        allIndividualForeignAccountCounts {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allIndividualForeignAccountCounts"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allIndividualForeignAccountCounts"]

      assert List.first(data)["id"]                                    == individual_foreign_account_count.id
      assert List.first(data)["inserted_at"]                           == formatting_time(individual_foreign_account_count.inserted_at)
      assert List.first(data)["name"]                                  == individual_foreign_account_count.name
      assert List.first(data)["updated_at"]                            == formatting_time(individual_foreign_account_count.updated_at)
      assert List.first(data)["individual_tax_returns"]["id"]          == individual_foreign_account_count.individual_tax_returns.id
      assert List.first(data)["individual_tax_returns"]["inserted_at"] == formatting_time(individual_foreign_account_count.individual_tax_returns.inserted_at)
      assert List.first(data)["individual_tax_returns"]["updated_at"]  == formatting_time(individual_foreign_account_count.individual_tax_returns.updated_at)

      {:ok, %{data: %{"allIndividualForeignAccountCounts" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == individual_foreign_account_count.id
      assert first["inserted_at"]                           == formatting_time(individual_foreign_account_count.inserted_at)
      assert first["name"]                                  == individual_foreign_account_count.name
      assert first["updated_at"]                            == formatting_time(individual_foreign_account_count.updated_at)
      assert first["individual_tax_returns"]["id"]          == individual_foreign_account_count.individual_tax_returns.id
      assert first["individual_tax_returns"]["inserted_at"] == formatting_time(individual_foreign_account_count.individual_tax_returns.inserted_at)
      assert first["individual_tax_returns"]["updated_at"]  == formatting_time(individual_foreign_account_count.individual_tax_returns.updated_at)
    end

    it "returns BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_foreign_account_count = insert(:pro_individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        allIndividualForeignAccountCounts {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allIndividualForeignAccountCounts"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allIndividualForeignAccountCounts"]

      assert List.first(data)["id"]                                    == individual_foreign_account_count.id
      assert List.first(data)["inserted_at"]                           == formatting_time(individual_foreign_account_count.inserted_at)
      assert List.first(data)["name"]                                  == individual_foreign_account_count.name
      assert List.first(data)["updated_at"]                            == formatting_time(individual_foreign_account_count.updated_at)
      assert List.first(data)["individual_tax_returns"]["id"]          == individual_foreign_account_count.individual_tax_returns.id
      assert List.first(data)["individual_tax_returns"]["inserted_at"] == formatting_time(individual_foreign_account_count.individual_tax_returns.inserted_at)
      assert List.first(data)["individual_tax_returns"]["updated_at"]  == formatting_time(individual_foreign_account_count.individual_tax_returns.updated_at)

      {:ok, %{data: %{"allIndividualForeignAccountCounts" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == individual_foreign_account_count.id
      assert first["inserted_at"]                           == formatting_time(individual_foreign_account_count.inserted_at)
      assert first["name"]                                  == individual_foreign_account_count.name
      assert first["updated_at"]                            == formatting_time(individual_foreign_account_count.updated_at)
      assert first["individual_tax_returns"]["id"]          == individual_foreign_account_count.individual_tax_returns.id
      assert first["individual_tax_returns"]["inserted_at"] == formatting_time(individual_foreign_account_count.individual_tax_returns.inserted_at)
      assert first["individual_tax_returns"]["updated_at"]  == formatting_time(individual_foreign_account_count.individual_tax_returns.updated_at)
    end
  end

  describe "#show" do
    it "returns specific IndividualForeignAccountCount by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_foreign_account_count = insert(:tp_individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        showIndividualForeignAccountCount(id: \"#{individual_foreign_account_count.id}\") {
          id
          name
          inserted_at
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

      {:ok, %{data: %{"showIndividualForeignAccountCount" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_foreign_account_count.id
      assert found["inserted_at"]                           == formatting_time(individual_foreign_account_count.inserted_at)
      assert found["name"]                                  == individual_foreign_account_count.name
      assert found["updated_at"]                            == formatting_time(individual_foreign_account_count.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_foreign_account_count.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_foreign_account_count.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_foreign_account_count.individual_tax_returns.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showIndividualForeignAccountCount"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showIndividualForeignAccountCount"]

      assert found["id"]                                    == individual_foreign_account_count.id
      assert found["inserted_at"]                           == formatting_time(individual_foreign_account_count.inserted_at)
      assert found["name"]                                  == individual_foreign_account_count.name
      assert found["updated_at"]                            == formatting_time(individual_foreign_account_count.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_foreign_account_count.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_foreign_account_count.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_foreign_account_count.individual_tax_returns.updated_at)
    end

    it "returns specific IndividualForeignAccountCount by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_foreign_account_count = insert(:pro_individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        showIndividualForeignAccountCount(id: \"#{individual_foreign_account_count.id}\") {
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

      {:ok, %{data: %{"showIndividualForeignAccountCount" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_foreign_account_count.id
      assert found["inserted_at"]                           == formatting_time(individual_foreign_account_count.inserted_at)
      assert found["name"]                                  == individual_foreign_account_count.name
      assert found["updated_at"]                            == formatting_time(individual_foreign_account_count.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_foreign_account_count.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_foreign_account_count.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_foreign_account_count.individual_tax_returns.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showIndividualForeignAccountCount"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showIndividualForeignAccountCount"]

      assert found["id"]                                    == individual_foreign_account_count.id
      assert found["inserted_at"]                           == formatting_time(individual_foreign_account_count.inserted_at)
      assert found["name"]                                  == individual_foreign_account_count.name
      assert found["updated_at"]                            == formatting_time(individual_foreign_account_count.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_foreign_account_count.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_foreign_account_count.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_foreign_account_count.individual_tax_returns.updated_at)
    end
  end

  describe "#find" do
    it "find specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_foreign_account_count = insert(:tp_individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        findIndividualForeignAccountCount(id: \"#{individual_foreign_account_count.id}\") {
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

      {:ok, %{data: %{"findIndividualForeignAccountCount" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_foreign_account_count.id
      assert found["inserted_at"]                           == formatting_time(individual_foreign_account_count.inserted_at)
      assert found["name"]                                  == individual_foreign_account_count.name
      assert found["updated_at"]                            == formatting_time(individual_foreign_account_count.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_foreign_account_count.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_foreign_account_count.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_foreign_account_count.individual_tax_returns.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualForeignAccountCount"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualForeignAccountCount"]

      assert found["id"]                                    == individual_foreign_account_count.id
      assert found["inserted_at"]                           == formatting_time(individual_foreign_account_count.inserted_at)
      assert found["name"]                                  == individual_foreign_account_count.name
      assert found["updated_at"]                            == formatting_time(individual_foreign_account_count.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_foreign_account_count.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_foreign_account_count.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_foreign_account_count.individual_tax_returns.updated_at)
    end

    it "find specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_foreign_account_count = insert(:pro_individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        findIndividualForeignAccountCount(id: \"#{individual_foreign_account_count.id}\") {
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

      {:ok, %{data: %{"findIndividualForeignAccountCount" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_foreign_account_count.id
      assert found["inserted_at"]                           == formatting_time(individual_foreign_account_count.inserted_at)
      assert found["name"]                                  == individual_foreign_account_count.name
      assert found["updated_at"]                            == formatting_time(individual_foreign_account_count.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_foreign_account_count.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_foreign_account_count.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_foreign_account_count.individual_tax_returns.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualForeignAccountCount"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualForeignAccountCount"]

      assert found["id"]                                    == individual_foreign_account_count.id
      assert found["inserted_at"]                           == formatting_time(individual_foreign_account_count.inserted_at)
      assert found["name"]                                  == individual_foreign_account_count.name
      assert found["updated_at"]                            == formatting_time(individual_foreign_account_count.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_foreign_account_count.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_foreign_account_count.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_foreign_account_count.individual_tax_returns.updated_at)
    end
  end

  describe "#create" do
    it "created IndividualForeignAccountCount by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})

      mutation = """
      {
        createIndividualForeignAccountCount(
          name: "some name",
          individual_tax_returnId: \"#{individual_tax_return.id}\"
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

      created = json_response(res, 200)["data"]["createIndividualForeignAccountCount"]

      assert created["inserted_at"]                  == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                         == "some name"
      assert created["updated_at"]                   == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["individual_tax_returns"]["id"] == individual_tax_return.id
    end

    it "created IndividualForeignAccountCount by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})

      mutation = """
      {
        createIndividualForeignAccountCount(
          individual_tax_returnId: \"#{individual_tax_return.id}\"
          name: "some name",
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

      created = json_response(res, 200)["data"]["createIndividualForeignAccountCount"]

      assert created["inserted_at"]                  == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                         == "some name"
      assert created["updated_at"]                   == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["individual_tax_returns"]["id"] == individual_tax_return.id
    end
  end

  describe "#update" do
    it "updated specific IndividualForeignAccountCount by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_foreign_account_count = insert(:individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})

      mutation = """
      {
        updateIndividualForeignAccountCount(
          id: \"#{individual_foreign_account_count.id}\",
          individual_foreign_account_count: {
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

      updated = json_response(res, 200)["data"]["updateIndividualForeignAccountCount"]

      assert updated["id"]                                    == individual_foreign_account_count.id
      assert updated["inserted_at"]                           == formatting_time(individual_foreign_account_count.inserted_at)
      assert updated["name"]                                  == "updated some name"
      assert updated["updated_at"]                            == formatting_time(individual_foreign_account_count.updated_at)
      assert updated["individual_tax_returns"]["id"]          == individual_tax_return.id
      assert updated["individual_tax_returns"]["inserted_at"] == formatting_time(individual_foreign_account_count.individual_tax_returns.inserted_at)
      assert updated["individual_tax_returns"]["updated_at"]  == formatting_time(individual_foreign_account_count.individual_tax_returns.updated_at)
    end

    it "updated specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_foreign_account_count = insert(:individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})

      mutation = """
      {
        updateIndividualForeignAccountCount(
          id: \"#{individual_foreign_account_count.id}\",
          individual_foreign_account_count: {
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

      updated = json_response(res, 200)["data"]["updateIndividualForeignAccountCount"]

      assert updated["id"]                                    == individual_foreign_account_count.id
      assert updated["inserted_at"]                           == formatting_time(individual_foreign_account_count.inserted_at)
      assert updated["name"]                                  == "updated some name"
      assert updated["updated_at"]                            == formatting_time(individual_foreign_account_count.updated_at)
      assert updated["individual_tax_returns"]["id"]          == individual_tax_return.id
      assert updated["individual_tax_returns"]["inserted_at"] == formatting_time(individual_foreign_account_count.individual_tax_returns.inserted_at)
      assert updated["individual_tax_returns"]["updated_at"]  == formatting_time(individual_foreign_account_count.individual_tax_returns.updated_at)
    end
  end

  describe "#delete" do
    it "delete specific IndividualForeignAccountCount" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, %{user: user})
      individual_foreign_account_count = insert(:individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})

      mutation = """
      {
        deleteIndividualForeignAccountCount(id: \"#{individual_foreign_account_count.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteIndividualForeignAccountCount"]
      assert deleted["id"] == individual_foreign_account_count.id
    end
  end

  describe "#dataloads" do
    it "created IndividualForeignAccountCount" do
       user = insert(:user)
       %{id: individual_tax_return_id} = insert(:individual_tax_return, user: user)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:individual_foreign_account_counts, source)
        |> Dataloader.load(:individual_foreign_account_counts, Core.Services.IndividualTaxReturn, individual_tax_return_id)
        |> Dataloader.run

      data = Dataloader.get(loader, :individual_foreign_account_counts, Core.Services.IndividualTaxReturn, individual_tax_return_id)

      assert data.id == individual_tax_return_id
    end
  end

  defp formatting_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

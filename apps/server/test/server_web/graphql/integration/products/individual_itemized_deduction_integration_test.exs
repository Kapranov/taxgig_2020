defmodule ServerWeb.GraphQL.Integration.Products.IndividualItemizedDeductionIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns IndividualItemizedDeduction by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_itemized_deduction = insert(:tp_individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        allIndividualItemizedDeductions {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allIndividualItemizedDeductions"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allIndividualItemizedDeductions"]

      assert List.first(data)["id"]                                    == individual_itemized_deduction.id
      assert List.first(data)["inserted_at"]                           == formatting_time(individual_itemized_deduction.inserted_at)
      assert List.first(data)["name"]                                  == individual_itemized_deduction.name
      assert List.first(data)["updated_at"]                            == formatting_time(individual_itemized_deduction.updated_at)
      assert List.first(data)["individual_tax_returns"]["id"]          == individual_itemized_deduction.individual_tax_returns.id
      assert List.first(data)["individual_tax_returns"]["inserted_at"] == formatting_time(individual_itemized_deduction.individual_tax_returns.inserted_at)
      assert List.first(data)["individual_tax_returns"]["updated_at"]  == formatting_time(individual_itemized_deduction.individual_tax_returns.updated_at)

      {:ok, %{data: %{"allIndividualItemizedDeductions" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == individual_itemized_deduction.id
      assert first["inserted_at"]                           == formatting_time(individual_itemized_deduction.inserted_at)
      assert first["name"]                                  == individual_itemized_deduction.name
      assert first["updated_at"]                            == formatting_time(individual_itemized_deduction.updated_at)
      assert first["individual_tax_returns"]["id"]          == individual_itemized_deduction.individual_tax_returns.id
      assert first["individual_tax_returns"]["inserted_at"] == formatting_time(individual_itemized_deduction.individual_tax_returns.inserted_at)
      assert first["individual_tax_returns"]["updated_at"]  == formatting_time(individual_itemized_deduction.individual_tax_returns.updated_at)
    end

    it "returns BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_itemized_deduction = insert(:pro_individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        allIndividualItemizedDeductions {
          id
          inserted_at
          name
          price
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allIndividualItemizedDeductions"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allIndividualItemizedDeductions"]

      assert List.first(data)["id"]                                    == individual_itemized_deduction.id
      assert List.first(data)["inserted_at"]                           == formatting_time(individual_itemized_deduction.inserted_at)
      assert List.first(data)["name"]                                  == individual_itemized_deduction.name
      assert List.first(data)["price"]                                 == individual_itemized_deduction.price
      assert List.first(data)["updated_at"]                            == formatting_time(individual_itemized_deduction.updated_at)
      assert List.first(data)["individual_tax_returns"]["id"]          == individual_itemized_deduction.individual_tax_returns.id
      assert List.first(data)["individual_tax_returns"]["inserted_at"] == formatting_time(individual_itemized_deduction.individual_tax_returns.inserted_at)
      assert List.first(data)["individual_tax_returns"]["updated_at"]  == formatting_time(individual_itemized_deduction.individual_tax_returns.updated_at)

      {:ok, %{data: %{"allIndividualItemizedDeductions" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == individual_itemized_deduction.id
      assert first["inserted_at"]                           == formatting_time(individual_itemized_deduction.inserted_at)
      assert first["name"]                                  == individual_itemized_deduction.name
      assert first["price"]                                 == individual_itemized_deduction.price
      assert first["updated_at"]                            == formatting_time(individual_itemized_deduction.updated_at)
      assert first["individual_tax_returns"]["id"]          == individual_itemized_deduction.individual_tax_returns.id
      assert first["individual_tax_returns"]["inserted_at"] == formatting_time(individual_itemized_deduction.individual_tax_returns.inserted_at)
      assert first["individual_tax_returns"]["updated_at"]  == formatting_time(individual_itemized_deduction.individual_tax_returns.updated_at)
    end
  end

  describe "#show" do
    it "returns specific IndividualItemizedDeduction by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_itemized_deduction = insert(:tp_individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        showIndividualItemizedDeduction(id: \"#{individual_itemized_deduction.id}\") {
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

      {:ok, %{data: %{"showIndividualItemizedDeduction" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_itemized_deduction.id
      assert found["inserted_at"]                           == formatting_time(individual_itemized_deduction.inserted_at)
      assert found["name"]                                  == individual_itemized_deduction.name
      assert found["updated_at"]                            == formatting_time(individual_itemized_deduction.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_itemized_deduction.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_itemized_deduction.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_itemized_deduction.individual_tax_returns.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showIndividualItemizedDeduction"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showIndividualItemizedDeduction"]

      assert found["id"]                                    == individual_itemized_deduction.id
      assert found["inserted_at"]                           == formatting_time(individual_itemized_deduction.inserted_at)
      assert found["name"]                                  == individual_itemized_deduction.name
      assert found["updated_at"]                            == formatting_time(individual_itemized_deduction.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_itemized_deduction.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_itemized_deduction.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_itemized_deduction.individual_tax_returns.updated_at)
    end

    it "returns specific IndividualItemizedDeduction by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_itemized_deduction = insert(:pro_individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        showIndividualItemizedDeduction(id: \"#{individual_itemized_deduction.id}\") {
          id
          inserted_at
          name
          price
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

      {:ok, %{data: %{"showIndividualItemizedDeduction" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_itemized_deduction.id
      assert found["inserted_at"]                           == formatting_time(individual_itemized_deduction.inserted_at)
      assert found["name"]                                  == individual_itemized_deduction.name
      assert found["price"]                                 == individual_itemized_deduction.price
      assert found["updated_at"]                            == formatting_time(individual_itemized_deduction.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_itemized_deduction.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_itemized_deduction.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_itemized_deduction.individual_tax_returns.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showIndividualItemizedDeduction"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showIndividualItemizedDeduction"]

      assert found["id"]                                    == individual_itemized_deduction.id
      assert found["inserted_at"]                           == formatting_time(individual_itemized_deduction.inserted_at)
      assert found["name"]                                  == individual_itemized_deduction.name
      assert found["price"]                                 == individual_itemized_deduction.price
      assert found["updated_at"]                            == formatting_time(individual_itemized_deduction.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_itemized_deduction.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_itemized_deduction.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_itemized_deduction.individual_tax_returns.updated_at)
    end
  end

  describe "#find" do
    it "find specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_itemized_deduction = insert(:tp_individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        findIndividualItemizedDeduction(id: \"#{individual_itemized_deduction.id}\") {
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

      {:ok, %{data: %{"findIndividualItemizedDeduction" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_itemized_deduction.id
      assert found["inserted_at"]                           == formatting_time(individual_itemized_deduction.inserted_at)
      assert found["name"]                                  == individual_itemized_deduction.name
      assert found["updated_at"]                            == formatting_time(individual_itemized_deduction.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_itemized_deduction.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_itemized_deduction.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_itemized_deduction.individual_tax_returns.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualItemizedDeduction"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualItemizedDeduction"]

      assert found["id"]                                    == individual_itemized_deduction.id
      assert found["inserted_at"]                           == formatting_time(individual_itemized_deduction.inserted_at)
      assert found["name"]                                  == individual_itemized_deduction.name
      assert found["updated_at"]                            == formatting_time(individual_itemized_deduction.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_itemized_deduction.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_itemized_deduction.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_itemized_deduction.individual_tax_returns.updated_at)
    end

    it "find specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_itemized_deduction = insert(:pro_individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        findIndividualItemizedDeduction(id: \"#{individual_itemized_deduction.id}\") {
          id
          inserted_at
          name
          price
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

      {:ok, %{data: %{"findIndividualItemizedDeduction" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_itemized_deduction.id
      assert found["inserted_at"]                           == formatting_time(individual_itemized_deduction.inserted_at)
      assert found["name"]                                  == individual_itemized_deduction.name
      assert found["price"]                                 == individual_itemized_deduction.price
      assert found["updated_at"]                            == formatting_time(individual_itemized_deduction.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_itemized_deduction.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_itemized_deduction.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_itemized_deduction.individual_tax_returns.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualItemizedDeduction"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualItemizedDeduction"]

      assert found["id"]                                    == individual_itemized_deduction.id
      assert found["inserted_at"]                           == formatting_time(individual_itemized_deduction.inserted_at)
      assert found["name"]                                  == individual_itemized_deduction.name
      assert found["price"]                                 == individual_itemized_deduction.price
      assert found["updated_at"]                            == formatting_time(individual_itemized_deduction.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_itemized_deduction.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_itemized_deduction.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_itemized_deduction.individual_tax_returns.updated_at)
    end
  end

  describe "#create" do
    it "created IndividualItemizedDeduction by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})

      mutation = """
      {
        createIndividualItemizedDeduction(
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

      created = json_response(res, 200)["data"]["createIndividualItemizedDeduction"]

      assert created["individual_tax_returns"]["id"] == individual_tax_return.id
      assert created["inserted_at"]                  == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                         == "some name"
      assert created["updated_at"]                   == formatting_time(DateTime.truncate(Timex.now(), :second))
    end

    it "created IndividualItemizedDeduction by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})

      mutation = """
      {
        createIndividualItemizedDeduction(
          individual_tax_returnId: \"#{individual_tax_return.id}\",
          name: "some name",
          price: 12
        ) {
          id
          inserted_at
          name
          price
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

      created = json_response(res, 200)["data"]["createIndividualItemizedDeduction"]

      assert created["individual_tax_returns"]["id"] == individual_tax_return.id
      assert created["inserted_at"]                  == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                         == "some name"
      assert created["price"]                        == 12
      assert created["updated_at"]                   == formatting_time(DateTime.truncate(Timex.now(), :second))
    end
  end

  describe "#update" do
    it "updated specific IndividualItemizedDeduction by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_itemized_deduction = insert(:individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})

      mutation = """
      {
        updateIndividualItemizedDeduction(
          id: \"#{individual_itemized_deduction.id}\",
          individual_itemized_deduction: {
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

      updated = json_response(res, 200)["data"]["updateIndividualItemizedDeduction"]

      assert updated["id"]                                    == individual_itemized_deduction.id
      assert updated["inserted_at"]                           == formatting_time(individual_itemized_deduction.inserted_at)
      assert updated["name"]                                  == "updated some name"
      assert updated["updated_at"]                            == formatting_time(individual_itemized_deduction.updated_at)
      assert updated["individual_tax_returns"]["id"]          == individual_tax_return.id
      assert updated["individual_tax_returns"]["inserted_at"] == formatting_time(individual_itemized_deduction.individual_tax_returns.inserted_at)
      assert updated["individual_tax_returns"]["updated_at"]  == formatting_time(individual_itemized_deduction.individual_tax_returns.updated_at)
    end

    it "updated specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_itemized_deduction = insert(:individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})

      mutation = """
      {
        updateIndividualItemizedDeduction(
          id: \"#{individual_itemized_deduction.id}\",
          individual_itemized_deduction: {
            individual_tax_returnId: \"#{individual_tax_return.id}\",
            name: "updated some name",
            price: 13
          }
        )
        {
          id
          inserted_at
          name
          price
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

      updated = json_response(res, 200)["data"]["updateIndividualItemizedDeduction"]

      assert updated["id"]                                    == individual_itemized_deduction.id
      assert updated["inserted_at"]                           == formatting_time(individual_itemized_deduction.inserted_at)
      assert updated["name"]                                  == "updated some name"
      assert updated["price"]                                 == 13
      assert updated["updated_at"]                            == formatting_time(individual_itemized_deduction.updated_at)
      assert updated["individual_tax_returns"]["id"]          == individual_tax_return.id
      assert updated["individual_tax_returns"]["inserted_at"] == formatting_time(individual_itemized_deduction.individual_tax_returns.inserted_at)
      assert updated["individual_tax_returns"]["updated_at"]  == formatting_time(individual_itemized_deduction.individual_tax_returns.updated_at)
    end
  end

  describe "#delete" do
    it "delete specific IndividualItemizedDeduction" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, %{user: user})
      individual_itemized_deduction = insert(:individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})

      mutation = """
      {
        deleteIndividualItemizedDeduction(id: \"#{individual_itemized_deduction.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteIndividualItemizedDeduction"]
      assert deleted["id"] == individual_itemized_deduction.id
    end
  end

  describe "#dataloads" do
    it "created IndividualItemizedDeduction" do
       user = insert(:user)
       %{id: individual_tax_return_id} = insert(:individual_tax_return, user: user)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:individual_itemized_deductions, source)
        |> Dataloader.load(:individual_itemized_deductions, Core.Services.IndividualTaxReturn, individual_tax_return_id)
        |> Dataloader.run

      data = Dataloader.get(loader, :individual_itemized_deductions, Core.Services.IndividualTaxReturn, individual_tax_return_id)

      assert data.id == individual_tax_return_id
    end
  end

  defp formatting_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

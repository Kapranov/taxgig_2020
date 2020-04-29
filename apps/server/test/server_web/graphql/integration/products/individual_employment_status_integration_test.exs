defmodule ServerWeb.GraphQL.Integration.Products.IndividualEmploymentStatusIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns IndividualEmploymentStatus by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_employment_status = insert(:tp_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        allIndividualEmploymentStatuses {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allIndividualEmploymentStatuses"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allIndividualEmploymentStatuses"]

      assert List.first(data)["id"]                                    == individual_employment_status.id
      assert List.first(data)["inserted_at"]                           == formatting_time(individual_employment_status.inserted_at)
      assert List.first(data)["name"]                                  == individual_employment_status.name
      assert List.first(data)["updated_at"]                            == formatting_time(individual_employment_status.updated_at)
      assert List.first(data)["individual_tax_returns"]["id"]          == individual_employment_status.individual_tax_returns.id
      assert List.first(data)["individual_tax_returns"]["inserted_at"] == formatting_time(individual_employment_status.individual_tax_returns.inserted_at)
      assert List.first(data)["individual_tax_returns"]["updated_at"]  == formatting_time(individual_employment_status.individual_tax_returns.updated_at)

      {:ok, %{data: %{"allIndividualEmploymentStatuses" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == individual_employment_status.id
      assert first["inserted_at"]                           == formatting_time(individual_employment_status.inserted_at)
      assert first["name"]                                  == individual_employment_status.name
      assert first["updated_at"]                            == formatting_time(individual_employment_status.updated_at)
      assert first["individual_tax_returns"]["id"]          == individual_employment_status.individual_tax_returns.id
      assert first["individual_tax_returns"]["inserted_at"] == formatting_time(individual_employment_status.individual_tax_returns.inserted_at)
      assert first["individual_tax_returns"]["updated_at"]  == formatting_time(individual_employment_status.individual_tax_returns.updated_at)
    end

    it "returns BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_employment_status = insert(:pro_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        allIndividualEmploymentStatuses {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allIndividualEmploymentStatuses"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allIndividualEmploymentStatuses"]

      assert List.first(data)["id"]                                    == individual_employment_status.id
      assert List.first(data)["inserted_at"]                           == formatting_time(individual_employment_status.inserted_at)
      assert List.first(data)["name"]                                  == individual_employment_status.name
      assert List.first(data)["price"]                                 == individual_employment_status.price
      assert List.first(data)["updated_at"]                            == formatting_time(individual_employment_status.updated_at)
      assert List.first(data)["individual_tax_returns"]["id"]          == individual_employment_status.individual_tax_returns.id
      assert List.first(data)["individual_tax_returns"]["inserted_at"] == formatting_time(individual_employment_status.individual_tax_returns.inserted_at)
      assert List.first(data)["individual_tax_returns"]["updated_at"]  == formatting_time(individual_employment_status.individual_tax_returns.updated_at)

      {:ok, %{data: %{"allIndividualEmploymentStatuses" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == individual_employment_status.id
      assert first["inserted_at"]                           == formatting_time(individual_employment_status.inserted_at)
      assert first["name"]                                  == individual_employment_status.name
      assert first["price"]                                 == individual_employment_status.price
      assert first["updated_at"]                            == formatting_time(individual_employment_status.updated_at)
      assert first["individual_tax_returns"]["id"]          == individual_employment_status.individual_tax_returns.id
      assert first["individual_tax_returns"]["inserted_at"] == formatting_time(individual_employment_status.individual_tax_returns.inserted_at)
      assert first["individual_tax_returns"]["updated_at"]  == formatting_time(individual_employment_status.individual_tax_returns.updated_at)
    end
  end

  describe "#show" do
    it "returns specific IndividualEmploymentStatus by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_employment_status = insert(:tp_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        showIndividualEmploymentStatus(id: \"#{individual_employment_status.id}\") {
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

      {:ok, %{data: %{"showIndividualEmploymentStatus" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_employment_status.id
      assert found["inserted_at"]                           == formatting_time(individual_employment_status.inserted_at)
      assert found["name"]                                  == individual_employment_status.name
      assert found["updated_at"]                            == formatting_time(individual_employment_status.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_employment_status.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_employment_status.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_employment_status.individual_tax_returns.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showIndividualEmploymentStatus"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showIndividualEmploymentStatus"]

      assert found["id"]                                    == individual_employment_status.id
      assert found["inserted_at"]                           == formatting_time(individual_employment_status.inserted_at)
      assert found["name"]                                  == individual_employment_status.name
      assert found["updated_at"]                            == formatting_time(individual_employment_status.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_employment_status.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_employment_status.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_employment_status.individual_tax_returns.updated_at)
    end

    it "returns specific IndividualEmploymentStatus by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_employment_status = insert(:pro_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        showIndividualEmploymentStatus(id: \"#{individual_employment_status.id}\") {
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

      {:ok, %{data: %{"showIndividualEmploymentStatus" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_employment_status.id
      assert found["inserted_at"]                           == formatting_time(individual_employment_status.inserted_at)
      assert found["name"]                                  == individual_employment_status.name
      assert found["price"]                                 == individual_employment_status.price
      assert found["updated_at"]                            == formatting_time(individual_employment_status.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_employment_status.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_employment_status.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_employment_status.individual_tax_returns.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showIndividualEmploymentStatus"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showIndividualEmploymentStatus"]

      assert found["id"]                                    == individual_employment_status.id
      assert found["inserted_at"]                           == formatting_time(individual_employment_status.inserted_at)
      assert found["name"]                                  == individual_employment_status.name
      assert found["price"]                                 == individual_employment_status.price
      assert found["updated_at"]                            == formatting_time(individual_employment_status.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_employment_status.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_employment_status.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_employment_status.individual_tax_returns.updated_at)
    end
  end

  describe "#find" do
    it "find specific BusinessTaxReturn" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, %{user: user})
      individual_employment_status = insert(:individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        findIndividualEmploymentStatus(id: \"#{individual_employment_status.id}\") {
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

      {:ok, %{data: %{"findIndividualEmploymentStatus" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_employment_status.id
      assert found["inserted_at"]                           == formatting_time(individual_employment_status.inserted_at)
      assert found["name"]                                  == individual_employment_status.name
      assert found["price"]                                 == individual_employment_status.price
      assert found["updated_at"]                            == formatting_time(individual_employment_status.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_employment_status.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_employment_status.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_employment_status.individual_tax_returns.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualEmploymentStatus"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualEmploymentStatus"]

      assert found["id"]                                    == individual_employment_status.id
      assert found["inserted_at"]                           == formatting_time(individual_employment_status.inserted_at)
      assert found["name"]                                  == individual_employment_status.name
      assert found["price"]                                 == individual_employment_status.price
      assert found["updated_at"]                            == formatting_time(individual_employment_status.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_employment_status.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_employment_status.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_employment_status.individual_tax_returns.updated_at)
    end

    it "find specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_employment_status = insert(:tp_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        findIndividualEmploymentStatus(id: \"#{individual_employment_status.id}\") {
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

      {:ok, %{data: %{"findIndividualEmploymentStatus" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_employment_status.id
      assert found["inserted_at"]                           == formatting_time(individual_employment_status.inserted_at)
      assert found["name"]                                  == individual_employment_status.name
      assert found["updated_at"]                            == formatting_time(individual_employment_status.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_employment_status.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_employment_status.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_employment_status.individual_tax_returns.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualEmploymentStatus"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualEmploymentStatus"]

      assert found["id"]                                    == individual_employment_status.id
      assert found["inserted_at"]                           == formatting_time(individual_employment_status.inserted_at)
      assert found["name"]                                  == individual_employment_status.name
      assert found["updated_at"]                            == formatting_time(individual_employment_status.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_employment_status.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_employment_status.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_employment_status.individual_tax_returns.updated_at)
    end

    it "find specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_employment_status = insert(:pro_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        findIndividualEmploymentStatus(id: \"#{individual_employment_status.id}\") {
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

      {:ok, %{data: %{"findIndividualEmploymentStatus" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_employment_status.id
      assert found["inserted_at"]                           == formatting_time(individual_employment_status.inserted_at)
      assert found["name"]                                  == individual_employment_status.name
      assert found["price"]                                 == individual_employment_status.price
      assert found["updated_at"]                            == formatting_time(individual_employment_status.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_employment_status.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_employment_status.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_employment_status.individual_tax_returns.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualEmploymentStatus"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualEmploymentStatus"]

      assert found["id"]                                    == individual_employment_status.id
      assert found["inserted_at"]                           == formatting_time(individual_employment_status.inserted_at)
      assert found["name"]                                  == individual_employment_status.name
      assert found["price"]                                 == individual_employment_status.price
      assert found["updated_at"]                            == formatting_time(individual_employment_status.updated_at)
      assert found["individual_tax_returns"]["id"]          == individual_employment_status.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_employment_status.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_employment_status.individual_tax_returns.updated_at)
    end
  end

  describe "#create" do
    it "created IndividualEmploymentStatus by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})

      mutation = """
      {
        createIndividualEmploymentStatus(
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

      created = json_response(res, 200)["data"]["createIndividualEmploymentStatus"]

      assert created["individual_tax_returns"]["id"] == individual_tax_return.id
      assert created["inserted_at"]                  == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                         == "some name"
      assert created["updated_at"]                   == formatting_time(DateTime.truncate(Timex.now(), :second))
    end

    it "created IndividualEmploymentStatus by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})

      mutation = """
      {
        createIndividualEmploymentStatus(
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

      created = json_response(res, 200)["data"]["createIndividualEmploymentStatus"]

      assert created["individual_tax_returns"]["id"] == individual_tax_return.id
      assert created["inserted_at"]                  == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                         == "some name"
      assert created["price"]                        == 12
      assert created["updated_at"]                   == formatting_time(DateTime.truncate(Timex.now(), :second))
    end
  end

  describe "#update" do
    it "updated specific IndividualEmploymentStatus by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_employment_status = insert(:individual_employment_status, %{individual_tax_returns: individual_tax_return})

      mutation = """
      {
        updateIndividualEmploymentStatus(
          id: \"#{individual_employment_status.id}\",
          individual_employment_status: {
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

      updated = json_response(res, 200)["data"]["updateIndividualEmploymentStatus"]

      assert updated["id"]                                    == individual_employment_status.id
      assert updated["inserted_at"]                           == formatting_time(individual_employment_status.inserted_at)
      assert updated["name"]                                  == "updated some name"
      assert updated["updated_at"]                            == formatting_time(individual_employment_status.updated_at)
      assert updated["individual_tax_returns"]["id"]          == individual_tax_return.id
      assert updated["individual_tax_returns"]["inserted_at"] == formatting_time(individual_employment_status.individual_tax_returns.inserted_at)
      assert updated["individual_tax_returns"]["updated_at"]  == formatting_time(individual_employment_status.individual_tax_returns.updated_at)
    end

    it "updated specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_employment_status = insert(:individual_employment_status, %{individual_tax_returns: individual_tax_return})

      mutation = """
      {
        updateIndividualEmploymentStatus(
          id: \"#{individual_employment_status.id}\",
          individual_employment_status: {
            individual_tax_returnId: \"#{individual_tax_return.id}\",
            name: "updated some name"
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

      updated = json_response(res, 200)["data"]["updateIndividualEmploymentStatus"]

      assert updated["id"]                                    == individual_employment_status.id
      assert updated["inserted_at"]                           == formatting_time(individual_employment_status.inserted_at)
      assert updated["name"]                                  == "updated some name"
      assert updated["price"]                                 == 13
      assert updated["updated_at"]                            == formatting_time(individual_employment_status.updated_at)
      assert updated["individual_tax_returns"]["id"]          == individual_tax_return.id
      assert updated["individual_tax_returns"]["inserted_at"] == formatting_time(individual_employment_status.individual_tax_returns.inserted_at)
    end
  end

  describe "#delete" do
    it "delete specific IndividualEmploymentStatus" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, %{user: user})
      individual_employment_status = insert(:individual_employment_status, %{individual_tax_returns: individual_tax_return})

      mutation = """
      {
        deleteIndividualEmploymentStatus(id: \"#{individual_employment_status.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteIndividualEmploymentStatus"]
      assert deleted["id"] == individual_employment_status.id
    end
  end

  describe "#dataloads" do
    it "created IndividualEmploymentStatus" do
       user = insert(:user)
       %{id: individual_tax_return_id} = insert(:individual_tax_return, user: user)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:individual_employment_statuses, source)
        |> Dataloader.load(:individual_employment_statuses, Core.Services.IndividualTaxReturn, individual_tax_return_id)
        |> Dataloader.run

      data = Dataloader.get(loader, :individual_employment_statuses, Core.Services.IndividualTaxReturn, individual_tax_return_id)

      assert data.id == individual_tax_return_id
    end
  end

  defp formatting_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

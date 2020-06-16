defmodule ServerWeb.GraphQL.Integration.Products.IndividualIndustryIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns IndividualIndustry by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_industry = insert(:tp_individual_industry, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        allIndividualIndustries {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allIndividualIndustries"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allIndividualIndustries"]

      assert List.first(data)["id"]                                    == individual_industry.id
      assert List.first(data)["individual_tax_returns"]["id"]          == individual_industry.individual_tax_returns.id
      assert List.first(data)["individual_tax_returns"]["inserted_at"] == formatting_time(individual_industry.individual_tax_returns.inserted_at)
      assert List.first(data)["individual_tax_returns"]["updated_at"]  == formatting_time(individual_industry.individual_tax_returns.updated_at)
      assert List.first(data)["inserted_at"]                           == formatting_time(individual_industry.inserted_at)
      assert List.first(data)["name"]                                  == individual_industry.name
      assert List.first(data)["updated_at"]                            == formatting_time(individual_industry.updated_at)

      {:ok, %{data: %{"allIndividualIndustries" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == individual_industry.id
      assert first["individual_tax_returns"]["id"]          == individual_industry.individual_tax_returns.id
      assert first["individual_tax_returns"]["inserted_at"] == formatting_time(individual_industry.individual_tax_returns.inserted_at)
      assert first["individual_tax_returns"]["updated_at"]  == formatting_time(individual_industry.individual_tax_returns.updated_at)
      assert first["inserted_at"]                           == formatting_time(individual_industry.inserted_at)
      assert first["name"]                                  == individual_industry.name
      assert first["updated_at"]                            == formatting_time(individual_industry.updated_at)
    end

    it "returns IndividualTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_industry = insert(:pro_individual_industry, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        allIndividualIndustries {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allIndividualIndustries"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allIndividualIndustries"]

      assert List.first(data)["id"]                                    == individual_industry.id
      assert List.first(data)["individual_tax_returns"]["id"]          == individual_industry.individual_tax_returns.id
      assert List.first(data)["individual_tax_returns"]["inserted_at"] == formatting_time(individual_industry.individual_tax_returns.inserted_at)
      assert List.first(data)["individual_tax_returns"]["updated_at"]  == formatting_time(individual_industry.individual_tax_returns.updated_at)
      assert List.first(data)["inserted_at"]                           == formatting_time(individual_industry.inserted_at)
      assert List.first(data)["name"]                                  == individual_industry.name
      assert List.first(data)["updated_at"]                            == formatting_time(individual_industry.updated_at)

      {:ok, %{data: %{"allIndividualIndustries" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == individual_industry.id
      assert first["individual_tax_returns"]["id"]          == individual_industry.individual_tax_returns.id
      assert first["individual_tax_returns"]["inserted_at"] == formatting_time(individual_industry.individual_tax_returns.inserted_at)
      assert first["individual_tax_returns"]["updated_at"]  == formatting_time(individual_industry.individual_tax_returns.updated_at)
      assert first["inserted_at"]                           == formatting_time(individual_industry.inserted_at)
      assert first["name"]                                  == individual_industry.name
      assert first["updated_at"]                            == formatting_time(individual_industry.updated_at)
    end
  end

  describe "#show" do
    it "returns specific IndividualIndustry by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_industry = insert(:tp_individual_industry, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        showIndividualIndustry(id: \"#{individual_industry.id}\") {
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

      {:ok, %{data: %{"showIndividualIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_industry.id
      assert found["individual_tax_returns"]["id"]          == individual_industry.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_industry.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_industry.individual_tax_returns.updated_at)
      assert found["inserted_at"]                           == formatting_time(individual_industry.inserted_at)
      assert found["name"]                                  == individual_industry.name
      assert found["updated_at"]                            == formatting_time(individual_industry.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showIndividualIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showIndividualIndustry"]

      assert found["id"]                                    == individual_industry.id
      assert found["individual_tax_returns"]["id"]          == individual_industry.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_industry.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_industry.individual_tax_returns.updated_at)
      assert found["inserted_at"]                           == formatting_time(individual_industry.inserted_at)
      assert found["name"]                                  == individual_industry.name
      assert found["updated_at"]                            == formatting_time(individual_industry.updated_at)
    end

    it "returns specific IndividualIndustry by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_industry = insert(:pro_individual_industry, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        showIndividualIndustry(id: \"#{individual_industry.id}\") {
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

      {:ok, %{data: %{"showIndividualIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_industry.id
      assert found["individual_tax_returns"]["id"]          == individual_industry.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_industry.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_industry.individual_tax_returns.updated_at)
      assert found["inserted_at"]                           == formatting_time(individual_industry.inserted_at)
      assert found["name"]                                  == individual_industry.name
      assert found["updated_at"]                            == formatting_time(individual_industry.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showIndividualIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showIndividualIndustry"]

      assert found["id"]                                    == individual_industry.id
      assert found["individual_tax_returns"]["id"]          == individual_industry.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_industry.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_industry.individual_tax_returns.updated_at)
      assert found["inserted_at"]                           == formatting_time(individual_industry.inserted_at)
      assert found["name"]                                  == individual_industry.name
      assert found["updated_at"]                            == formatting_time(individual_industry.updated_at)
    end
  end

  describe "#find" do
    it "find specific IndividualTaxReturn by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_industry = insert(:tp_individual_industry, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        findIndividualIndustry(id: \"#{individual_industry.id}\") {
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

      {:ok, %{data: %{"findIndividualIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_industry.id
      assert found["individual_tax_returns"]["id"]          == individual_industry.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_industry.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_industry.individual_tax_returns.updated_at)
      assert found["inserted_at"]                           == formatting_time(individual_industry.inserted_at)
      assert found["name"]                                  == individual_industry.name
      assert found["updated_at"]                            == formatting_time(individual_industry.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualIndustry"]

      assert found["id"]                                    == individual_industry.id
      assert found["individual_tax_returns"]["id"]          == individual_industry.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_industry.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_industry.individual_tax_returns.updated_at)
      assert found["inserted_at"]                           == formatting_time(individual_industry.inserted_at)
      assert found["name"]                                  == individual_industry.name
      assert found["updated_at"]                            == formatting_time(individual_industry.updated_at)
    end

    it "find specific IndividualTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_industry = insert(:pro_individual_industry, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        findIndividualIndustry(id: \"#{individual_industry.id}\") {
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

      {:ok, %{data: %{"findIndividualIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == individual_industry.id
      assert found["individual_tax_returns"]["id"]          == individual_industry.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_industry.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_industry.individual_tax_returns.updated_at)
      assert found["inserted_at"]                           == formatting_time(individual_industry.inserted_at)
      assert found["name"]                                  == individual_industry.name
      assert found["updated_at"]                            == formatting_time(individual_industry.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualIndustry"]

      assert found["id"]                                    == individual_industry.id
      assert found["individual_tax_returns"]["id"]          == individual_industry.individual_tax_returns.id
      assert found["individual_tax_returns"]["inserted_at"] == formatting_time(individual_industry.individual_tax_returns.inserted_at)
      assert found["individual_tax_returns"]["updated_at"]  == formatting_time(individual_industry.individual_tax_returns.updated_at)
      assert found["inserted_at"]                           == formatting_time(individual_industry.inserted_at)
      assert found["name"]                                  == individual_industry.name
      assert found["updated_at"]                            == formatting_time(individual_industry.updated_at)
    end
  end

  describe "#create" do
    it "created IndividualIndustry by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})

      mutation = """
      {
        createIndividualIndustry(
          name: ["some name"],
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

      created = json_response(res, 200)["data"]["createIndividualIndustry"]

      assert created["individual_tax_returns"]["id"] == individual_tax_return.id
      assert created["inserted_at"]                  == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                         == ["some name"]
      assert created["updated_at"]                   == formatting_time(DateTime.truncate(Timex.now(), :second))
    end

    it "created IndividualIndustry by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})

      mutation = """
      {
        createIndividualIndustry(
          name: ["some name"],
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

      created = json_response(res, 200)["data"]["createIndividualIndustry"]

      assert created["individual_tax_returns"]["id"] == individual_tax_return.id
      assert created["inserted_at"]                  == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                         == ["some name"]
      assert created["updated_at"]                   == formatting_time(DateTime.truncate(Timex.now(), :second))
    end
  end

  describe "#update" do
    it "updated specific IndividualIndustry by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      individual_industry = insert(:individual_industry, %{individual_tax_returns: individual_tax_return})

      mutation = """
      {
        updateIndividualIndustry(
          id: \"#{individual_industry.id}\",
          individual_industry: {
            name: ["updated some name"],
            individual_tax_returnId: \"#{individual_tax_return.id}\"
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

      updated = json_response(res, 200)["data"]["updateIndividualIndustry"]

      assert updated["id"]                                    == individual_industry.id
      assert updated["individual_tax_returns"]["id"]          == individual_tax_return.id
      assert updated["individual_tax_returns"]["inserted_at"] == formatting_time(individual_industry.individual_tax_returns.inserted_at)
      assert updated["individual_tax_returns"]["updated_at"]  == formatting_time(individual_industry.individual_tax_returns.updated_at)
      assert updated["inserted_at"]                           == formatting_time(individual_industry.inserted_at)
      assert updated["name"]                                  == ["updated some name"]
    end

    it "updated specific IndividualTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      individual_industry = insert(:individual_industry, %{individual_tax_returns: individual_tax_return})

      mutation = """
      {
        updateIndividualIndustry(
          id: \"#{individual_industry.id}\",
          individual_industry: {
            individual_tax_returnId: \"#{individual_tax_return.id}\"
            name: ["updated some name"],
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

      updated = json_response(res, 200)["data"]["updateIndividualIndustry"]

      assert updated["id"]                                    == individual_industry.id
      assert updated["individual_tax_returns"]["id"]          == individual_tax_return.id
      assert updated["individual_tax_returns"]["inserted_at"] == formatting_time(individual_industry.individual_tax_returns.inserted_at)
      assert updated["individual_tax_returns"]["updated_at"]  == formatting_time(individual_industry.individual_tax_returns.updated_at)
      assert updated["inserted_at"]                           == formatting_time(individual_industry.inserted_at)
      assert updated["name"]                                  == ["updated some name"]
      assert updated["updated_at"]                            == formatting_time(individual_industry.updated_at)
    end
  end

  describe "#delete" do
    it "delete specific IndividualIndustry" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, %{user: user})
      individual_industry = insert(:individual_industry, %{individual_tax_returns: individual_tax_return})

      mutation = """
      {
        deleteIndividualIndustry(id: \"#{individual_industry.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteIndividualIndustry"]
      assert deleted["id"] == individual_industry.id
    end
  end

  describe "#dataloads" do
    it "created IndividualIndustry by role's Tp" do
       user = insert(:tp_user)
       %{id: individual_tax_return_id} = insert(:tp_individual_tax_return, user: user)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:business_industries, source)
        |> Dataloader.load(:business_industries, Core.Services.IndividualTaxReturn, individual_tax_return_id)
        |> Dataloader.run

      data = Dataloader.get(loader, :business_industries, Core.Services.IndividualTaxReturn, individual_tax_return_id)

      assert data.id == individual_tax_return_id
    end
  end

  defp formatting_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

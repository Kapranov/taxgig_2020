defmodule ServerWeb.GraphQL.Integration.Products.BusinessIndustryIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns BusinessIndustry by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_industry = insert(:tp_business_industry, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        allBusinessIndustries {
          id
          inserted_at
          name
          updated_at
          business_tax_returns {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessIndustries"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessIndustries"]

      assert List.first(data)["id"]                                  == business_industry.id
      assert List.first(data)["business_tax_returns"]["id"]          == business_industry.business_tax_returns.id
      assert List.first(data)["business_tax_returns"]["inserted_at"] == formatting_time(business_industry.business_tax_returns.inserted_at)
      assert List.first(data)["business_tax_returns"]["updated_at"]  == formatting_time(business_industry.business_tax_returns.updated_at)
      assert List.first(data)["inserted_at"]                         == formatting_time(business_industry.inserted_at)
      assert List.first(data)["name"]                                == business_industry.name
      assert List.first(data)["updated_at"]                          == formatting_time(business_industry.updated_at)

      {:ok, %{data: %{"allBusinessIndustries" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                  == business_industry.id
      assert first["business_tax_returns"]["id"]          == business_industry.business_tax_returns.id
      assert first["business_tax_returns"]["inserted_at"] == formatting_time(business_industry.business_tax_returns.inserted_at)
      assert first["business_tax_returns"]["updated_at"]  == formatting_time(business_industry.business_tax_returns.updated_at)
      assert first["inserted_at"]                         == formatting_time(business_industry.inserted_at)
      assert first["name"]                                == business_industry.name
      assert first["updated_at"]                          == formatting_time(business_industry.updated_at)
    end

    it "returns BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_industry = insert(:pro_business_industry, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        allBusinessIndustries {
          id
          inserted_at
          name
          updated_at
          business_tax_returns {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessIndustries"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessIndustries"]

      assert List.first(data)["id"]                                  == business_industry.id
      assert List.first(data)["business_tax_returns"]["id"]          == business_industry.business_tax_returns.id
      assert List.first(data)["business_tax_returns"]["inserted_at"] == formatting_time(business_industry.business_tax_returns.inserted_at)
      assert List.first(data)["business_tax_returns"]["updated_at"]  == formatting_time(business_industry.business_tax_returns.updated_at)
      assert List.first(data)["inserted_at"]                         == formatting_time(business_industry.inserted_at)
      assert List.first(data)["name"]                                == business_industry.name
      assert List.first(data)["updated_at"]                          == formatting_time(business_industry.updated_at)

      {:ok, %{data: %{"allBusinessIndustries" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                  == business_industry.id
      assert first["business_tax_returns"]["id"]          == business_industry.business_tax_returns.id
      assert first["business_tax_returns"]["inserted_at"] == formatting_time(business_industry.business_tax_returns.inserted_at)
      assert first["business_tax_returns"]["updated_at"]  == formatting_time(business_industry.business_tax_returns.updated_at)
      assert first["inserted_at"]                         == formatting_time(business_industry.inserted_at)
      assert first["name"]                                == business_industry.name
      assert first["updated_at"]                          == formatting_time(business_industry.updated_at)
    end
  end

  describe "#show" do
    it "returns specific BusinessIndustry by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_industry = insert(:tp_business_industry, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        showBusinessIndustry(id: \"#{business_industry.id}\") {
          id
          inserted_at
          name
          updated_at
          business_tax_returns {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      {:ok, %{data: %{"showBusinessIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_industry.id
      assert found["business_tax_returns"]["id"]          == business_industry.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_industry.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_industry.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_industry.inserted_at)
      assert found["name"]                                == business_industry.name
      assert found["updated_at"]                          == formatting_time(business_industry.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessIndustry"]

      assert found["id"]                                  == business_industry.id
      assert found["business_tax_returns"]["id"]          == business_industry.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_industry.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_industry.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_industry.inserted_at)
      assert found["name"]                                == business_industry.name
      assert found["updated_at"]                          == formatting_time(business_industry.updated_at)
    end

    it "returns specific BusinessIndustry by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_industry = insert(:pro_business_industry, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        showBusinessIndustry(id: \"#{business_industry.id}\") {
          id
          inserted_at
          name
          updated_at
          business_tax_returns {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      {:ok, %{data: %{"showBusinessIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_industry.id
      assert found["business_tax_returns"]["id"]          == business_industry.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_industry.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_industry.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_industry.inserted_at)
      assert found["name"]                                == business_industry.name
      assert found["updated_at"]                          == formatting_time(business_industry.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessIndustry"]

      assert found["id"]                                  == business_industry.id
      assert found["business_tax_returns"]["id"]          == business_industry.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_industry.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_industry.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_industry.inserted_at)
      assert found["name"]                                == business_industry.name
      assert found["updated_at"]                          == formatting_time(business_industry.updated_at)
    end
  end

  describe "#find" do
    it "find specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_industry = insert(:tp_business_industry, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        findBusinessIndustry(id: \"#{business_industry.id}\") {
          id
          inserted_at
          name
          updated_at
          business_tax_returns {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      {:ok, %{data: %{"findBusinessIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_industry.id
      assert found["business_tax_returns"]["id"]          == business_industry.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_industry.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_industry.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_industry.inserted_at)
      assert found["name"]                                == business_industry.name
      assert found["updated_at"]                          == formatting_time(business_industry.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessIndustry"]

      assert found["id"]                                  == business_industry.id
      assert found["business_tax_returns"]["id"]          == business_industry.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_industry.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_industry.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_industry.inserted_at)
      assert found["name"]                                == business_industry.name
      assert found["updated_at"]                          == formatting_time(business_industry.updated_at)
    end

    it "find specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_industry = insert(:pro_business_industry, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        findBusinessIndustry(id: \"#{business_industry.id}\") {
          id
          inserted_at
          name
          updated_at
          business_tax_returns {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      {:ok, %{data: %{"findBusinessIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_industry.id
      assert found["business_tax_returns"]["id"]          == business_industry.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_industry.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_industry.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_industry.inserted_at)
      assert found["name"]                                == business_industry.name
      assert found["updated_at"]                          == formatting_time(business_industry.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessIndustry"]

      assert found["id"]                                  == business_industry.id
      assert found["business_tax_returns"]["id"]          == business_industry.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_industry.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_industry.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_industry.inserted_at)
      assert found["name"]                                == business_industry.name
      assert found["updated_at"]                          == formatting_time(business_industry.updated_at)
    end
  end

  describe "#create" do
    it "created BusinessIndustry by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})

      mutation = """
      {
        createBusinessIndustry(
          name: "some name",
          business_tax_returnId: \"#{business_tax_return.id}\"
        ) {
          id
          inserted_at
          name
          updated_at
          business_tax_returns {
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

      created = json_response(res, 200)["data"]["createBusinessIndustry"]

      assert created["business_tax_returns"]["id"] == business_tax_return.id
      assert created["inserted_at"]                == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                       == "some name"
      assert created["updated_at"]                 == formatting_time(DateTime.truncate(Timex.now(), :second))
    end

    it "created BusinessIndustry by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})

      mutation = """
      {
        createBusinessIndustry(
          name: "some name",
          business_tax_returnId: \"#{business_tax_return.id}\"
        ) {
          id
          inserted_at
          name
          updated_at
          business_tax_returns {
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

      created = json_response(res, 200)["data"]["createBusinessIndustry"]

      assert created["business_tax_returns"]["id"] == business_tax_return.id
      assert created["inserted_at"]                == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                       == "some name"
      assert created["updated_at"]                 == formatting_time(DateTime.truncate(Timex.now(), :second))
    end
  end

  describe "#update" do
    it "updated specific BusinessIndustry by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_industry = insert(:business_industry, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        updateBusinessIndustry(
          id: \"#{business_industry.id}\",
          business_industry: {
            name: "updated some name",
            business_tax_returnId: \"#{business_tax_return.id}\"
          }
        )
        {
          id
          inserted_at
          name
          updated_at
          business_tax_returns {
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

      updated = json_response(res, 200)["data"]["updateBusinessIndustry"]

      assert updated["id"]                                  == business_industry.id
      assert updated["business_tax_returns"]["id"]          == business_tax_return.id
      assert updated["business_tax_returns"]["inserted_at"] == formatting_time(business_industry.business_tax_returns.inserted_at)
      assert updated["business_tax_returns"]["updated_at"]  == formatting_time(business_industry.business_tax_returns.updated_at)
      assert updated["inserted_at"]                         == formatting_time(business_industry.inserted_at)
      assert updated["name"]                                == "updated some name"
    end

    it "updated specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_industry = insert(:business_industry, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        updateBusinessIndustry(
          id: \"#{business_industry.id}\",
          business_industry: {
            business_tax_returnId: \"#{business_tax_return.id}\"
            name: "updated some name",
          }
        )
        {
          id
          inserted_at
          name
          updated_at
          business_tax_returns {
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

      updated = json_response(res, 200)["data"]["updateBusinessIndustry"]

      assert updated["id"]                                  == business_industry.id
      assert updated["business_tax_returns"]["id"]          == business_tax_return.id
      assert updated["business_tax_returns"]["inserted_at"] == formatting_time(business_industry.business_tax_returns.inserted_at)
      assert updated["business_tax_returns"]["updated_at"]  == formatting_time(business_industry.business_tax_returns.updated_at)
      assert updated["inserted_at"]                         == formatting_time(business_industry.inserted_at)
      assert updated["name"]                                == "updated some name"
      assert updated["updated_at"]                          == formatting_time(business_industry.updated_at)
    end
  end

  describe "#delete" do
    it "delete specific BusinessIndustry" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, %{user: user})
      business_industry = insert(:business_industry, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        deleteBusinessIndustry(id: \"#{business_industry.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteBusinessIndustry"]
      assert deleted["id"] == business_industry.id
    end
  end

  describe "#dataloads" do
    it "created BusinessIndustry by role's Tp" do
       user = insert(:tp_user)
       %{id: business_tax_return_id} = insert(:tp_business_tax_return, user: user)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:business_industries, source)
        |> Dataloader.load(:business_industries, Core.Services.BusinessTaxReturn, business_tax_return_id)
        |> Dataloader.run

      data = Dataloader.get(loader, :business_industries, Core.Services.BusinessTaxReturn, business_tax_return_id)

      assert data.id == business_tax_return_id
    end
  end

  defp formatting_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

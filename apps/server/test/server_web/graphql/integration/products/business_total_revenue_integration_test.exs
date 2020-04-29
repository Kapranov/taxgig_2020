defmodule ServerWeb.GraphQL.Integration.Products.BusinessTotalRevenueIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns BusinessTotalRevenue by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_total_revenue = insert(:tp_business_total_revenue, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        allBusinessTotalRevenues {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessTotalRevenues"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessTotalRevenues"]

      assert List.first(data)["id"]                                  == business_total_revenue.id
      assert List.first(data)["business_tax_returns"]["id"]          == business_total_revenue.business_tax_returns.id
      assert List.first(data)["business_tax_returns"]["inserted_at"] == formatting_time(business_total_revenue.business_tax_returns.inserted_at)
      assert List.first(data)["business_tax_returns"]["updated_at"]  == formatting_time(business_total_revenue.business_tax_returns.updated_at)
      assert List.first(data)["inserted_at"]                         == formatting_time(business_total_revenue.inserted_at)
      assert List.first(data)["name"]                                == business_total_revenue.name
      assert List.first(data)["updated_at"]                          == formatting_time(business_total_revenue.updated_at)

      {:ok, %{data: %{"allBusinessTotalRevenues" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                  == business_total_revenue.id
      assert first["business_tax_returns"]["id"]          == business_total_revenue.business_tax_returns.id
      assert first["business_tax_returns"]["inserted_at"] == formatting_time(business_total_revenue.business_tax_returns.inserted_at)
      assert first["business_tax_returns"]["updated_at"]  == formatting_time(business_total_revenue.business_tax_returns.updated_at)
      assert first["inserted_at"]                         == formatting_time(business_total_revenue.inserted_at)
      assert first["name"]                                == business_total_revenue.name
      assert first["updated_at"]                          == formatting_time(business_total_revenue.updated_at)
    end

    it "returns BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_total_revenue = insert(:pro_business_total_revenue, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        allBusinessTotalRevenues {
          id
          inserted_at
          name
          price
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessTotalRevenues"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessTotalRevenues"]

      assert List.first(data)["id"]                                  == business_total_revenue.id
      assert List.first(data)["business_tax_returns"]["id"]          == business_total_revenue.business_tax_returns.id
      assert List.first(data)["business_tax_returns"]["inserted_at"] == formatting_time(business_total_revenue.business_tax_returns.inserted_at)
      assert List.first(data)["business_tax_returns"]["updated_at"]  == formatting_time(business_total_revenue.business_tax_returns.updated_at)
      assert List.first(data)["inserted_at"]                         == formatting_time(business_total_revenue.inserted_at)
      assert List.first(data)["name"]                                == business_total_revenue.name
      assert List.first(data)["price"]                               == business_total_revenue.price
      assert List.first(data)["updated_at"]                          == formatting_time(business_total_revenue.updated_at)

      {:ok, %{data: %{"allBusinessTotalRevenues" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                  == business_total_revenue.id
      assert first["business_tax_returns"]["id"]          == business_total_revenue.business_tax_returns.id
      assert first["business_tax_returns"]["inserted_at"] == formatting_time(business_total_revenue.business_tax_returns.inserted_at)
      assert first["business_tax_returns"]["updated_at"]  == formatting_time(business_total_revenue.business_tax_returns.updated_at)
      assert first["inserted_at"]                         == formatting_time(business_total_revenue.inserted_at)
      assert first["name"]                                == business_total_revenue.name
      assert first["price"]                               == business_total_revenue.price
      assert first["updated_at"]                          == formatting_time(business_total_revenue.updated_at)
    end
  end

  describe "#show" do
    it "returns specific BusinessTotalRevenue by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_total_revenue = insert(:tp_business_total_revenue, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        showBusinessTotalRevenue(id: \"#{business_total_revenue.id}\") {
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

      {:ok, %{data: %{"showBusinessTotalRevenue" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_total_revenue.id
      assert found["business_tax_returns"]["id"]          == business_total_revenue.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_total_revenue.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_total_revenue.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_total_revenue.inserted_at)
      assert found["name"]                                == business_total_revenue.name
      assert found["updated_at"]                          == formatting_time(business_total_revenue.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessTotalRevenue"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessTotalRevenue"]

      assert found["id"]                                  == business_total_revenue.id
      assert found["business_tax_returns"]["id"]          == business_total_revenue.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_total_revenue.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_total_revenue.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_total_revenue.inserted_at)
      assert found["name"]                                == business_total_revenue.name
      assert found["updated_at"]                          == formatting_time(business_total_revenue.updated_at)
    end

    it "returns specific BusinessTotalRevenue by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_total_revenue = insert(:pro_business_total_revenue, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        showBusinessTotalRevenue(id: \"#{business_total_revenue.id}\") {
          id
          inserted_at
          name
          price
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

      {:ok, %{data: %{"showBusinessTotalRevenue" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_total_revenue.id
      assert found["business_tax_returns"]["id"]          == business_total_revenue.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_total_revenue.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_total_revenue.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_total_revenue.inserted_at)
      assert found["name"]                                == business_total_revenue.name
      assert found["price"]                               == business_total_revenue.price
      assert found["updated_at"]                          == formatting_time(business_total_revenue.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessTotalRevenue"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessTotalRevenue"]

      assert found["id"]                                  == business_total_revenue.id
      assert found["business_tax_returns"]["id"]          == business_total_revenue.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_total_revenue.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_total_revenue.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_total_revenue.inserted_at)
      assert found["name"]                                == business_total_revenue.name
      assert found["price"]                               == business_total_revenue.price
      assert found["updated_at"]                          == formatting_time(business_total_revenue.updated_at)
    end
  end

  describe "#find" do
    it "find specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_total_revenue = insert(:tp_business_total_revenue, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        findBusinessTotalRevenue(id: \"#{business_total_revenue.id}\") {
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

      {:ok, %{data: %{"findBusinessTotalRevenue" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_total_revenue.id
      assert found["business_tax_returns"]["id"]          == business_total_revenue.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_total_revenue.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_total_revenue.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_total_revenue.inserted_at)
      assert found["name"]                                == business_total_revenue.name
      assert found["updated_at"]                          == formatting_time(business_total_revenue.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessTotalRevenue"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessTotalRevenue"]

      assert found["id"]                                  == business_total_revenue.id
      assert found["business_tax_returns"]["id"]          == business_total_revenue.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_total_revenue.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_total_revenue.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_total_revenue.inserted_at)
      assert found["name"]                                == business_total_revenue.name
      assert found["updated_at"]                          == formatting_time(business_total_revenue.updated_at)
    end

    it "find specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_total_revenue = insert(:pro_business_total_revenue, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        findBusinessTotalRevenue(id: \"#{business_total_revenue.id}\") {
          id
          inserted_at
          name
          price
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

      {:ok, %{data: %{"findBusinessTotalRevenue" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_total_revenue.id
      assert found["business_tax_returns"]["id"]          == business_total_revenue.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_total_revenue.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_total_revenue.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_total_revenue.inserted_at)
      assert found["name"]                                == business_total_revenue.name
      assert found["price"]                               == business_total_revenue.price
      assert found["updated_at"]                          == formatting_time(business_total_revenue.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessTotalRevenue"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessTotalRevenue"]

      assert found["id"]                                  == business_total_revenue.id
      assert found["business_tax_returns"]["id"]          == business_total_revenue.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_total_revenue.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_total_revenue.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_total_revenue.inserted_at)
      assert found["name"]                                == business_total_revenue.name
      assert found["price"]                               == business_total_revenue.price
      assert found["updated_at"]                          == formatting_time(business_total_revenue.updated_at)
    end
  end

  describe "#create" do
    it "created BusinessTotalRevenue by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})

      mutation = """
      {
        createBusinessTotalRevenue(
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

      created = json_response(res, 200)["data"]["createBusinessTotalRevenue"]

      assert created["business_tax_returns"]["id"] == business_tax_return.id
      assert created["inserted_at"]                == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                       == "some name"
      assert created["updated_at"]                 == formatting_time(DateTime.truncate(Timex.now(), :second))
    end

    it "created BusinessTotalRevenue by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})

      mutation = """
      {
        createBusinessTotalRevenue(
          business_tax_returnId: \"#{business_tax_return.id}\",
          name: "some name",
          price: 12
        ) {
          id
          inserted_at
          name
          price
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

      created = json_response(res, 200)["data"]["createBusinessTotalRevenue"]

      assert created["business_tax_returns"]["id"] == business_tax_return.id
      assert created["inserted_at"]                == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                       == "some name"
      assert created["price"]                      == 12
      assert created["updated_at"]                 == formatting_time(DateTime.truncate(Timex.now(), :second))
    end
  end

  describe "#update" do
    it "updated specific BusinessTotalRevenue by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_total_revenue = insert(:business_total_revenue, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        updateBusinessTotalRevenue(
          id: \"#{business_total_revenue.id}\",
          business_total_revenue: {
            business_tax_returnId: \"#{business_tax_return.id}\",
            name: "updated some name"
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

      updated = json_response(res, 200)["data"]["updateBusinessTotalRevenue"]

      assert updated["id"]                                  == business_total_revenue.id
      assert updated["business_tax_returns"]["id"]          == business_tax_return.id
      assert updated["business_tax_returns"]["inserted_at"] == formatting_time(business_total_revenue.business_tax_returns.inserted_at)
      assert updated["business_tax_returns"]["updated_at"]  == formatting_time(business_total_revenue.business_tax_returns.updated_at)
      assert updated["inserted_at"]                         == formatting_time(business_total_revenue.inserted_at)
      assert updated["name"]                                == "updated some name"
      assert updated["updated_at"]                          == formatting_time(business_total_revenue.updated_at)
    end

    it "updated specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_total_revenue = insert(:business_total_revenue, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        updateBusinessTotalRevenue(
          id: \"#{business_total_revenue.id}\",
          business_total_revenue: {
            business_tax_returnId: \"#{business_tax_return.id}\",
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

      updated = json_response(res, 200)["data"]["updateBusinessTotalRevenue"]

      assert updated["id"]                                  == business_total_revenue.id
      assert updated["business_tax_returns"]["id"]          == business_tax_return.id
      assert updated["business_tax_returns"]["inserted_at"] == formatting_time(business_total_revenue.business_tax_returns.inserted_at)
      assert updated["business_tax_returns"]["updated_at"]  == formatting_time(business_total_revenue.business_tax_returns.updated_at)
      assert updated["inserted_at"]                         == formatting_time(business_total_revenue.inserted_at)
      assert updated["name"]                                == "updated some name"
      assert updated["price"]                               == 13
      assert updated["updated_at"]                          == formatting_time(business_total_revenue.updated_at)
    end
  end

  describe "#delete" do
    it "delete specific BusinessTotalRevenue" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, %{user: user})
      business_total_revenue = insert(:business_total_revenue, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        deleteBusinessTotalRevenue(id: \"#{business_total_revenue.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteBusinessTotalRevenue"]
      assert deleted["id"] == business_total_revenue.id
    end
  end

  describe "#dataloads" do
    it "created BusinessTotalRevenue by role's Tp" do
       user = insert(:tp_user)
       %{id: business_tax_return_id} = insert(:tp_business_tax_return, user: user)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:business_total_revenues, source)
        |> Dataloader.load(:business_total_revenues, Core.Services.BusinessTaxReturn, business_tax_return_id)
        |> Dataloader.run

      data = Dataloader.get(loader, :business_total_revenues, Core.Services.BusinessTaxReturn, business_tax_return_id)

      assert data.id == business_tax_return_id
    end
  end

  defp formatting_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

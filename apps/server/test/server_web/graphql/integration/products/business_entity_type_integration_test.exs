defmodule ServerWeb.GraphQL.Integration.Products.BusinessEntityTypeIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns BusinessEntityType by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_entity_type = insert(:tp_business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        allBusinessEntityTypes {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessEntityTypes"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessEntityTypes"]

      assert List.first(data)["id"]                                  == business_entity_type.id
      assert List.first(data)["business_tax_returns"]["id"]          == business_entity_type.business_tax_returns.id
      assert List.first(data)["business_tax_returns"]["inserted_at"] == formatting_time(business_entity_type.business_tax_returns.inserted_at)
      assert List.first(data)["business_tax_returns"]["updated_at"]  == formatting_time(business_entity_type.business_tax_returns.updated_at)
      assert List.first(data)["inserted_at"]                         == formatting_time(business_entity_type.inserted_at)
      assert List.first(data)["name"]                                == business_entity_type.name
      assert List.first(data)["updated_at"]                          == formatting_time(business_entity_type.updated_at)

      {:ok, %{data: %{"allBusinessEntityTypes" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                  == business_entity_type.id
      assert first["business_tax_returns"]["id"]          == business_entity_type.business_tax_returns.id
      assert first["business_tax_returns"]["inserted_at"] == formatting_time(business_entity_type.business_tax_returns.inserted_at)
      assert first["business_tax_returns"]["updated_at"]  == formatting_time(business_entity_type.business_tax_returns.updated_at)
      assert first["inserted_at"]                         == formatting_time(business_entity_type.inserted_at)
      assert first["name"]                                == business_entity_type.name
      assert first["updated_at"]                          == formatting_time(business_entity_type.updated_at)
    end

    it "returns BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_entity_type = insert(:pro_business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        allBusinessEntityTypes {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessEntityTypes"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessEntityTypes"]

      assert List.first(data)["id"]                                  == business_entity_type.id
      assert List.first(data)["business_tax_returns"]["id"]          == business_entity_type.business_tax_returns.id
      assert List.first(data)["business_tax_returns"]["inserted_at"] == formatting_time(business_entity_type.business_tax_returns.inserted_at)
      assert List.first(data)["business_tax_returns"]["updated_at"]  == formatting_time(business_entity_type.business_tax_returns.updated_at)
      assert List.first(data)["inserted_at"]                         == formatting_time(business_entity_type.inserted_at)
      assert List.first(data)["name"]                                == business_entity_type.name
      assert List.first(data)["price"]                               == business_entity_type.price
      assert List.first(data)["updated_at"]                          == formatting_time(business_entity_type.updated_at)

      {:ok, %{data: %{"allBusinessEntityTypes" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                  == business_entity_type.id
      assert first["business_tax_returns"]["id"]          == business_entity_type.business_tax_returns.id
      assert first["business_tax_returns"]["inserted_at"] == formatting_time(business_entity_type.business_tax_returns.inserted_at)
      assert first["business_tax_returns"]["updated_at"]  == formatting_time(business_entity_type.business_tax_returns.updated_at)
      assert first["inserted_at"]                         == formatting_time(business_entity_type.inserted_at)
      assert first["name"]                                == business_entity_type.name
      assert first["price"]                               == business_entity_type.price
      assert first["updated_at"]                          == formatting_time(business_entity_type.updated_at)
    end
  end

  describe "#show" do
    it "returns specific BusinessEntityType by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_entity_type = insert(:tp_business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        showBusinessEntityType(id: \"#{business_entity_type.id}\") {
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

      {:ok, %{data: %{"showBusinessEntityType" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_entity_type.id
      assert found["business_tax_returns"]["id"]          == business_entity_type.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_entity_type.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_entity_type.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_entity_type.inserted_at)
      assert found["name"]                                == business_entity_type.name
      assert found["updated_at"]                          == formatting_time(business_entity_type.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessEntityType"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessEntityType"]

      assert found["id"]                                  == business_entity_type.id
      assert found["business_tax_returns"]["id"]          == business_entity_type.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_entity_type.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_entity_type.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_entity_type.inserted_at)
      assert found["name"]                                == business_entity_type.name
      assert found["updated_at"]                          == formatting_time(business_entity_type.updated_at)
    end

    it "returns specific BusinessEntityType by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_entity_type = insert(:pro_business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        showBusinessEntityType(id: \"#{business_entity_type.id}\") {
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

      {:ok, %{data: %{"showBusinessEntityType" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_entity_type.id
      assert found["business_tax_returns"]["id"]          == business_entity_type.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_entity_type.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_entity_type.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_entity_type.inserted_at)
      assert found["name"]                                == business_entity_type.name
      assert found["price"]                               == business_entity_type.price
      assert found["updated_at"]                          == formatting_time(business_entity_type.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessEntityType"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessEntityType"]

      assert found["id"]                                  == business_entity_type.id
      assert found["business_tax_returns"]["id"]          == business_entity_type.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_entity_type.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_entity_type.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_entity_type.inserted_at)
      assert found["name"]                                == business_entity_type.name
      assert found["price"]                               == business_entity_type.price
      assert found["updated_at"]                          == formatting_time(business_entity_type.updated_at)
    end
  end

  describe "#find" do
    it "find specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_entity_type = insert(:tp_business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        findBusinessEntityType(id: \"#{business_entity_type.id}\") {
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

      {:ok, %{data: %{"findBusinessEntityType" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_entity_type.id
      assert found["business_tax_returns"]["id"]          == business_entity_type.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_entity_type.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_entity_type.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_entity_type.inserted_at)
      assert found["name"]                                == business_entity_type.name
      assert found["updated_at"]                          == formatting_time(business_entity_type.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessEntityType"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessEntityType"]

      assert found["id"]                                  == business_entity_type.id
      assert found["business_tax_returns"]["id"]          == business_entity_type.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_entity_type.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_entity_type.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_entity_type.inserted_at)
      assert found["name"]                                == business_entity_type.name
      assert found["updated_at"]                          == formatting_time(business_entity_type.updated_at)
    end

    it "find specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_entity_type = insert(:pro_business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        findBusinessEntityType(id: \"#{business_entity_type.id}\") {
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

      {:ok, %{data: %{"findBusinessEntityType" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_entity_type.id
      assert found["business_tax_returns"]["id"]          == business_entity_type.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_entity_type.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_entity_type.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_entity_type.inserted_at)
      assert found["name"]                                == business_entity_type.name
      assert found["price"]                               == business_entity_type.price
      assert found["updated_at"]                          == formatting_time(business_entity_type.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessEntityType"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessEntityType"]

      assert found["id"]                                  == business_entity_type.id
      assert found["business_tax_returns"]["id"]          == business_entity_type.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_entity_type.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_entity_type.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_entity_type.inserted_at)
      assert found["name"]                                == business_entity_type.name
      assert found["price"]                               == business_entity_type.price
      assert found["updated_at"]                          == formatting_time(business_entity_type.updated_at)
    end
  end

  describe "#create" do
    it "created BusinessEntityType by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})

      mutation = """
      {
        createBusinessEntityType(
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

      created = json_response(res, 200)["data"]["createBusinessEntityType"]

      assert created["business_tax_returns"]["id"] == business_tax_return.id
      assert created["inserted_at"]                == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                       == "some name"
      assert created["updated_at"]                 == formatting_time(DateTime.truncate(Timex.now(), :second))
    end

    it "created BusinessEntityType by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})

      mutation = """
      {
        createBusinessEntityType(
          name: "some name",
          price: 12,
          business_tax_returnId: \"#{business_tax_return.id}\"
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

      created = json_response(res, 200)["data"]["createBusinessEntityType"]

      assert created["business_tax_returns"]["id"] == business_tax_return.id
      assert created["inserted_at"]                == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                       == "some name"
      assert created["price"]                      == 12
      assert created["updated_at"]                 == formatting_time(DateTime.truncate(Timex.now(), :second))
    end
  end

  describe "#update" do
    it "updated specific BusinessEntityType by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_entity_type = insert(:business_entity_type, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        updateBusinessEntityType(
          id: \"#{business_entity_type.id}\",
          business_entity_type: {
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
            user { id }
            inserted_at
            updated_at
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateBusinessEntityType"]

      assert updated["id"]                                  == business_entity_type.id
      assert updated["business_tax_returns"]["id"]          == business_tax_return.id
      assert updated["business_tax_returns"]["inserted_at"] == formatting_time(business_entity_type.business_tax_returns.inserted_at)
      assert updated["business_tax_returns"]["updated_at"]  == formatting_time(business_entity_type.business_tax_returns.updated_at)
      assert updated["inserted_at"]                         == formatting_time(business_entity_type.inserted_at)
      assert updated["name"]                                == "updated some name"
      assert updated["updated_at"]                          == formatting_time(business_entity_type.updated_at)
    end

    it "updated specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_entity_type = insert(:business_entity_type, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        updateBusinessEntityType(
          id: \"#{business_entity_type.id}\",
          business_entity_type: {
            name: "updated some name",
            price: 13,
            business_tax_returnId: \"#{business_tax_return.id}\"
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

      updated = json_response(res, 200)["data"]["updateBusinessEntityType"]

      assert updated["id"]                                  == business_entity_type.id
      assert updated["business_tax_returns"]["id"]          == business_tax_return.id
      assert updated["business_tax_returns"]["inserted_at"] == formatting_time(business_entity_type.business_tax_returns.inserted_at)
      assert updated["business_tax_returns"]["updated_at"]  == formatting_time(business_entity_type.business_tax_returns.updated_at)
      assert updated["inserted_at"]                         == formatting_time(business_entity_type.inserted_at)
      assert updated["name"]                                == "updated some name"
      assert updated["price"]                               == 13
      assert updated["updated_at"]                          == formatting_time(business_entity_type.updated_at)
    end
  end

  describe "#delete" do
    it "delete specific BusinessEntityType" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, %{user: user})
      business_entity_type = insert(:business_entity_type, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        deleteBusinessEntityType(id: \"#{business_entity_type.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteBusinessEntityType"]
      assert deleted["id"] == business_entity_type.id
    end
  end

  describe "#dataloads" do
    it "created BusinessEntityType by role's Tp" do
       user = insert(:tp_user)
       %{id: business_tax_return_id} = insert(:tp_business_tax_return, user: user)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:business_entity_types, source)
        |> Dataloader.load(:business_entity_types, Core.Services.BusinessTaxReturn, business_tax_return_id)
        |> Dataloader.run

      data = Dataloader.get(loader, :business_entity_types, Core.Services.BusinessTaxReturn, business_tax_return_id)

      assert data.id == business_tax_return_id
    end
  end

  defp formatting_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

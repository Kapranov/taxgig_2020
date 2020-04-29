defmodule ServerWeb.GraphQL.Integration.Products.BusinessLlcTypeIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns BusinessLlcType by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_llc_type = insert(:tp_business_llc_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        allBusinessLlcTypes {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessLlcTypes"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessLlcTypes"]

      assert List.first(data)["id"]                                  == business_llc_type.id
      assert List.first(data)["business_tax_returns"]["id"]          == business_llc_type.business_tax_returns.id
      assert List.first(data)["business_tax_returns"]["inserted_at"] == formatting_time(business_llc_type.business_tax_returns.inserted_at)
      assert List.first(data)["business_tax_returns"]["updated_at"]  == formatting_time(business_llc_type.business_tax_returns.updated_at)
      assert List.first(data)["inserted_at"]                         == formatting_time(business_llc_type.inserted_at)
      assert List.first(data)["name"]                                == business_llc_type.name
      assert List.first(data)["updated_at"]                          == formatting_time(business_llc_type.updated_at)

      {:ok, %{data: %{"allBusinessLlcTypes" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                  == business_llc_type.id
      assert first["business_tax_returns"]["id"]          == business_llc_type.business_tax_returns.id
      assert first["business_tax_returns"]["inserted_at"] == formatting_time(business_llc_type.business_tax_returns.inserted_at)
      assert first["business_tax_returns"]["updated_at"]  == formatting_time(business_llc_type.business_tax_returns.updated_at)
      assert first["inserted_at"]                         == formatting_time(business_llc_type.inserted_at)
      assert first["name"]                                == business_llc_type.name
      assert first["updated_at"]                          == formatting_time(business_llc_type.updated_at)
    end

    it "returns BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_llc_type = insert(:pro_business_llc_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        allBusinessLlcTypes {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessLlcTypes"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessLlcTypes"]

      assert List.first(data)["id"]                                  == business_llc_type.id
      assert List.first(data)["business_tax_returns"]["id"]          == business_llc_type.business_tax_returns.id
      assert List.first(data)["business_tax_returns"]["inserted_at"] == formatting_time(business_llc_type.business_tax_returns.inserted_at)
      assert List.first(data)["business_tax_returns"]["updated_at"]  == formatting_time(business_llc_type.business_tax_returns.updated_at)
      assert List.first(data)["inserted_at"]                         == formatting_time(business_llc_type.inserted_at)
      assert List.first(data)["name"]                                == business_llc_type.name
      assert List.first(data)["updated_at"]                          == formatting_time(business_llc_type.updated_at)

      {:ok, %{data: %{"allBusinessLlcTypes" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                  == business_llc_type.id
      assert first["business_tax_returns"]["id"]          == business_llc_type.business_tax_returns.id
      assert first["business_tax_returns"]["inserted_at"] == formatting_time(business_llc_type.business_tax_returns.inserted_at)
      assert first["business_tax_returns"]["updated_at"]  == formatting_time(business_llc_type.business_tax_returns.updated_at)
      assert first["inserted_at"]                         == formatting_time(business_llc_type.inserted_at)
      assert first["name"]                                == business_llc_type.name
      assert first["updated_at"]                          == formatting_time(business_llc_type.updated_at)
    end
  end

  describe "#show" do
    it "returns specific BusinessLlcType by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_llc_type = insert(:tp_business_llc_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        showBusinessLlcType(id: \"#{business_llc_type.id}\") {
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

      {:ok, %{data: %{"showBusinessLlcType" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_llc_type.id
      assert found["business_tax_returns"]["id"]          == business_llc_type.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_llc_type.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_llc_type.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_llc_type.inserted_at)
      assert found["name"]                                == business_llc_type.name
      assert found["updated_at"]                          == formatting_time(business_llc_type.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessLlcType"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessLlcType"]

      assert found["id"]                                  == business_llc_type.id
      assert found["business_tax_returns"]["id"]          == business_llc_type.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_llc_type.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_llc_type.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_llc_type.inserted_at)
      assert found["name"]                                == business_llc_type.name
      assert found["updated_at"]                          == formatting_time(business_llc_type.updated_at)
    end

    it "returns specific BusinessLlcType by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_llc_type = insert(:pro_business_llc_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        showBusinessLlcType(id: \"#{business_llc_type.id}\") {
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

      {:ok, %{data: %{"showBusinessLlcType" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_llc_type.id
      assert found["business_tax_returns"]["id"]          == business_llc_type.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_llc_type.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_llc_type.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_llc_type.inserted_at)
      assert found["name"]                                == business_llc_type.name
      assert found["updated_at"]                          == formatting_time(business_llc_type.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessLlcType"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessLlcType"]

      assert found["id"]                                  == business_llc_type.id
      assert found["business_tax_returns"]["id"]          == business_llc_type.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_llc_type.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_llc_type.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_llc_type.inserted_at)
      assert found["name"]                                == business_llc_type.name
      assert found["updated_at"]                          == formatting_time(business_llc_type.updated_at)
    end
  end

  describe "#find" do
    it "find specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_llc_type = insert(:tp_business_llc_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        findBusinessLlcType(id: \"#{business_llc_type.id}\") {
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

      {:ok, %{data: %{"findBusinessLlcType" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_llc_type.id
      assert found["business_tax_returns"]["id"]          == business_llc_type.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_llc_type.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_llc_type.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_llc_type.inserted_at)
      assert found["name"]                                == business_llc_type.name
      assert found["updated_at"]                          == formatting_time(business_llc_type.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessLlcType"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessLlcType"]

      assert found["id"]                                  == business_llc_type.id
      assert found["business_tax_returns"]["id"]          == business_llc_type.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_llc_type.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_llc_type.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_llc_type.inserted_at)
      assert found["name"]                                == business_llc_type.name
      assert found["updated_at"]                          == formatting_time(business_llc_type.updated_at)
    end

    it "find specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_llc_type = insert(:pro_business_llc_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        findBusinessLlcType(id: \"#{business_llc_type.id}\") {
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

      {:ok, %{data: %{"findBusinessLlcType" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_llc_type.id
      assert found["business_tax_returns"]["id"]          == business_llc_type.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_llc_type.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_llc_type.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_llc_type.inserted_at)
      assert found["name"]                                == business_llc_type.name
      assert found["updated_at"]                          == formatting_time(business_llc_type.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessLlcType"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessLlcType"]

      assert found["id"]                                  == business_llc_type.id
      assert found["business_tax_returns"]["id"]          == business_llc_type.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_llc_type.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_llc_type.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_llc_type.inserted_at)
      assert found["name"]                                == business_llc_type.name
      assert found["updated_at"]                          == formatting_time(business_llc_type.updated_at)
    end
  end

  describe "#create" do
    it "created BusinessLlcType by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})

      mutation = """
      {
        createBusinessLlcType(
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

      created = json_response(res, 200)["data"]["createBusinessLlcType"]

      assert created["business_tax_returns"]["id"] == business_tax_return.id
      assert created["inserted_at"]                == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                       == "some name"
      assert created["updated_at"]                 == formatting_time(DateTime.truncate(Timex.now(), :second))
    end

    it "created BusinessLlcType by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})

      mutation = """
      {
        createBusinessLlcType(
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

      created = json_response(res, 200)["data"]["createBusinessLlcType"]

      assert created["business_tax_returns"]["id"] == business_tax_return.id
      assert created["inserted_at"]                == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                       == "some name"
      assert created["updated_at"]                 == formatting_time(DateTime.truncate(Timex.now(), :second))
    end
  end

  describe "#update" do
    it "updated specific BusinessLlcType by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_llc_type = insert(:business_llc_type, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        updateBusinessLlcType(
          id: \"#{business_llc_type.id}\",
          business_llc_type: {
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

      updated = json_response(res, 200)["data"]["updateBusinessLlcType"]

      assert updated["id"]                                  == business_llc_type.id
      assert updated["business_tax_returns"]["id"]          == business_tax_return.id
      assert updated["business_tax_returns"]["inserted_at"] == formatting_time(business_llc_type.business_tax_returns.inserted_at)
      assert updated["business_tax_returns"]["updated_at"]  == formatting_time(business_llc_type.business_tax_returns.updated_at)
      assert updated["inserted_at"]                         == formatting_time(business_llc_type.inserted_at)
      assert updated["name"]                                == "updated some name"
    end

    it "updated specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_llc_type = insert(:business_llc_type, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        updateBusinessLlcType(
          id: \"#{business_llc_type.id}\",
          business_llc_type: {
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

      updated = json_response(res, 200)["data"]["updateBusinessLlcType"]

      assert updated["id"]                                  == business_llc_type.id
      assert updated["business_tax_returns"]["id"]          == business_tax_return.id
      assert updated["business_tax_returns"]["inserted_at"] == formatting_time(business_llc_type.business_tax_returns.inserted_at)
      assert updated["business_tax_returns"]["updated_at"]  == formatting_time(business_llc_type.business_tax_returns.updated_at)
      assert updated["inserted_at"]                         == formatting_time(business_llc_type.inserted_at)
      assert updated["name"]                                == "updated some name"
      assert updated["updated_at"]                          == formatting_time(business_llc_type.updated_at)
    end
  end

  describe "#delete" do
    it "delete specific BusinessLlcType" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, %{user: user})
      business_llc_type = insert(:business_llc_type, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        deleteBusinessLlcType(id: \"#{business_llc_type.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteBusinessLlcType"]
      assert deleted["id"] == business_llc_type.id
    end
  end

  describe "#dataloads" do
    it "created BusinessLlcType by role's Tp" do
       user = insert(:tp_user)
       %{id: business_tax_return_id} = insert(:tp_business_tax_return, user: user)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:business_llc_types, source)
        |> Dataloader.load(:business_llc_types, Core.Services.BusinessTaxReturn, business_tax_return_id)
        |> Dataloader.run

      data = Dataloader.get(loader, :business_llc_types, Core.Services.BusinessTaxReturn, business_tax_return_id)

      assert data.id == business_tax_return_id
    end
  end

  defp formatting_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

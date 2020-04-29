defmodule ServerWeb.GraphQL.Integration.Products.BusinessForeignAccountCountIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns BusinessForeignAccountCount by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_foreign_account_count = insert(:tp_business_foreign_account_count, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        allBusinessForeignAccountCounts {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessForeignAccountCounts"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessForeignAccountCounts"]

      assert List.first(data)["id"]                                  == business_foreign_account_count.id
      assert List.first(data)["business_tax_returns"]["id"]          == business_foreign_account_count.business_tax_returns.id
      assert List.first(data)["business_tax_returns"]["inserted_at"] == formatting_time(business_foreign_account_count.business_tax_returns.inserted_at)
      assert List.first(data)["business_tax_returns"]["updated_at"]  == formatting_time(business_foreign_account_count.business_tax_returns.updated_at)
      assert List.first(data)["inserted_at"]                         == formatting_time(business_foreign_account_count.inserted_at)
      assert List.first(data)["name"]                                == business_foreign_account_count.name
      assert List.first(data)["updated_at"]                          == formatting_time(business_foreign_account_count.updated_at)

      {:ok, %{data: %{"allBusinessForeignAccountCounts" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                  == business_foreign_account_count.id
      assert first["business_tax_returns"]["id"]          == business_foreign_account_count.business_tax_returns.id
      assert first["business_tax_returns"]["inserted_at"] == formatting_time(business_foreign_account_count.business_tax_returns.inserted_at)
      assert first["business_tax_returns"]["updated_at"]  == formatting_time(business_foreign_account_count.business_tax_returns.updated_at)
      assert first["inserted_at"]                         == formatting_time(business_foreign_account_count.inserted_at)
      assert first["name"]                                == business_foreign_account_count.name
      assert first["updated_at"]                          == formatting_time(business_foreign_account_count.updated_at)
    end

    it "returns BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_foreign_account_count = insert(:pro_business_foreign_account_count, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        allBusinessForeignAccountCounts {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessForeignAccountCounts"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessForeignAccountCounts"]

      assert List.first(data)["id"]                                  == business_foreign_account_count.id
      assert List.first(data)["business_tax_returns"]["id"]          == business_foreign_account_count.business_tax_returns.id
      assert List.first(data)["business_tax_returns"]["inserted_at"] == formatting_time(business_foreign_account_count.business_tax_returns.inserted_at)
      assert List.first(data)["business_tax_returns"]["updated_at"]  == formatting_time(business_foreign_account_count.business_tax_returns.updated_at)
      assert List.first(data)["inserted_at"]                         == formatting_time(business_foreign_account_count.inserted_at)
      assert List.first(data)["name"]                                == business_foreign_account_count.name
      assert List.first(data)["updated_at"]                          == formatting_time(business_foreign_account_count.updated_at)

      {:ok, %{data: %{"allBusinessForeignAccountCounts" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                  == business_foreign_account_count.id
      assert first["business_tax_returns"]["id"]          == business_foreign_account_count.business_tax_returns.id
      assert first["business_tax_returns"]["inserted_at"] == formatting_time(business_foreign_account_count.business_tax_returns.inserted_at)
      assert first["business_tax_returns"]["updated_at"]  == formatting_time(business_foreign_account_count.business_tax_returns.updated_at)
      assert first["inserted_at"]                         == formatting_time(business_foreign_account_count.inserted_at)
      assert first["name"]                                == business_foreign_account_count.name
      assert first["updated_at"]                          == formatting_time(business_foreign_account_count.updated_at)
    end
  end

  describe "#show" do
    it "returns specific BusinessForeignAccountCount by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_foreign_account_count = insert(:tp_business_foreign_account_count, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        showBusinessForeignAccountCount(id: \"#{business_foreign_account_count.id}\") {
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

      {:ok, %{data: %{"showBusinessForeignAccountCount" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_foreign_account_count.id
      assert found["business_tax_returns"]["id"]          == business_foreign_account_count.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_foreign_account_count.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_foreign_account_count.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_foreign_account_count.inserted_at)
      assert found["name"]                                == business_foreign_account_count.name
      assert found["updated_at"]                          == formatting_time(business_foreign_account_count.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessForeignAccountCount"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessForeignAccountCount"]

      assert found["id"]                                  == business_foreign_account_count.id
      assert found["business_tax_returns"]["id"]          == business_foreign_account_count.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_foreign_account_count.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_foreign_account_count.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_foreign_account_count.inserted_at)
      assert found["name"]                                == business_foreign_account_count.name
      assert found["updated_at"]                          == formatting_time(business_foreign_account_count.updated_at)
    end

    it "returns specific BusinessForeignAccountCount by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_foreign_account_count = insert(:pro_business_foreign_account_count, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        showBusinessForeignAccountCount(id: \"#{business_foreign_account_count.id}\") {
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

      {:ok, %{data: %{"showBusinessForeignAccountCount" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_foreign_account_count.id
      assert found["business_tax_returns"]["id"]          == business_foreign_account_count.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_foreign_account_count.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_foreign_account_count.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_foreign_account_count.inserted_at)
      assert found["name"]                                == business_foreign_account_count.name
      assert found["updated_at"]                          == formatting_time(business_foreign_account_count.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessForeignAccountCount"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessForeignAccountCount"]

      assert found["id"]                                  == business_foreign_account_count.id
      assert found["business_tax_returns"]["id"]          == business_foreign_account_count.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_foreign_account_count.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_foreign_account_count.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_foreign_account_count.inserted_at)
      assert found["name"]                                == business_foreign_account_count.name
      assert found["updated_at"]                          == formatting_time(business_foreign_account_count.updated_at)
    end
  end

  describe "#find" do
    it "find specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_foreign_account_count = insert(:tp_business_foreign_account_count, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        findBusinessForeignAccountCount(id: \"#{business_foreign_account_count.id}\") {
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

      {:ok, %{data: %{"findBusinessForeignAccountCount" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_foreign_account_count.id
      assert found["business_tax_returns"]["id"]          == business_foreign_account_count.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_foreign_account_count.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_foreign_account_count.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_foreign_account_count.inserted_at)
      assert found["name"]                                == business_foreign_account_count.name
      assert found["updated_at"]                          == formatting_time(business_foreign_account_count.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessForeignAccountCount"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessForeignAccountCount"]

      assert found["id"]                                  == business_foreign_account_count.id
      assert found["business_tax_returns"]["id"]          == business_foreign_account_count.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_foreign_account_count.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_foreign_account_count.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_foreign_account_count.inserted_at)
      assert found["name"]                                == business_foreign_account_count.name
      assert found["updated_at"]                          == formatting_time(business_foreign_account_count.updated_at)
    end

    it "find specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_foreign_account_count = insert(:pro_business_foreign_account_count, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        findBusinessForeignAccountCount(id: \"#{business_foreign_account_count.id}\") {
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

      {:ok, %{data: %{"findBusinessForeignAccountCount" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_foreign_account_count.id
      assert found["business_tax_returns"]["id"]          == business_foreign_account_count.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_foreign_account_count.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_foreign_account_count.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_foreign_account_count.inserted_at)
      assert found["name"]                                == business_foreign_account_count.name
      assert found["updated_at"]                          == formatting_time(business_foreign_account_count.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessForeignAccountCount"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessForeignAccountCount"]

      assert found["id"]                                  == business_foreign_account_count.id
      assert found["business_tax_returns"]["id"]          == business_foreign_account_count.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_foreign_account_count.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_foreign_account_count.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_foreign_account_count.inserted_at)
      assert found["name"]                                == business_foreign_account_count.name
      assert found["updated_at"]                          == formatting_time(business_foreign_account_count.updated_at)
    end
  end

  describe "#create" do
    it "created BusinessForeignAccountCount by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})

      mutation = """
      {
        createBusinessForeignAccountCount(
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

      created = json_response(res, 200)["data"]["createBusinessForeignAccountCount"]

      assert created["name"]                       == "some name"
      assert created["business_tax_returns"]["id"] == business_tax_return.id
      assert created["inserted_at"]                == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["updated_at"]                 == formatting_time(DateTime.truncate(Timex.now(), :second))
    end

    it "created BusinessForeignAccountCount by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})

      mutation = """
      {
        createBusinessForeignAccountCount(
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

      created = json_response(res, 200)["data"]["createBusinessForeignAccountCount"]

      assert created["business_tax_returns"]["id"] == business_tax_return.id
      assert created["inserted_at"]                == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                       == "some name"
      assert created["updated_at"]                 == formatting_time(DateTime.truncate(Timex.now(), :second))
    end
  end

  describe "#update" do
    it "updated specific BusinessForeignAccountCount by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_foreign_account_count = insert(:business_foreign_account_count, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        updateBusinessForeignAccountCount(
          id: \"#{business_foreign_account_count.id}\",
          business_foreign_account_count: {
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

      updated = json_response(res, 200)["data"]["updateBusinessForeignAccountCount"]

      assert updated["id"]                                  == business_foreign_account_count.id
      assert updated["business_tax_returns"]["id"]          == business_tax_return.id
      assert updated["business_tax_returns"]["inserted_at"] == formatting_time(business_foreign_account_count.business_tax_returns.inserted_at)
      assert updated["business_tax_returns"]["updated_at"]  == formatting_time(business_foreign_account_count.business_tax_returns.updated_at)
      assert updated["inserted_at"]                         == formatting_time(business_foreign_account_count.inserted_at)
      assert updated["name"]                                == "updated some name"
      assert updated["updated_at"]                          == formatting_time(business_foreign_account_count.updated_at)
    end

    it "updated specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_foreign_account_count = insert(:business_foreign_account_count, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        updateBusinessForeignAccountCount(
          id: \"#{business_foreign_account_count.id}\",
          business_foreign_account_count: {
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

      updated = json_response(res, 200)["data"]["updateBusinessForeignAccountCount"]

      assert updated["id"]                                  == business_foreign_account_count.id
      assert updated["business_tax_returns"]["id"]          == business_tax_return.id
      assert updated["business_tax_returns"]["inserted_at"] == formatting_time(business_foreign_account_count.business_tax_returns.inserted_at)
      assert updated["business_tax_returns"]["updated_at"]  == formatting_time(business_foreign_account_count.business_tax_returns.updated_at)
      assert updated["inserted_at"]                         == formatting_time(business_foreign_account_count.inserted_at)
      assert updated["name"]                                == "updated some name"
      assert updated["updated_at"]                          == formatting_time(business_foreign_account_count.updated_at)
    end
  end

  describe "#delete" do
    it "delete specific BusinessForeignAccountCount" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, %{user: user})
      business_foreign_account_count = insert(:business_foreign_account_count, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        deleteBusinessForeignAccountCount(id: \"#{business_foreign_account_count.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteBusinessForeignAccountCount"]
      assert deleted["id"] == business_foreign_account_count.id
    end
  end

  describe "#dataloads" do
    it "created BusinessForeignAccountCount by role's Tp" do
       user = insert(:tp_user)
       %{id: business_tax_return_id} = insert(:tp_business_tax_return, user: user)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:business_foreign_account_counts, source)
        |> Dataloader.load(:business_foreign_account_counts, Core.Services.BusinessTaxReturn, business_tax_return_id)
        |> Dataloader.run

      data = Dataloader.get(loader, :business_foreign_account_counts, Core.Services.BusinessTaxReturn, business_tax_return_id)

      assert data.id == business_tax_return_id
    end
  end

  defp formatting_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

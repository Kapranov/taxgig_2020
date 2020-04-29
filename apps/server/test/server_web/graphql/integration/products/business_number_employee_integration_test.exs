defmodule ServerWeb.GraphQL.Integration.Products.BusinessNumberEmployeeIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns BusinessNumberEmployee by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_number_employee = insert(:tp_business_number_employee, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        allBusinessNumberEmployees {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessNumberEmployees"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessNumberEmployees"]

      assert List.first(data)["id"]                                  == business_number_employee.id
      assert List.first(data)["business_tax_returns"]["id"]          == business_number_employee.business_tax_returns.id
      assert List.first(data)["business_tax_returns"]["inserted_at"] == formatting_time(business_number_employee.business_tax_returns.inserted_at)
      assert List.first(data)["business_tax_returns"]["updated_at"]  == formatting_time(business_number_employee.business_tax_returns.updated_at)
      assert List.first(data)["inserted_at"]                         == formatting_time(business_number_employee.inserted_at)
      assert List.first(data)["name"]                                == business_number_employee.name
      assert List.first(data)["updated_at"]                          == formatting_time(business_number_employee.updated_at)

      {:ok, %{data: %{"allBusinessNumberEmployees" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                  == business_number_employee.id
      assert first["business_tax_returns"]["id"]          == business_number_employee.business_tax_returns.id
      assert first["business_tax_returns"]["inserted_at"] == formatting_time(business_number_employee.business_tax_returns.inserted_at)
      assert first["business_tax_returns"]["updated_at"]  == formatting_time(business_number_employee.business_tax_returns.updated_at)
      assert first["inserted_at"]                         == formatting_time(business_number_employee.inserted_at)
      assert first["name"]                                == business_number_employee.name
      assert first["updated_at"]                          == formatting_time(business_number_employee.updated_at)
    end

    it "returns BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_number_employee = insert(:pro_business_number_employee, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        allBusinessNumberEmployees {
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessNumberEmployees"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessNumberEmployees"]

      assert List.first(data)["id"]                                  == business_number_employee.id
      assert List.first(data)["business_tax_returns"]["id"]          == business_number_employee.business_tax_returns.id
      assert List.first(data)["business_tax_returns"]["inserted_at"] == formatting_time(business_number_employee.business_tax_returns.inserted_at)
      assert List.first(data)["business_tax_returns"]["updated_at"]  == formatting_time(business_number_employee.business_tax_returns.updated_at)
      assert List.first(data)["inserted_at"]                         == formatting_time(business_number_employee.inserted_at)
      assert List.first(data)["name"]                                == business_number_employee.name
      assert List.first(data)["price"]                               == business_number_employee.price
      assert List.first(data)["updated_at"]                          == formatting_time(business_number_employee.updated_at)

      {:ok, %{data: %{"allBusinessNumberEmployees" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                  == business_number_employee.id
      assert first["business_tax_returns"]["id"]          == business_number_employee.business_tax_returns.id
      assert first["business_tax_returns"]["inserted_at"] == formatting_time(business_number_employee.business_tax_returns.inserted_at)
      assert first["business_tax_returns"]["updated_at"]  == formatting_time(business_number_employee.business_tax_returns.updated_at)
      assert first["inserted_at"]                         == formatting_time(business_number_employee.inserted_at)
      assert first["name"]                                == business_number_employee.name
      assert first["price"]                               == business_number_employee.price
      assert first["updated_at"]                          == formatting_time(business_number_employee.updated_at)
    end
  end

  describe "#show" do
    it "returns specific BusinessNumberEmployee by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_number_employee = insert(:tp_business_number_employee, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        showBusinessNumberEmployee(id: \"#{business_number_employee.id}\") {
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

      {:ok, %{data: %{"showBusinessNumberEmployee" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_number_employee.id
      assert found["business_tax_returns"]["id"]          == business_number_employee.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_number_employee.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_number_employee.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_number_employee.inserted_at)
      assert found["name"]                                == business_number_employee.name
      assert found["updated_at"]                          == formatting_time(business_number_employee.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessNumberEmployee"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessNumberEmployee"]

      assert found["id"]                                  == business_number_employee.id
      assert found["business_tax_returns"]["id"]          == business_number_employee.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_number_employee.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_number_employee.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_number_employee.inserted_at)
      assert found["name"]                                == business_number_employee.name
      assert found["updated_at"]                          == formatting_time(business_number_employee.updated_at)
    end

    it "returns specific BusinessNumberEmployee by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_number_employee = insert(:pro_business_number_employee, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        showBusinessNumberEmployee(id: \"#{business_number_employee.id}\") {
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

      {:ok, %{data: %{"showBusinessNumberEmployee" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_number_employee.id
      assert found["business_tax_returns"]["id"]          == business_number_employee.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_number_employee.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_number_employee.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_number_employee.inserted_at)
      assert found["name"]                                == business_number_employee.name
      assert found["price"]                               == business_number_employee.price
      assert found["updated_at"]                          == formatting_time(business_number_employee.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessNumberEmployee"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessNumberEmployee"]

      assert found["id"]                                  == business_number_employee.id
      assert found["business_tax_returns"]["id"]          == business_number_employee.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_number_employee.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_number_employee.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_number_employee.inserted_at)
      assert found["name"]                                == business_number_employee.name
      assert found["price"]                               == business_number_employee.price
      assert found["updated_at"]                          == formatting_time(business_number_employee.updated_at)
    end
  end

  describe "#find" do
    it "find specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_number_employee = insert(:tp_business_number_employee, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        findBusinessNumberEmployee(id: \"#{business_number_employee.id}\") {
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

      {:ok, %{data: %{"findBusinessNumberEmployee" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_number_employee.id
      assert found["business_tax_returns"]["id"]          == business_number_employee.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_number_employee.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_number_employee.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_number_employee.inserted_at)
      assert found["name"]                                == business_number_employee.name
      assert found["updated_at"]                          == formatting_time(business_number_employee.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessNumberEmployee"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessNumberEmployee"]

      assert found["id"]                                  == business_number_employee.id
      assert found["business_tax_returns"]["id"]          == business_number_employee.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_number_employee.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_number_employee.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_number_employee.inserted_at)
      assert found["name"]                                == business_number_employee.name
      assert found["updated_at"]                          == formatting_time(business_number_employee.updated_at)
    end

    it "find specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_number_employee = insert(:pro_business_number_employee, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        findBusinessNumberEmployee(id: \"#{business_number_employee.id}\") {
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

      {:ok, %{data: %{"findBusinessNumberEmployee" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                  == business_number_employee.id
      assert found["business_tax_returns"]["id"]          == business_number_employee.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_number_employee.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_number_employee.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_number_employee.inserted_at)
      assert found["name"]                                == business_number_employee.name
      assert found["price"]                               == business_number_employee.price
      assert found["updated_at"]                          == formatting_time(business_number_employee.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessNumberEmployee"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessNumberEmployee"]

      assert found["id"]                                  == business_number_employee.id
      assert found["business_tax_returns"]["id"]          == business_number_employee.business_tax_returns.id
      assert found["business_tax_returns"]["inserted_at"] == formatting_time(business_number_employee.business_tax_returns.inserted_at)
      assert found["business_tax_returns"]["updated_at"]  == formatting_time(business_number_employee.business_tax_returns.updated_at)
      assert found["inserted_at"]                         == formatting_time(business_number_employee.inserted_at)
      assert found["name"]                                == business_number_employee.name
      assert found["price"]                               == business_number_employee.price
      assert found["updated_at"]                          == formatting_time(business_number_employee.updated_at)
    end
  end

  describe "#create" do
    it "created BusinessNumberEmployee by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})

      mutation = """
      {
        createBusinessNumberEmployee(
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

      created = json_response(res, 200)["data"]["createBusinessNumberEmployee"]

      assert created["business_tax_returns"]["id"] == business_tax_return.id
      assert created["inserted_at"]                == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                       == "some name"
      assert created["updated_at"]                 == formatting_time(DateTime.truncate(Timex.now(), :second))
    end

    it "created BusinessNumberEmployee by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})

      mutation = """
      {
        createBusinessNumberEmployee(
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

      created = json_response(res, 200)["data"]["createBusinessNumberEmployee"]

      assert created["business_tax_returns"]["id"] == business_tax_return.id
      assert created["inserted_at"]                == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]                       == "some name"
      assert created["price"]                      == 12
      assert created["updated_at"]                 == formatting_time(DateTime.truncate(Timex.now(), :second))
    end
  end

  describe "#update" do
    it "updated specific BusinessNumberEmployee by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      business_number_employee = insert(:business_number_employee, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        updateBusinessNumberEmployee(
          id: \"#{business_number_employee.id}\",
          business_number_employee: {
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

      updated = json_response(res, 200)["data"]["updateBusinessNumberEmployee"]

      assert updated["id"]                                  == business_number_employee.id
      assert updated["business_tax_returns"]["id"]          == business_tax_return.id
      assert updated["business_tax_returns"]["inserted_at"] == formatting_time(business_number_employee.business_tax_returns.inserted_at)
      assert updated["business_tax_returns"]["updated_at"]  == formatting_time(business_number_employee.business_tax_returns.updated_at)
      assert updated["inserted_at"]                         == formatting_time(business_number_employee.inserted_at)
      assert updated["name"]                                == "updated some name"
      assert updated["updated_at"]                          == formatting_time(business_number_employee.updated_at)
    end

    it "updated specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      business_number_employee = insert(:business_number_employee, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        updateBusinessNumberEmployee(
          id: \"#{business_number_employee.id}\",
          business_number_employee: {
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

      updated = json_response(res, 200)["data"]["updateBusinessNumberEmployee"]

      assert updated["id"]                                  == business_number_employee.id
      assert updated["business_tax_returns"]["id"]          == business_tax_return.id
      assert updated["business_tax_returns"]["inserted_at"] == formatting_time(business_number_employee.business_tax_returns.inserted_at)
      assert updated["business_tax_returns"]["updated_at"]  == formatting_time(business_number_employee.business_tax_returns.updated_at)
      assert updated["inserted_at"]                         == formatting_time(business_number_employee.inserted_at)
      assert updated["name"]                                == "updated some name"
      assert updated["price"]                               == 13
    end
  end

  describe "#delete" do
    it "delete specific BusinessNumberEmployee" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, %{user: user})
      business_number_employee = insert(:business_number_employee, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        deleteBusinessNumberEmployee(id: \"#{business_number_employee.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteBusinessNumberEmployee"]
      assert deleted["id"] == business_number_employee.id
    end
  end

  describe "#dataloads" do
    it "created BusinessNumberEmployee by role's Tp" do
       user = insert(:tp_user)
       %{id: business_tax_return_id} = insert(:tp_business_tax_return, user: user)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:business_number_employees, source)
        |> Dataloader.load(:business_number_employees, Core.Services.BusinessTaxReturn, business_tax_return_id)
        |> Dataloader.run

      data = Dataloader.get(loader, :business_number_employees, Core.Services.BusinessTaxReturn, business_tax_return_id)

      assert data.id == business_tax_return_id
    end
  end

  defp formatting_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

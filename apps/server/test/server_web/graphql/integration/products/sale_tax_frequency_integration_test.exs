defmodule ServerWeb.GraphQL.Integration.Products.SaleTaxFrequencyIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns SaleTaxFrequency by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      struct = insert(:tp_sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        allSaleTaxFrequencies {
          id
          name
          price
          sale_taxes {
            id
            deadline
            financial_situation
            sale_tax_count
            state
            sale_tax_frequencies { id }
            sale_tax_industries { id }
            user { id email role}
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allSaleTaxFrequencies"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allSaleTaxFrequencies"]

      assert List.first(data)["id"]                                 == struct.id
      assert List.first(data)["name"]                               == format_field(struct.name)
      assert List.first(data)["price"]                              == nil
      assert List.first(data)["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert List.first(data)["sale_taxes"]["deadline"]             == format_deadline(struct.sale_taxes.deadline)
      assert List.first(data)["sale_taxes"]["financial_situation"]  == struct.sale_taxes.financial_situation
      assert List.first(data)["sale_taxes"]["sale_tax_count"]       == struct.sale_taxes.sale_tax_count
      assert List.first(data)["sale_taxes"]["state"]                == struct.sale_taxes.state
      assert List.first(data)["sale_taxes"]["user"]["id"]           == user.id
      assert List.first(data)["sale_taxes"]["user"]["email"]        == user.email
      assert List.first(data)["sale_taxes"]["user"]["role"]         == user.role

      {:ok, %{data: %{"allSaleTaxFrequencies" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                 == struct.id
      assert first["name"]                               == format_field(struct.name)
      assert first["price"]                              == nil
      assert first["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert first["sale_taxes"]["deadline"]             == format_deadline(struct.sale_taxes.deadline)
      assert first["sale_taxes"]["financial_situation"]  == struct.sale_taxes.financial_situation
      assert first["sale_taxes"]["sale_tax_count"]       == struct.sale_taxes.sale_tax_count
      assert first["sale_taxes"]["state"]                == struct.sale_taxes.state
      assert first["sale_taxes"]["user"]["id"]           == user.id
      assert first["sale_taxes"]["user"]["email"]        == user.email
      assert first["sale_taxes"]["user"]["role"]         == user.role
    end

    it "returns SaleTaxFrequency by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      struct = insert(:pro_sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        allSaleTaxFrequencies {
          id
          name
          price
          sale_taxes {
            id
            price_sale_tax_count
            sale_tax_frequencies { id }
            sale_tax_industries { id }
            user { id email role}
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allSaleTaxFrequencies"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allSaleTaxFrequencies"]

      assert List.first(data)["id"]                                 == struct.id
      assert List.first(data)["name"]                               == format_field(struct.name)
      assert List.first(data)["price"]                              == struct.price
      assert List.first(data)["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert List.first(data)["sale_taxes"]["price_sale_tax_count"] == struct.sale_taxes.price_sale_tax_count
      assert List.first(data)["sale_taxes"]["user"]["id"]           == user.id
      assert List.first(data)["sale_taxes"]["user"]["email"]        == user.email
      assert List.first(data)["sale_taxes"]["user"]["role"]         == user.role

      {:ok, %{data: %{"allSaleTaxFrequencies" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                 == struct.id
      assert first["name"]                               == format_field(struct.name)
      assert first["price"]                              == struct.price
      assert first["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert first["sale_taxes"]["price_sale_tax_count"] == struct.sale_taxes.price_sale_tax_count
      assert first["sale_taxes"]["user"]["id"]           == user.id
      assert first["sale_taxes"]["user"]["email"]        == user.email
      assert first["sale_taxes"]["user"]["role"]         == user.role
    end
  end

  describe "#show" do
    it "returns specific SaleTaxFrequency by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      struct = insert(:tp_sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        showSaleTaxFrequency(id: \"#{struct.id}\") {
          id
          name
          price
          sale_taxes {
            id
            deadline
            financial_situation
            sale_tax_count
            state
            sale_tax_frequencies { id }
            sale_tax_industries { id }
            user { id email role}
          }
        }
      }
      """

      {:ok, %{data: %{"showSaleTaxFrequency" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                 == struct.id
      assert found["name"]                               == format_field(struct.name)
      assert found["price"]                              == struct.price
      assert found["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert found["sale_taxes"]["deadline"]             == format_deadline(struct.sale_taxes.deadline)
      assert found["sale_taxes"]["financial_situation"]  == struct.sale_taxes.financial_situation
      assert found["sale_taxes"]["sale_tax_count"]       == struct.sale_taxes.sale_tax_count
      assert found["sale_taxes"]["state"]                == struct.sale_taxes.state
      assert found["sale_taxes"]["user"]["id"]           == user.id
      assert found["sale_taxes"]["user"]["email"]        == user.email
      assert found["sale_taxes"]["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showSaleTaxFrequency"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showSaleTaxFrequency"]

      assert found["id"]                                 == struct.id
      assert found["name"]                               == format_field(struct.name)
      assert found["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert found["sale_taxes"]["deadline"]             == format_deadline(struct.sale_taxes.deadline)
      assert found["sale_taxes"]["financial_situation"]  == struct.sale_taxes.financial_situation
      assert found["sale_taxes"]["sale_tax_count"]       == struct.sale_taxes.sale_tax_count
      assert found["sale_taxes"]["state"]                == struct.sale_taxes.state
      assert found["sale_taxes"]["user"]["id"]           == user.id
      assert found["sale_taxes"]["user"]["email"]        == user.email
      assert found["sale_taxes"]["user"]["role"]         == user.role
    end

    it "returns specific BookKeepingTypeClient by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      struct = insert(:pro_sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        showSaleTaxFrequency(id: \"#{struct.id}\") {
          id
          name
          price
          sale_taxes {
            id
            price_sale_tax_count
            sale_tax_frequencies { id }
            sale_tax_industries { id }
            user { id email role}
          }
        }
      }
      """

      {:ok, %{data: %{"showSaleTaxFrequency" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                 == struct.id
      assert found["name"]                               == format_field(struct.name)
      assert found["price"]                              == struct.price
      assert found["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert found["sale_taxes"]["price_sale_tax_count"] == struct.sale_taxes.price_sale_tax_count
      assert found["sale_taxes"]["user"]["id"]           == user.id
      assert found["sale_taxes"]["user"]["email"]        == user.email
      assert found["sale_taxes"]["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showSaleTaxFrequency"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showSaleTaxFrequency"]

      assert found["id"]                                 == struct.id
      assert found["name"]                               == format_field(struct.name)
      assert found["price"]                              == struct.price
      assert found["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert found["sale_taxes"]["price_sale_tax_count"] == struct.sale_taxes.price_sale_tax_count
      assert found["sale_taxes"]["user"]["id"]           == user.id
      assert found["sale_taxes"]["user"]["email"]        == user.email
      assert found["sale_taxes"]["user"]["role"]         == user.role
    end
  end

  describe "#find" do
    it "find specific SaleTaxFrequency by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      struct = insert(:tp_sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        findSaleTaxFrequency(id: \"#{struct.id}\") {
          id
          name
          price
          sale_taxes {
            id
            deadline
            financial_situation
            sale_tax_count
            state
            sale_tax_frequencies { id }
            sale_tax_industries { id }
            user { id email role}
          }
        }
      }
      """

      {:ok, %{data: %{"findSaleTaxFrequency" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                 == struct.id
      assert found["name"]                               == format_field(struct.name)
      assert found["price"]                              == nil
      assert found["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert found["sale_taxes"]["deadline"]             == format_deadline(struct.sale_taxes.deadline)
      assert found["sale_taxes"]["financial_situation"]  == struct.sale_taxes.financial_situation
      assert found["sale_taxes"]["sale_tax_count"]       == struct.sale_taxes.sale_tax_count
      assert found["sale_taxes"]["state"]                == struct.sale_taxes.state
      assert found["sale_taxes"]["user"]["id"]           == user.id
      assert found["sale_taxes"]["user"]["email"]        == user.email
      assert found["sale_taxes"]["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findSaleTaxFrequency"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findSaleTaxFrequency"]

      assert found["id"]                                 == struct.id
      assert found["name"]                               == format_field(struct.name)
      assert found["price"]                              == nil
      assert found["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert found["sale_taxes"]["deadline"]             == format_deadline(struct.sale_taxes.deadline)
      assert found["sale_taxes"]["financial_situation"]  == struct.sale_taxes.financial_situation
      assert found["sale_taxes"]["sale_tax_count"]       == struct.sale_taxes.sale_tax_count
      assert found["sale_taxes"]["state"]                == struct.sale_taxes.state
      assert found["sale_taxes"]["user"]["id"]           == user.id
      assert found["sale_taxes"]["user"]["email"]        == user.email
      assert found["sale_taxes"]["user"]["role"]         == user.role
    end

    it "find specific SaleTaxFrequency by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      struct = insert(:pro_sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        findSaleTaxFrequency(id: \"#{struct.id}\") {
          id
          name
          price
          sale_taxes {
            id
            price_sale_tax_count
            sale_tax_frequencies { id }
            sale_tax_industries { id }
            user { id email role}
          }
        }
      }
      """

      {:ok, %{data: %{"findSaleTaxFrequency" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                 == struct.id
      assert found["name"]                               == format_field(struct.name)
      assert found["price"]                              == struct.price
      assert found["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert found["sale_taxes"]["price_sale_tax_count"] == struct.sale_taxes.price_sale_tax_count
      assert found["sale_taxes"]["user"]["id"]           == user.id
      assert found["sale_taxes"]["user"]["email"]        == user.email
      assert found["sale_taxes"]["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findSaleTaxFrequency"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findSaleTaxFrequency"]

      assert found["id"]                                 == struct.id
      assert found["name"]                               == format_field(struct.name)
      assert found["price"]                              == struct.price
      assert found["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert found["sale_taxes"]["price_sale_tax_count"] == struct.sale_taxes.price_sale_tax_count
      assert found["sale_taxes"]["user"]["id"]           == user.id
      assert found["sale_taxes"]["user"]["email"]        == user.email
      assert found["sale_taxes"]["user"]["role"]         == user.role
    end
  end

  describe "#create" do
    it "created SaleTaxFrequency by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})

      mutation = """
      {
        createSaleTaxFrequency(
          name: "Annually",
          sale_taxId: \"#{sale_tax.id}\"
        ) {
          id
          name
          price
          sale_taxes {
            id
            deadline
            financial_situation
            sale_tax_count
            state
            sale_tax_frequencies { id }
            sale_tax_industries { id }
            user { id email role}
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createSaleTaxFrequency"]

      assert created["sale_taxes"]["id"] == sale_tax.id
      assert created["name"]             == "Annually"
      assert created["price"]            == nil
    end

    it "created SaleTaxFrequency by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})

      mutation = """
      {
        createSaleTaxFrequency(
          name: "Annually",
          price: 22,
          sale_taxId: \"#{sale_tax.id}\"
        ) {
          id
          name
          price
          sale_taxes {
            id
            price_sale_tax_count
            sale_tax_frequencies { id }
            sale_tax_industries { id }
            user { id email role}
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createSaleTaxFrequency"]

      assert created["sale_taxes"]["id"] == sale_tax.id
      assert created["name"]             == "Annually"
      assert created["price"]            == 22
    end
  end

  describe "#update" do
    it "updated specific SaleTaxFrequency by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      struct = insert(:tp_sale_tax_frequency, %{name: "Annually", sale_taxes: sale_tax})

      mutation = """
      {
        updateSaleTaxFrequency(
          id: \"#{struct.id}\",
          sale_tax_frequency: {
            name: "Quarterly",
            sale_taxId: \"#{sale_tax.id}\"
          }
        )
        {
          id
          name
          price
          sale_taxes {
            id
            deadline
            financial_situation
            sale_tax_count
            state
            sale_tax_frequencies { id }
            sale_tax_industries { id }
            user { id email role}
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateSaleTaxFrequency"]

      assert updated["sale_taxes"]["id"] == struct.sale_tax_id
      assert updated["id"]               == struct.id
      assert updated["name"]             == "Quarterly"
      assert updated["price"]            == nil
    end

    it "updated specific SaleTaxFrequency by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      struct = insert(:pro_sale_tax_frequency, %{name: "Annually", sale_taxes: sale_tax})

      mutation = """
      {
        updateSaleTaxFrequency(
          id: \"#{struct.id}\",
          sale_tax_frequency: {
            name: "Quarterly",
            price: 33,
            sale_taxId: \"#{sale_tax.id}\"
          }
        )
        {
          id
          name
          price
          sale_taxes {
            id
            price_sale_tax_count
            sale_tax_frequencies { id }
            sale_tax_industries { id }
            user { id email role}
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateSaleTaxFrequency"]

      assert updated["sale_taxes"]["id"] == struct.sale_tax_id
      assert updated["id"]               == struct.id
      assert updated["name"]             == "Quarterly"
      assert updated["price"]            == 33
    end
  end

  describe "#delete" do
    it "delete specific SaleTaxFrequency" do
      user = insert(:user)
      sale_tax = insert(:sale_tax, %{user: user})
      struct = insert(:sale_tax_frequency, %{sale_taxes: sale_tax})

      mutation = """
      {
        deleteSaleTaxFrequency(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteSaleTaxFrequency"]
      assert deleted["id"] == struct.id
    end
  end

  describe "#dataloads" do
    it "created SaleTaxFrequency" do
      user = insert(:user)
      sale_tax = insert(:sale_tax, %{user: user})
      %{id: id} = insert(:sale_tax_frequency, %{sale_taxes: sale_tax})

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:sale_tax_frequencies, source)
        |> Dataloader.load(:sale_tax_frequencies, Core.Services.SaleTaxFrequency, id)
        |> Dataloader.run

      data = Dataloader.get(loader, :sale_tax_frequencies, Core.Services.SaleTaxFrequency, id)

      assert data.id == id
    end
  end

  @spec format_field(atom()) :: String.t()
  defp format_field(data), do: to_string(data)

  @spec format_field(Date.t()) :: String.t()
  defp format_deadline(data), do: to_string(data)
end

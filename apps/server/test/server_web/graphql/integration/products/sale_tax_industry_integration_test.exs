defmodule ServerWeb.GraphQL.Integration.Products.SaleTaxIndustryIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns SaleTaxIndustry by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      struct = insert(:tp_sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        allSaleTaxIndustries {
          id
          name
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allSaleTaxIndustries"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allSaleTaxIndustries"]

      assert List.first(data)["id"]                                 == struct.id
      assert List.first(data)["name"]                               == format_field(struct.name)
      assert List.first(data)["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert List.first(data)["sale_taxes"]["deadline"]             == format_deadline(struct.sale_taxes.deadline)
      assert List.first(data)["sale_taxes"]["financial_situation"]  == struct.sale_taxes.financial_situation
      assert List.first(data)["sale_taxes"]["sale_tax_count"]       == struct.sale_taxes.sale_tax_count
      assert List.first(data)["sale_taxes"]["state"]                == struct.sale_taxes.state
      assert List.first(data)["sale_taxes"]["user"]["id"]           == user.id
      assert List.first(data)["sale_taxes"]["user"]["email"]        == user.email
      assert List.first(data)["sale_taxes"]["user"]["role"]         == user.role

      {:ok, %{data: %{"allSaleTaxIndustries" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                 == struct.id
      assert first["name"]                               == format_field(struct.name)
      assert first["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert first["sale_taxes"]["deadline"]             == format_deadline(struct.sale_taxes.deadline)
      assert first["sale_taxes"]["financial_situation"]  == struct.sale_taxes.financial_situation
      assert first["sale_taxes"]["sale_tax_count"]       == struct.sale_taxes.sale_tax_count
      assert first["sale_taxes"]["state"]                == struct.sale_taxes.state
      assert first["sale_taxes"]["user"]["id"]           == user.id
      assert first["sale_taxes"]["user"]["email"]        == user.email
      assert first["sale_taxes"]["user"]["role"]         == user.role
    end

    it "returns BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      struct = insert(:pro_sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        allSaleTaxIndustries {
          id
          name
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allSaleTaxIndustries"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allSaleTaxIndustries"]

      assert List.first(data)["id"]                                 == struct.id
      assert List.first(data)["name"]                               == format_field(struct.name)
      assert List.first(data)["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert List.first(data)["sale_taxes"]["price_sale_tax_count"] == struct.sale_taxes.price_sale_tax_count
      assert List.first(data)["sale_taxes"]["user"]["id"]           == user.id
      assert List.first(data)["sale_taxes"]["user"]["email"]        == user.email
      assert List.first(data)["sale_taxes"]["user"]["role"]         == user.role

      {:ok, %{data: %{"allSaleTaxIndustries" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                 == struct.id
      assert first["name"]                               == format_field(struct.name)
      assert first["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert first["sale_taxes"]["price_sale_tax_count"] == struct.sale_taxes.price_sale_tax_count
      assert first["sale_taxes"]["user"]["id"]           == user.id
      assert first["sale_taxes"]["user"]["email"]        == user.email
      assert first["sale_taxes"]["user"]["role"]         == user.role
    end
  end

  describe "#show" do
    it "returns specific SaleTaxIndustry by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      struct = insert(:tp_sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        showSaleTaxIndustry(id: \"#{struct.id}\") {
          id
          name
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

      {:ok, %{data: %{"showSaleTaxIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

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

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showSaleTaxIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showSaleTaxIndustry"]

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

    it "returns specific SaleTaxIndustry by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      struct = insert(:pro_sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        showSaleTaxIndustry(id: \"#{struct.id}\") {
          id
          name
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

      {:ok, %{data: %{"showSaleTaxIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                 == struct.id
      assert found["name"]                               == format_field(struct.name)
      assert found["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert found["sale_taxes"]["price_sale_tax_count"] == struct.sale_taxes.price_sale_tax_count
      assert found["sale_taxes"]["user"]["id"]           == user.id
      assert found["sale_taxes"]["user"]["email"]        == user.email
      assert found["sale_taxes"]["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showSaleTaxIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showSaleTaxIndustry"]

      assert found["id"]                                 == struct.id
      assert found["name"]                               == format_field(struct.name)
      assert found["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert found["sale_taxes"]["price_sale_tax_count"] == struct.sale_taxes.price_sale_tax_count
      assert found["sale_taxes"]["user"]["id"]           == user.id
      assert found["sale_taxes"]["user"]["email"]        == user.email
      assert found["sale_taxes"]["user"]["role"]         == user.role
    end
  end

  describe "#find" do
    it "find specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      struct = insert(:tp_sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        findSaleTaxIndustry(id: \"#{struct.id}\") {
          id
          name
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

      {:ok, %{data: %{"findSaleTaxIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

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

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findSaleTaxIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findSaleTaxIndustry"]

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

    it "find specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      struct = insert(:pro_sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        findSaleTaxIndustry(id: \"#{struct.id}\") {
          id
          name
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

      {:ok, %{data: %{"findSaleTaxIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                 == struct.id
      assert found["name"]                               == format_field(struct.name)
      assert found["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert found["sale_taxes"]["price_sale_tax_count"] == struct.sale_taxes.price_sale_tax_count
      assert found["sale_taxes"]["user"]["id"]           == user.id
      assert found["sale_taxes"]["user"]["email"]        == user.email
      assert found["sale_taxes"]["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findSaleTaxIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findSaleTaxIndustry"]

      assert found["id"]                                 == struct.id
      assert found["name"]                               == format_field(struct.name)
      assert found["sale_taxes"]["id"]                   == struct.sale_taxes.id
      assert found["sale_taxes"]["price_sale_tax_count"] == struct.sale_taxes.price_sale_tax_count
      assert found["sale_taxes"]["user"]["id"]           == user.id
      assert found["sale_taxes"]["user"]["email"]        == user.email
      assert found["sale_taxes"]["user"]["role"]         == user.role
    end
  end

  describe "#create" do
    it "created SaleTaxIndustry by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})

      mutation = """
      {
        createSaleTaxIndustry(
          name: ["Agriculture/Farming"],
          sale_taxId: \"#{sale_tax.id}\"
        ) {
          id
          name
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

      created = json_response(res, 200)["data"]["createSaleTaxIndustry"]

      assert created["sale_taxes"]["id"] == sale_tax.id
      assert created["name"]             == ["Agriculture/Farming"]
    end

    it "created SaleTaxIndustry by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})

      mutation = """
      {
        createSaleTaxIndustry(
          name: ["Agriculture/Farming", "Automotive Sales/Repair"],
          sale_taxId: \"#{sale_tax.id}\"
        ) {
          id
          name
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

      created = json_response(res, 200)["data"]["createSaleTaxIndustry"]

      assert created["sale_taxes"]["id"] == sale_tax.id
      assert created["name"]             == ["Agriculture/Farming", "Automotive Sales/Repair"]
    end
  end

  describe "#update" do
    it "updated specific SaleTaxIndustry by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      struct = insert(:sale_tax_industry, %{name: ["Agriculture/Farming"], sale_taxes: sale_tax})

      mutation = """
      {
        updateSaleTaxIndustry(
          id: \"#{struct.id}\",
          sale_tax_industry: {
            name: ["Wholesale Distribution"]
          }
        )
        {
          id
          name
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

      updated = json_response(res, 200)["data"]["updateSaleTaxIndustry"]

      assert updated["id"]               == struct.id
      assert updated["sale_taxes"]["id"] == struct.sale_tax_id
      assert updated["name"]             == ["Wholesale Distribution"]
    end

    it "updated specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      struct = insert(:sale_tax_industry, %{name: ["Agriculture/Farming", "Automotive Sales/Repair"], sale_taxes: sale_tax})

      mutation = """
      {
        updateSaleTaxIndustry(
          id: \"#{struct.id}\",
          sale_tax_industry: {
            name: ["Transportation", "Wholesale Distribution"]
          }
        )
        {
          id
          name
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

      updated = json_response(res, 200)["data"]["updateSaleTaxIndustry"]

      assert updated["id"]               == struct.id
      assert updated["sale_taxes"]["id"] == struct.sale_tax_id
      assert updated["name"]             == ["Transportation", "Wholesale Distribution"]
    end
  end

  describe "#delete" do
    it "delete specific SaleTaxIndustry" do
      user = insert(:user)
      sale_tax = insert(:sale_tax, %{user: user})
      struct = insert(:sale_tax_industry, %{sale_taxes: sale_tax})

      mutation = """
      {
        deleteSaleTaxIndustry(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteSaleTaxIndustry"]
      assert deleted["id"] == struct.id
    end
  end

  describe "#dataloads" do
    it "created SaleTaxIndustry" do
      user = insert(:user)
      sale_tax = insert(:sale_tax, %{user: user})
      %{id: id} = insert(:sale_tax_industry, %{sale_taxes: sale_tax})

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:sale_tax_industries, source)
        |> Dataloader.load(:sale_tax_industries, Core.Services.SaleTaxIndustry, id)
        |> Dataloader.run

      data = Dataloader.get(loader, :sale_tax_industries, Core.Services.SaleTaxIndustry, id)

      assert data.id == id
    end
  end

  @spec format_field([atom()]) :: [String.t()]
  defp format_field(data) do
    Enum.reduce(data, [], fn(x, acc) ->
      [to_string(x) | acc]
    end) |> Enum.sort()
  end

  @spec format_field(Date.t()) :: String.t()
  defp format_deadline(data), do: to_string(data)
end

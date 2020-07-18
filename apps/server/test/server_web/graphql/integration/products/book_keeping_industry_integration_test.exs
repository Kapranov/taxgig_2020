defmodule ServerWeb.GraphQL.Integration.Products.BookKeepingIndustryIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns BookKeepingIndustry by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:tp_book_keeping_industry, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        allBookKeepingIndustries {
          id
          name
          book_keepings {
            id
            account_count
            balance_sheet
            financial_situation
            inventory
            inventory_count
            payroll
            tax_return_current
            tax_year
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
            user { id email role}
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBookKeepingIndustries"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBookKeepingIndustries"]

      assert List.first(data)["id"]                                    == struct.id
      assert List.first(data)["name"]                                  == format_field(struct.name)
      assert List.first(data)["book_keepings"]["id"]                   == struct.book_keepings.id
      assert List.first(data)["book_keepings"]["account_count"]        == struct.book_keepings.account_count
      assert List.first(data)["book_keepings"]["balance_sheet"]        == struct.book_keepings.balance_sheet
      assert List.first(data)["book_keepings"]["financial_situation"]  == struct.book_keepings.financial_situation
      assert List.first(data)["book_keepings"]["inventory"]            == struct.book_keepings.inventory
      assert List.first(data)["book_keepings"]["inventory_count"]      == struct.book_keepings.inventory_count
      assert List.first(data)["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert List.first(data)["book_keepings"]["tax_return_current"]   == struct.book_keepings.tax_return_current
      assert List.first(data)["book_keepings"]["tax_year"]             == struct.book_keepings.tax_year
      assert List.first(data)["book_keepings"]["user"]["id"]           == user.id
      assert List.first(data)["book_keepings"]["user"]["email"]        == user.email
      assert List.first(data)["book_keepings"]["user"]["role"]         == user.role

      {:ok, %{data: %{"allBookKeepingIndustries" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == struct.id
      assert first["name"]                                  == format_field(struct.name)
      assert first["book_keepings"]["id"]                   == struct.book_keepings.id
      assert first["book_keepings"]["account_count"]        == struct.book_keepings.account_count
      assert first["book_keepings"]["balance_sheet"]        == struct.book_keepings.balance_sheet
      assert first["book_keepings"]["financial_situation"]  == struct.book_keepings.financial_situation
      assert first["book_keepings"]["inventory"]            == struct.book_keepings.inventory
      assert first["book_keepings"]["inventory_count"]      == struct.book_keepings.inventory_count
      assert first["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert first["book_keepings"]["tax_return_current"]   == struct.book_keepings.tax_return_current
      assert first["book_keepings"]["tax_year"]             == struct.book_keepings.tax_year
      assert first["book_keepings"]["user"]["id"]           == user.id
      assert first["book_keepings"]["user"]["email"]        == user.email
      assert first["book_keepings"]["user"]["role"]         == user.role
    end

    it "returns BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:pro_book_keeping_industry, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        allBookKeepingIndustries {
          id
          name
          book_keepings {
            id
            payroll
            price_payroll
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
            user { id email role}
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBookKeepingIndustries"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBookKeepingIndustries"]

      assert List.first(data)["id"]                                    == struct.id
      assert List.first(data)["name"]                                  == format_field(struct.name)
      assert List.first(data)["book_keepings"]["id"]                   == struct.book_keepings.id
      assert List.first(data)["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert List.first(data)["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert List.first(data)["book_keepings"]["user"]["id"]           == user.id
      assert List.first(data)["book_keepings"]["user"]["email"]        == user.email
      assert List.first(data)["book_keepings"]["user"]["role"]         == user.role

      {:ok, %{data: %{"allBookKeepingIndustries" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == struct.id
      assert first["name"]                                  == format_field(struct.name)
      assert first["book_keepings"]["id"]                   == struct.book_keepings.id
      assert first["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert first["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert first["book_keepings"]["user"]["id"]           == user.id
      assert first["book_keepings"]["user"]["email"]        == user.email
      assert first["book_keepings"]["user"]["role"]         == user.role
    end
  end

  describe "#show" do
    it "returns specific BookKeepingIndustry by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:tp_book_keeping_industry, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        showBookKeepingIndustry(id: \"#{struct.id}\") {
          id
          name
          book_keepings {
            id
            account_count
            balance_sheet
            financial_situation
            inventory
            inventory_count
            payroll
            tax_return_current
            tax_year
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
            user { id email role}
          }
        }
      }
      """

      {:ok, %{data: %{"showBookKeepingIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["account_count"]        == struct.book_keepings.account_count
      assert found["book_keepings"]["balance_sheet"]        == struct.book_keepings.balance_sheet
      assert found["book_keepings"]["financial_situation"]  == struct.book_keepings.financial_situation
      assert found["book_keepings"]["inventory"]            == struct.book_keepings.inventory
      assert found["book_keepings"]["inventory_count"]      == struct.book_keepings.inventory_count
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["tax_return_current"]   == struct.book_keepings.tax_return_current
      assert found["book_keepings"]["tax_year"]             == struct.book_keepings.tax_year
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBookKeepingIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBookKeepingIndustry"]

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["account_count"]        == struct.book_keepings.account_count
      assert found["book_keepings"]["balance_sheet"]        == struct.book_keepings.balance_sheet
      assert found["book_keepings"]["financial_situation"]  == struct.book_keepings.financial_situation
      assert found["book_keepings"]["inventory"]            == struct.book_keepings.inventory
      assert found["book_keepings"]["inventory_count"]      == struct.book_keepings.inventory_count
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["tax_return_current"]   == struct.book_keepings.tax_return_current
      assert found["book_keepings"]["tax_year"]             == struct.book_keepings.tax_year
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role
    end

    it "returns specific BookKeepingIndustry by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:pro_book_keeping_industry, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        showBookKeepingIndustry(id: \"#{struct.id}\") {
          id
          name
          book_keepings {
            id
            payroll
            price_payroll
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
            user { id email role}
          }
        }
      }
      """

      {:ok, %{data: %{"showBookKeepingIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBookKeepingIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBookKeepingIndustry"]

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role
    end
  end

  describe "#find" do
    it "find specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:tp_book_keeping_industry, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        findBookKeepingIndustry(id: \"#{struct.id}\") {
          id
          name
          book_keepings {
            id
            account_count
            balance_sheet
            financial_situation
            inventory
            inventory_count
            payroll
            tax_return_current
            tax_year
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
            user { id email role}
          }
        }
      }
      """

      {:ok, %{data: %{"findBookKeepingIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["account_count"]        == struct.book_keepings.account_count
      assert found["book_keepings"]["balance_sheet"]        == struct.book_keepings.balance_sheet
      assert found["book_keepings"]["financial_situation"]  == struct.book_keepings.financial_situation
      assert found["book_keepings"]["inventory"]            == struct.book_keepings.inventory
      assert found["book_keepings"]["inventory_count"]      == struct.book_keepings.inventory_count
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["tax_return_current"]   == struct.book_keepings.tax_return_current
      assert found["book_keepings"]["tax_year"]             == struct.book_keepings.tax_year
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBookKeepingIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBookKeepingIndustry"]

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["account_count"]        == struct.book_keepings.account_count
      assert found["book_keepings"]["balance_sheet"]        == struct.book_keepings.balance_sheet
      assert found["book_keepings"]["financial_situation"]  == struct.book_keepings.financial_situation
      assert found["book_keepings"]["inventory"]            == struct.book_keepings.inventory
      assert found["book_keepings"]["inventory_count"]      == struct.book_keepings.inventory_count
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["tax_return_current"]   == struct.book_keepings.tax_return_current
      assert found["book_keepings"]["tax_year"]             == struct.book_keepings.tax_year
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role
    end

    it "find specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:pro_book_keeping_industry, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        findBookKeepingIndustry(id: \"#{struct.id}\") {
          id
          name
          book_keepings {
            id
            payroll
            price_payroll
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
            user { id email role}
          }
        }
      }
      """

      {:ok, %{data: %{"findBookKeepingIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBookKeepingIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBookKeepingIndustry"]

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role
    end
  end

  describe "#create" do
    it "created BookKeepingIndustry by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})

      mutation = """
      {
        createBookKeepingIndustry(
          name: ["Agriculture/Farming"],
          book_keepingId: \"#{book_keeping.id}\"
        ) {
          id
          name
          book_keepings {
            id
            account_count
            balance_sheet
            financial_situation
            inventory
            inventory_count
            payroll
            tax_return_current
            tax_year
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
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

      created = json_response(res, 200)["data"]["createBookKeepingIndustry"]

      assert created["book_keepings"]["id"] == book_keeping.id
      assert created["name"]                == ["Agriculture/Farming"]
    end

    it "created BookKeepingIndustry by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})

      mutation = """
      {
        createBookKeepingIndustry(
          name: ["Agriculture/Farming", "Automotive Sales/Repair"],
          book_keepingId: \"#{book_keeping.id}\"
        ) {
          id
          name
          book_keepings {
            id
            payroll
            price_payroll
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
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

      created = json_response(res, 200)["data"]["createBookKeepingIndustry"]

      assert created["book_keepings"]["id"] == book_keeping.id
      assert created["name"]                == ["Agriculture/Farming", "Automotive Sales/Repair"]
    end
  end

  describe "#update" do
    it "updated specific BookKeepingIndustry by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:book_keeping_industry, %{name: ["Agriculture/Farming"], book_keepings: book_keeping})

      mutation = """
      {
        updateBookKeepingIndustry(
          id: \"#{struct.id}\",
          book_keeping_industry: {
            name: ["Wholesale Distribution"],
            book_keepingId: \"#{book_keeping.id}\"
          }
        )
        {
          id
          name
          book_keepings {
            id
            account_count
            balance_sheet
            financial_situation
            inventory
            inventory_count
            payroll
            tax_return_current
            tax_year
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
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

      updated = json_response(res, 200)["data"]["updateBookKeepingIndustry"]

      assert updated["id"]                           == struct.id
      assert updated["book_keepings"]["id"]          == struct.book_keeping_id
      assert updated["name"]                         == ["Wholesale Distribution"]
    end

    it "updated specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:book_keeping_industry, %{name: ["Agriculture/Farming", "Automotive Sales/Repair"], book_keepings: book_keeping})

      mutation = """
      {
        updateBookKeepingIndustry(
          id: \"#{struct.id}\",
          book_keeping_industry: {
            book_keepingId: \"#{book_keeping.id}\"
            name: ["Transportation", "Wholesale Distribution"],
          }
        )
        {
          id
          name
          book_keepings {
            id
            payroll
            price_payroll
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
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

      updated = json_response(res, 200)["data"]["updateBookKeepingIndustry"]

      assert updated["id"]                           == struct.id
      assert updated["book_keepings"]["id"]          == struct.book_keeping_id
      assert updated["name"]                         == ["Transportation", "Wholesale Distribution"]
    end
  end

  describe "#delete" do
    it "delete specific BookKeepingIndustry" do
      user = insert(:user)
      book_keeping = insert(:book_keeping, %{user: user})
      struct = insert(:book_keeping_industry, %{book_keepings: book_keeping})

      mutation = """
      {
        deleteBookKeepingIndustry(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteBookKeepingIndustry"]
      assert deleted["id"] == struct.id
    end
  end

  describe "#dataloads" do
    it "created BookKeepingIndustry" do
       user = insert(:user)
       %{id: id} = insert(:book_keeping, user: user)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:book_keeping_industries, source)
        |> Dataloader.load(:book_keeping_industries, Core.Services.BookKeeping, id)
        |> Dataloader.run

      data = Dataloader.get(loader, :book_keeping_industries, Core.Services.BookKeeping, id)

      assert data.id == id
    end
  end

  @spec format_field([atom()]) :: [String.t()]
  defp format_field(data) do
    Enum.reduce(data, [], fn(x, acc) ->
      [to_string(x) | acc]
    end) |> Enum.sort()
  end
end

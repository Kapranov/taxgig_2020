defmodule ServerWeb.GraphQL.Integration.Products.BookKeepingAdditionalNeedIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns BookKeepingAdditionalNeed by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:tp_book_keeping_additional_need, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        allBookKeepingAdditionalNeeds {
          id
          name
          price
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBookKeepingAdditionalNeeds"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBookKeepingAdditionalNeeds"]

      assert List.first(data)["id"]                                    == struct.id
      assert List.first(data)["name"]                                  == format_field(struct.name)
      assert List.first(data)["price"]                                 == nil
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

      {:ok, %{data: %{"allBookKeepingAdditionalNeeds" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == struct.id
      assert first["name"]                                  == format_field(struct.name)
      assert first["price"]                                 == nil
      assert first["book_keepings"]["id"]                   == struct.book_keepings.id
      assert first["book_keepings"]["account_count"]        == struct.book_keepings.account_count
      assert first["book_keepings"]["balance_sheet"]        == struct.book_keepings.balance_sheet
      assert first["book_keepings"]["financial_situation"]  == struct.book_keepings.financial_situation
      assert first["book_keepings"]["inventory"]            == struct.book_keepings.inventory
      assert first["book_keepings"]["inventory_count"]      == struct.book_keepings.inventory_count
      assert first["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert first["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert first["book_keepings"]["tax_return_current"]   == struct.book_keepings.tax_return_current
      assert first["book_keepings"]["tax_year"]             == struct.book_keepings.tax_year
      assert first["book_keepings"]["user"]["id"]           == user.id
      assert first["book_keepings"]["user"]["email"]        == user.email
      assert first["book_keepings"]["user"]["role"]         == user.role
    end

    it "returns BookKeepingAdditionalNeed by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:pro_book_keeping_additional_need, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        allBookKeepingAdditionalNeeds {
          id
          name
          price
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBookKeepingAdditionalNeeds"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBookKeepingAdditionalNeeds"]

      assert List.first(data)["id"]                                    == struct.id
      assert List.first(data)["name"]                                  == format_field(struct.name)
      assert List.first(data)["price"]                                 == struct.price
      assert List.first(data)["book_keepings"]["id"]                   == struct.book_keepings.id
      assert List.first(data)["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert List.first(data)["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert List.first(data)["book_keepings"]["user"]["id"]           == user.id
      assert List.first(data)["book_keepings"]["user"]["email"]        == user.email
      assert List.first(data)["book_keepings"]["user"]["role"]         == user.role

      {:ok, %{data: %{"allBookKeepingAdditionalNeeds" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == struct.id
      assert first["name"]                                  == format_field(struct.name)
      assert first["price"]                                 == struct.price
      assert first["book_keepings"]["id"]                   == struct.book_keepings.id
      assert first["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert first["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert first["book_keepings"]["user"]["id"]           == user.id
      assert first["book_keepings"]["user"]["email"]        == user.email
      assert first["book_keepings"]["user"]["role"]         == user.role
    end
  end

  describe "#show" do
    it "returns specific BookKeepingAdditionalNeed by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:tp_book_keeping_additional_need, %{name: "accounts payable", book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        showBookKeepingAdditionalNeed(id: \"#{struct.id}\") {
          id
          name
          price
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

      {:ok, %{data: %{"showBookKeepingAdditionalNeed" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == nil
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["account_count"]        == struct.book_keepings.account_count
      assert found["book_keepings"]["balance_sheet"]        == struct.book_keepings.balance_sheet
      assert found["book_keepings"]["financial_situation"]  == struct.book_keepings.financial_situation
      assert found["book_keepings"]["inventory"]            == struct.book_keepings.inventory
      assert found["book_keepings"]["inventory_count"]      == struct.book_keepings.inventory_count
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert found["book_keepings"]["tax_return_current"]   == struct.book_keepings.tax_return_current
      assert found["book_keepings"]["tax_year"]             == struct.book_keepings.tax_year
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBookKeepingAdditionalNeed"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBookKeepingAdditionalNeed"]

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == nil
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["account_count"]        == struct.book_keepings.account_count
      assert found["book_keepings"]["balance_sheet"]        == struct.book_keepings.balance_sheet
      assert found["book_keepings"]["financial_situation"]  == struct.book_keepings.financial_situation
      assert found["book_keepings"]["inventory"]            == struct.book_keepings.inventory
      assert found["book_keepings"]["inventory_count"]      == struct.book_keepings.inventory_count
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert found["book_keepings"]["tax_return_current"]   == struct.book_keepings.tax_return_current
      assert found["book_keepings"]["tax_year"]             == struct.book_keepings.tax_year
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role
    end

    it "returns specific SaleTaxIndustry by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:pro_book_keeping_additional_need, %{name: "accounts payable", book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        showBookKeepingAdditionalNeed(id: \"#{struct.id}\") {
          id
          name
          price
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

      {:ok, %{data: %{"showBookKeepingAdditionalNeed" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == struct.price
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["account_count"]        == struct.book_keepings.account_count
      assert found["book_keepings"]["balance_sheet"]        == struct.book_keepings.balance_sheet
      assert found["book_keepings"]["financial_situation"]  == struct.book_keepings.financial_situation
      assert found["book_keepings"]["inventory"]            == struct.book_keepings.inventory
      assert found["book_keepings"]["inventory_count"]      == struct.book_keepings.inventory_count
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert found["book_keepings"]["tax_return_current"]   == struct.book_keepings.tax_return_current
      assert found["book_keepings"]["tax_year"]             == struct.book_keepings.tax_year
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBookKeepingAdditionalNeed"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBookKeepingAdditionalNeed"]

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == struct.price
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["account_count"]        == struct.book_keepings.account_count
      assert found["book_keepings"]["balance_sheet"]        == struct.book_keepings.balance_sheet
      assert found["book_keepings"]["financial_situation"]  == struct.book_keepings.financial_situation
      assert found["book_keepings"]["inventory"]            == struct.book_keepings.inventory
      assert found["book_keepings"]["inventory_count"]      == struct.book_keepings.inventory_count
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert found["book_keepings"]["tax_return_current"]   == struct.book_keepings.tax_return_current
      assert found["book_keepings"]["tax_year"]             == struct.book_keepings.tax_year
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role
    end
  end

  defp format_field(data), do: to_string(data)
end

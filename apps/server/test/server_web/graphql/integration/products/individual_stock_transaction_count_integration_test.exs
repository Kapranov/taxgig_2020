defmodule ServerWeb.GraphQL.Integration.Products.IndividualStockTransactionCountIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns IndividualStockTransactionCount by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      struct = insert(:tp_individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        allIndividualStockTransactionCounts {
          id
          name
          individual_tax_returns {
            id
            deadline
            foreign_account
            foreign_account_limit
            foreign_financial_interest
            home_owner
            k1_count
            k1_income
            living_abroad
            non_resident_earning
            none_expat
            own_stock_crypto
            rental_property_count
            rental_property_income
            sole_proprietorship_count
            state
            stock_divident
            tax_year
            individual_employment_statuses {id name}
            individual_filing_statuses {id name }
            individual_foreign_account_counts { id name }
            individual_industries { id name }
            individual_itemized_deductions { id name }
            individual_stock_transaction_counts { id name }
            user { id email role}
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allIndividualStockTransactionCounts"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allIndividualStockTransactionCounts"]

      assert List.first(data)["id"]                                                   == struct.id
      assert List.first(data)["name"]                                                 == format_field(struct.name)
      assert List.first(data)["individual_tax_returns"]["id"]                         == struct.individual_tax_returns.id
      assert List.first(data)["individual_tax_returns"]["deadline"]                   == format_deadline(struct.individual_tax_returns.deadline)
      assert List.first(data)["individual_tax_returns"]["foreign_account"]            == struct.individual_tax_returns.foreign_account
      assert List.first(data)["individual_tax_returns"]["foreign_account_limit"]      == struct.individual_tax_returns.foreign_account_limit
      assert List.first(data)["individual_tax_returns"]["foreign_financial_interest"] == struct.individual_tax_returns.foreign_financial_interest
      assert List.first(data)["individual_tax_returns"]["home_owner"]                 == struct.individual_tax_returns.home_owner
      assert List.first(data)["individual_tax_returns"]["k1_count"]                   == struct.individual_tax_returns.k1_count
      assert List.first(data)["individual_tax_returns"]["k1_income"]                  == struct.individual_tax_returns.k1_income
      assert List.first(data)["individual_tax_returns"]["living_abroad"]              == struct.individual_tax_returns.living_abroad
      assert List.first(data)["individual_tax_returns"]["non_resident_earning"]       == struct.individual_tax_returns.non_resident_earning
      assert List.first(data)["individual_tax_returns"]["none_expat"]                 == struct.individual_tax_returns.none_expat
      assert List.first(data)["individual_tax_returns"]["own_stock_crypto"]           == struct.individual_tax_returns.own_stock_crypto
      assert List.first(data)["individual_tax_returns"]["rental_property_count"]      == struct.individual_tax_returns.rental_property_count
      assert List.first(data)["individual_tax_returns"]["rental_property_income"]     == struct.individual_tax_returns.rental_property_income
      assert List.first(data)["individual_tax_returns"]["sole_proprietorship_count"]  == struct.individual_tax_returns.sole_proprietorship_count
      assert List.first(data)["individual_tax_returns"]["state"]                      == struct.individual_tax_returns.state
      assert List.first(data)["individual_tax_returns"]["stock_divident"]             == struct.individual_tax_returns.stock_divident
      assert List.first(data)["individual_tax_returns"]["tax_year"]                   == struct.individual_tax_returns.tax_year
      assert List.first(data)["individual_tax_returns"]["user"]["id"]                 == user.id
      assert List.first(data)["individual_tax_returns"]["user"]["email"]              == user.email
      assert List.first(data)["individual_tax_returns"]["user"]["role"]               == user.role

      {:ok, %{data: %{"allIndividualStockTransactionCounts" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                                   == struct.id
      assert first["name"]                                                 == format_field(struct.name)
      assert first["individual_tax_returns"]["id"]                         == struct.individual_tax_returns.id
      assert first["individual_tax_returns"]["deadline"]                   == format_deadline(struct.individual_tax_returns.deadline)
      assert first["individual_tax_returns"]["foreign_account"]            == struct.individual_tax_returns.foreign_account
      assert first["individual_tax_returns"]["foreign_account_limit"]      == struct.individual_tax_returns.foreign_account_limit
      assert first["individual_tax_returns"]["foreign_financial_interest"] == struct.individual_tax_returns.foreign_financial_interest
      assert first["individual_tax_returns"]["home_owner"]                 == struct.individual_tax_returns.home_owner
      assert first["individual_tax_returns"]["k1_count"]                   == struct.individual_tax_returns.k1_count
      assert first["individual_tax_returns"]["k1_income"]                  == struct.individual_tax_returns.k1_income
      assert first["individual_tax_returns"]["living_abroad"]              == struct.individual_tax_returns.living_abroad
      assert first["individual_tax_returns"]["non_resident_earning"]       == struct.individual_tax_returns.non_resident_earning
      assert first["individual_tax_returns"]["none_expat"]                 == struct.individual_tax_returns.none_expat
      assert first["individual_tax_returns"]["own_stock_crypto"]           == struct.individual_tax_returns.own_stock_crypto
      assert first["individual_tax_returns"]["rental_property_count"]      == struct.individual_tax_returns.rental_property_count
      assert first["individual_tax_returns"]["rental_property_income"]     == struct.individual_tax_returns.rental_property_income
      assert first["individual_tax_returns"]["sole_proprietorship_count"]  == struct.individual_tax_returns.sole_proprietorship_count
      assert first["individual_tax_returns"]["state"]                      == struct.individual_tax_returns.state
      assert first["individual_tax_returns"]["stock_divident"]             == struct.individual_tax_returns.stock_divident
      assert first["individual_tax_returns"]["tax_year"]                   == struct.individual_tax_returns.tax_year
      assert first["individual_tax_returns"]["user"]["id"]                 == user.id
      assert first["individual_tax_returns"]["user"]["email"]              == user.email
      assert first["individual_tax_returns"]["user"]["role"]               == user.role
    end
  end

  describe "#show" do
    it "returns specific IndividualStockTransactionCount by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      struct = insert(:tp_individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        showIndividualStockTransactionCount(id: \"#{struct.id}\") {
          id
          name
          individual_tax_returns {
            id
            deadline
            foreign_account
            foreign_account_limit
            foreign_financial_interest
            home_owner
            k1_count
            k1_income
            living_abroad
            non_resident_earning
            none_expat
            own_stock_crypto
            rental_property_count
            rental_property_income
            sole_proprietorship_count
            state
            stock_divident
            tax_year
            individual_employment_statuses {id name}
            individual_filing_statuses {id name }
            individual_foreign_account_counts { id name }
            individual_industries { id name }
            individual_itemized_deductions { id name }
            individual_stock_transaction_counts { id name }
            user { id email role}
          }
        }
      }
      """

      {:ok, %{data: %{"showIndividualStockTransactionCount" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                                   == struct.id
      assert found["name"]                                                 == format_field(struct.name)
      assert found["individual_tax_returns"]["id"]                         == struct.individual_tax_returns.id
      assert found["individual_tax_returns"]["deadline"]                   == format_deadline(struct.individual_tax_returns.deadline)
      assert found["individual_tax_returns"]["foreign_account"]            == struct.individual_tax_returns.foreign_account
      assert found["individual_tax_returns"]["foreign_account_limit"]      == struct.individual_tax_returns.foreign_account_limit
      assert found["individual_tax_returns"]["foreign_financial_interest"] == struct.individual_tax_returns.foreign_financial_interest
      assert found["individual_tax_returns"]["home_owner"]                 == struct.individual_tax_returns.home_owner
      assert found["individual_tax_returns"]["k1_count"]                   == struct.individual_tax_returns.k1_count
      assert found["individual_tax_returns"]["k1_income"]                  == struct.individual_tax_returns.k1_income
      assert found["individual_tax_returns"]["living_abroad"]              == struct.individual_tax_returns.living_abroad
      assert found["individual_tax_returns"]["non_resident_earning"]       == struct.individual_tax_returns.non_resident_earning
      assert found["individual_tax_returns"]["none_expat"]                 == struct.individual_tax_returns.none_expat
      assert found["individual_tax_returns"]["own_stock_crypto"]           == struct.individual_tax_returns.own_stock_crypto
      assert found["individual_tax_returns"]["rental_property_count"]      == struct.individual_tax_returns.rental_property_count
      assert found["individual_tax_returns"]["rental_property_income"]     == struct.individual_tax_returns.rental_property_income
      assert found["individual_tax_returns"]["sole_proprietorship_count"]  == struct.individual_tax_returns.sole_proprietorship_count
      assert found["individual_tax_returns"]["state"]                      == struct.individual_tax_returns.state
      assert found["individual_tax_returns"]["stock_divident"]             == struct.individual_tax_returns.stock_divident
      assert found["individual_tax_returns"]["tax_year"]                   == struct.individual_tax_returns.tax_year
      assert found["individual_tax_returns"]["user"]["id"]                 == user.id
      assert found["individual_tax_returns"]["user"]["email"]              == user.email
      assert found["individual_tax_returns"]["user"]["role"]               == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showIndividualStockTransactionCount"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showIndividualStockTransactionCount"]

      assert found["id"]                                                   == struct.id
      assert found["name"]                                                 == format_field(struct.name)
      assert found["individual_tax_returns"]["id"]                         == struct.individual_tax_returns.id
      assert found["individual_tax_returns"]["deadline"]                   == format_deadline(struct.individual_tax_returns.deadline)
      assert found["individual_tax_returns"]["foreign_account"]            == struct.individual_tax_returns.foreign_account
      assert found["individual_tax_returns"]["foreign_account_limit"]      == struct.individual_tax_returns.foreign_account_limit
      assert found["individual_tax_returns"]["foreign_financial_interest"] == struct.individual_tax_returns.foreign_financial_interest
      assert found["individual_tax_returns"]["home_owner"]                 == struct.individual_tax_returns.home_owner
      assert found["individual_tax_returns"]["k1_count"]                   == struct.individual_tax_returns.k1_count
      assert found["individual_tax_returns"]["k1_income"]                  == struct.individual_tax_returns.k1_income
      assert found["individual_tax_returns"]["living_abroad"]              == struct.individual_tax_returns.living_abroad
      assert found["individual_tax_returns"]["non_resident_earning"]       == struct.individual_tax_returns.non_resident_earning
      assert found["individual_tax_returns"]["none_expat"]                 == struct.individual_tax_returns.none_expat
      assert found["individual_tax_returns"]["own_stock_crypto"]           == struct.individual_tax_returns.own_stock_crypto
      assert found["individual_tax_returns"]["rental_property_count"]      == struct.individual_tax_returns.rental_property_count
      assert found["individual_tax_returns"]["rental_property_income"]     == struct.individual_tax_returns.rental_property_income
      assert found["individual_tax_returns"]["sole_proprietorship_count"]  == struct.individual_tax_returns.sole_proprietorship_count
      assert found["individual_tax_returns"]["state"]                      == struct.individual_tax_returns.state
      assert found["individual_tax_returns"]["stock_divident"]             == struct.individual_tax_returns.stock_divident
      assert found["individual_tax_returns"]["tax_year"]                   == struct.individual_tax_returns.tax_year
      assert found["individual_tax_returns"]["user"]["id"]                 == user.id
      assert found["individual_tax_returns"]["user"]["email"]              == user.email
      assert found["individual_tax_returns"]["user"]["role"]               == user.role
    end
  end

  describe "#find" do
    it "returns specific IndividualStockTransactionCount by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      struct = insert(:tp_individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        findIndividualStockTransactionCount(id: \"#{struct.id}\") {
          id
          name
          individual_tax_returns {
            id
            deadline
            foreign_account
            foreign_account_limit
            foreign_financial_interest
            home_owner
            k1_count
            k1_income
            living_abroad
            non_resident_earning
            none_expat
            own_stock_crypto
            rental_property_count
            rental_property_income
            sole_proprietorship_count
            state
            stock_divident
            tax_year
            individual_employment_statuses {id name}
            individual_filing_statuses {id name }
            individual_foreign_account_counts { id name }
            individual_industries { id name }
            individual_itemized_deductions { id name }
            individual_stock_transaction_counts { id name }
            user { id email role}
          }
        }
      }
      """

      {:ok, %{data: %{"findIndividualStockTransactionCount" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                                   == struct.id
      assert found["name"]                                                 == format_field(struct.name)
      assert found["individual_tax_returns"]["id"]                         == struct.individual_tax_returns.id
      assert found["individual_tax_returns"]["deadline"]                   == format_deadline(struct.individual_tax_returns.deadline)
      assert found["individual_tax_returns"]["foreign_account"]            == struct.individual_tax_returns.foreign_account
      assert found["individual_tax_returns"]["foreign_account_limit"]      == struct.individual_tax_returns.foreign_account_limit
      assert found["individual_tax_returns"]["foreign_financial_interest"] == struct.individual_tax_returns.foreign_financial_interest
      assert found["individual_tax_returns"]["home_owner"]                 == struct.individual_tax_returns.home_owner
      assert found["individual_tax_returns"]["k1_count"]                   == struct.individual_tax_returns.k1_count
      assert found["individual_tax_returns"]["k1_income"]                  == struct.individual_tax_returns.k1_income
      assert found["individual_tax_returns"]["living_abroad"]              == struct.individual_tax_returns.living_abroad
      assert found["individual_tax_returns"]["non_resident_earning"]       == struct.individual_tax_returns.non_resident_earning
      assert found["individual_tax_returns"]["none_expat"]                 == struct.individual_tax_returns.none_expat
      assert found["individual_tax_returns"]["own_stock_crypto"]           == struct.individual_tax_returns.own_stock_crypto
      assert found["individual_tax_returns"]["rental_property_count"]      == struct.individual_tax_returns.rental_property_count
      assert found["individual_tax_returns"]["rental_property_income"]     == struct.individual_tax_returns.rental_property_income
      assert found["individual_tax_returns"]["sole_proprietorship_count"]  == struct.individual_tax_returns.sole_proprietorship_count
      assert found["individual_tax_returns"]["state"]                      == struct.individual_tax_returns.state
      assert found["individual_tax_returns"]["stock_divident"]             == struct.individual_tax_returns.stock_divident
      assert found["individual_tax_returns"]["tax_year"]                   == struct.individual_tax_returns.tax_year
      assert found["individual_tax_returns"]["user"]["id"]                 == user.id
      assert found["individual_tax_returns"]["user"]["email"]              == user.email
      assert found["individual_tax_returns"]["user"]["role"]               == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualStockTransactionCount"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualStockTransactionCount"]

      assert found["id"]                                                   == struct.id
      assert found["name"]                                                 == format_field(struct.name)
      assert found["individual_tax_returns"]["id"]                         == struct.individual_tax_returns.id
      assert found["individual_tax_returns"]["deadline"]                   == format_deadline(struct.individual_tax_returns.deadline)
      assert found["individual_tax_returns"]["foreign_account"]            == struct.individual_tax_returns.foreign_account
      assert found["individual_tax_returns"]["foreign_account_limit"]      == struct.individual_tax_returns.foreign_account_limit
      assert found["individual_tax_returns"]["foreign_financial_interest"] == struct.individual_tax_returns.foreign_financial_interest
      assert found["individual_tax_returns"]["home_owner"]                 == struct.individual_tax_returns.home_owner
      assert found["individual_tax_returns"]["k1_count"]                   == struct.individual_tax_returns.k1_count
      assert found["individual_tax_returns"]["k1_income"]                  == struct.individual_tax_returns.k1_income
      assert found["individual_tax_returns"]["living_abroad"]              == struct.individual_tax_returns.living_abroad
      assert found["individual_tax_returns"]["non_resident_earning"]       == struct.individual_tax_returns.non_resident_earning
      assert found["individual_tax_returns"]["none_expat"]                 == struct.individual_tax_returns.none_expat
      assert found["individual_tax_returns"]["own_stock_crypto"]           == struct.individual_tax_returns.own_stock_crypto
      assert found["individual_tax_returns"]["rental_property_count"]      == struct.individual_tax_returns.rental_property_count
      assert found["individual_tax_returns"]["rental_property_income"]     == struct.individual_tax_returns.rental_property_income
      assert found["individual_tax_returns"]["sole_proprietorship_count"]  == struct.individual_tax_returns.sole_proprietorship_count
      assert found["individual_tax_returns"]["state"]                      == struct.individual_tax_returns.state
      assert found["individual_tax_returns"]["stock_divident"]             == struct.individual_tax_returns.stock_divident
      assert found["individual_tax_returns"]["tax_year"]                   == struct.individual_tax_returns.tax_year
      assert found["individual_tax_returns"]["user"]["id"]                 == user.id
      assert found["individual_tax_returns"]["user"]["email"]              == user.email
      assert found["individual_tax_returns"]["user"]["role"]               == user.role
    end
  end

  describe "#create" do
    it "created IndividualStockTransactionCount by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})

      mutation = """
      {
        createIndividualStockTransactionCount(
          name: "1-5",
          individual_tax_returnId: \"#{individual_tax_return.id}\"
        ) {
          id
          name
          individual_tax_returns {
            id
            deadline
            foreign_account
            foreign_account_limit
            foreign_financial_interest
            home_owner
            k1_count
            k1_income
            living_abroad
            non_resident_earning
            none_expat
            own_stock_crypto
            rental_property_count
            rental_property_income
            sole_proprietorship_count
            state
            stock_divident
            tax_year
            individual_employment_statuses {id name}
            individual_filing_statuses {id name }
            individual_foreign_account_counts { id name }
            individual_industries { id name }
            individual_itemized_deductions { id name }
            individual_stock_transaction_counts { id name }
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

      created = json_response(res, 200)["data"]["createIndividualStockTransactionCount"]

      assert created["name"]                                                 == "1-5"
      assert created["individual_tax_returns"]["id"]                         == individual_tax_return.id
      assert created["individual_tax_returns"]["deadline"]                   == format_deadline(individual_tax_return.deadline)
      assert created["individual_tax_returns"]["foreign_account"]            == individual_tax_return.foreign_account
      assert created["individual_tax_returns"]["foreign_account_limit"]      == individual_tax_return.foreign_account_limit
      assert created["individual_tax_returns"]["foreign_financial_interest"] == individual_tax_return.foreign_financial_interest
      assert created["individual_tax_returns"]["home_owner"]                 == individual_tax_return.home_owner
      assert created["individual_tax_returns"]["k1_count"]                   == individual_tax_return.k1_count
      assert created["individual_tax_returns"]["k1_income"]                  == individual_tax_return.k1_income
      assert created["individual_tax_returns"]["living_abroad"]              == individual_tax_return.living_abroad
      assert created["individual_tax_returns"]["non_resident_earning"]       == individual_tax_return.non_resident_earning
      assert created["individual_tax_returns"]["none_expat"]                 == individual_tax_return.none_expat
      assert created["individual_tax_returns"]["own_stock_crypto"]           == individual_tax_return.own_stock_crypto
      assert created["individual_tax_returns"]["rental_property_count"]      == individual_tax_return.rental_property_count
      assert created["individual_tax_returns"]["rental_property_income"]     == individual_tax_return.rental_property_income
      assert created["individual_tax_returns"]["sole_proprietorship_count"]  == individual_tax_return.sole_proprietorship_count
      assert created["individual_tax_returns"]["state"]                      == individual_tax_return.state
      assert created["individual_tax_returns"]["stock_divident"]             == individual_tax_return.stock_divident
      assert created["individual_tax_returns"]["tax_year"]                   == individual_tax_return.tax_year
      assert created["individual_tax_returns"]["user"]["id"]                 == user.id
      assert created["individual_tax_returns"]["user"]["email"]              == user.email
      assert created["individual_tax_returns"]["user"]["role"]               == user.role
    end

    it "created IndividualStockTransactionCount by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})

      mutation = """
      {
        createIndividualStockTransactionCount(
          name: "1-5",
          individual_tax_returnId: \"#{individual_tax_return.id}\"
        ) {
          id
          name
          individual_tax_returns {
            id
            foreign_account
            home_owner
            living_abroad
            non_resident_earning
            none_expat
            own_stock_crypto
            price_foreign_account
            price_home_owner
            price_living_abroad
            price_non_resident_earning
            price_own_stock_crypto
            price_rental_property_income
            price_sole_proprietorship_count
            price_state
            price_stock_divident
            price_tax_year
            rental_property_income
            stock_divident
            individual_employment_statuses {id name}
            individual_filing_statuses {id name }
            individual_industries { id name }
            individual_itemized_deductions { id name }
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

      created = json_response(res, 200)["data"]["createIndividualStockTransactionCount"]

      assert created == nil
    end
  end

  describe "#update" do
    it "updated specific IndividualStockTransactionCount by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      struct = insert(:tp_individual_stock_transaction_count, %{name: "1-5", individual_tax_returns: individual_tax_return})

      mutation = """
      {
        updateIndividualStockTransactionCount(
          id: \"#{struct.id}\",
          IndividualStockTransactionCount: {
            name: "6-50",
            individual_tax_returnId: \"#{individual_tax_return.id}\"
          }
        )
        {
          id
          name
          individual_tax_returns {
            id
            deadline
            foreign_account
            foreign_account_limit
            foreign_financial_interest
            home_owner
            k1_count
            k1_income
            living_abroad
            non_resident_earning
            none_expat
            own_stock_crypto
            rental_property_count
            rental_property_income
            sole_proprietorship_count
            state
            stock_divident
            tax_year
            individual_employment_statuses {id name}
            individual_filing_statuses {id name }
            individual_foreign_account_counts { id name }
            individual_industries { id name }
            individual_itemized_deductions { id name }
            individual_stock_transaction_counts { id name }
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

      updated = json_response(res, 200)["data"]["updateIndividualStockTransactionCount"]

      assert updated["id"]                                                   == struct.id
      assert updated["name"]                                                 == "6-50"
      assert updated["individual_tax_returns"]["id"]                         == struct.individual_tax_returns.id
      assert updated["individual_tax_returns"]["deadline"]                   == format_deadline(struct.individual_tax_returns.deadline)
      assert updated["individual_tax_returns"]["foreign_account"]            == struct.individual_tax_returns.foreign_account
      assert updated["individual_tax_returns"]["foreign_account_limit"]      == struct.individual_tax_returns.foreign_account_limit
      assert updated["individual_tax_returns"]["foreign_financial_interest"] == struct.individual_tax_returns.foreign_financial_interest
      assert updated["individual_tax_returns"]["home_owner"]                 == struct.individual_tax_returns.home_owner
      assert updated["individual_tax_returns"]["k1_count"]                   == struct.individual_tax_returns.k1_count
      assert updated["individual_tax_returns"]["k1_income"]                  == struct.individual_tax_returns.k1_income
      assert updated["individual_tax_returns"]["living_abroad"]              == struct.individual_tax_returns.living_abroad
      assert updated["individual_tax_returns"]["non_resident_earning"]       == struct.individual_tax_returns.non_resident_earning
      assert updated["individual_tax_returns"]["none_expat"]                 == struct.individual_tax_returns.none_expat
      assert updated["individual_tax_returns"]["own_stock_crypto"]           == struct.individual_tax_returns.own_stock_crypto
      assert updated["individual_tax_returns"]["rental_property_count"]      == struct.individual_tax_returns.rental_property_count
      assert updated["individual_tax_returns"]["rental_property_income"]     == struct.individual_tax_returns.rental_property_income
      assert updated["individual_tax_returns"]["sole_proprietorship_count"]  == struct.individual_tax_returns.sole_proprietorship_count
      assert updated["individual_tax_returns"]["state"]                      == struct.individual_tax_returns.state
      assert updated["individual_tax_returns"]["stock_divident"]             == struct.individual_tax_returns.stock_divident
      assert updated["individual_tax_returns"]["tax_year"]                   == struct.individual_tax_returns.tax_year
      assert updated["individual_tax_returns"]["user"]["id"]                 == user.id
      assert updated["individual_tax_returns"]["user"]["email"]              == user.email
      assert updated["individual_tax_returns"]["user"]["role"]               == user.role
    end
  end

  describe "#delete" do
    it "delete specific IndividualStockTransactionCount" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, %{user: user})
      struct = insert(:individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})

      mutation = """
      {
        deleteIndividualStockTransactionCount(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteIndividualStockTransactionCount"]
      assert deleted["id"] == struct.id
    end
  end

  describe "#dataloads" do
    it "created IndividualStockTransactionCount" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, %{user: user})
      %{id: id} = insert(:individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:individual_stock_transaction_counts, source)
        |> Dataloader.load(:individual_stock_transaction_counts, Core.Services.IndividualStockTransactionCount, id)
        |> Dataloader.run

      data = Dataloader.get(loader, :individual_stock_transaction_counts, Core.Services.IndividualStockTransactionCount, id)

      assert data.id == id
    end
  end

  @spec format_field(atom()) :: String.t()
  defp format_field(data), do: to_string(data)

  @spec format_deadline(Date.t()) :: String.t()
  defp format_deadline(data), do: to_string(data)
end

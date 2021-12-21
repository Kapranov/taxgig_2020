defmodule ServerWeb.GraphQL.Integration.Products.IndividualTaxReturnIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns IndividualTaxReturn by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_individual_tax_return, %{user: user})
      insert(:tp_individual_employment_status, individual_tax_returns: struct)
      insert(:tp_individual_filing_status, individual_tax_returns: struct)
      insert(:tp_individual_foreign_account_count, individual_tax_returns: struct)
      insert(:tp_individual_industry, individual_tax_returns: struct)
      insert(:tp_individual_itemized_deduction, individual_tax_returns: struct)
      insert(:tp_individual_stock_transaction_count, individual_tax_returns: struct)
      context = %{current_user: user}

      query = """
      {
        allIndividualTaxReturns {
          id
          deadline
          financial_situation
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
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allIndividualTaxReturns"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allIndividualTaxReturns"]

      assert List.first(data)["id"]                         == struct.id
      assert List.first(data)["deadline"]                   == format_deadline(struct.deadline)
      assert List.first(data)["financial_situation"]        == struct.financial_situation
      assert List.first(data)["foreign_account"]            == struct.foreign_account
      assert List.first(data)["foreign_account_limit"]      == struct.foreign_account_limit
      assert List.first(data)["foreign_financial_interest"] == struct.foreign_financial_interest
      assert List.first(data)["home_owner"]                 == struct.home_owner
      assert List.first(data)["k1_count"]                   == struct.k1_count
      assert List.first(data)["k1_income"]                  == struct.k1_income
      assert List.first(data)["living_abroad"]              == struct.living_abroad
      assert List.first(data)["non_resident_earning"]       == struct.non_resident_earning
      assert List.first(data)["none_expat"]                 == struct.none_expat
      assert List.first(data)["own_stock_crypto"]           == struct.own_stock_crypto
      assert List.first(data)["rental_property_count"]      == struct.rental_property_count
      assert List.first(data)["rental_property_income"]     == struct.rental_property_income
      assert List.first(data)["sole_proprietorship_count"]  == struct.sole_proprietorship_count
      assert List.first(data)["state"]                      == struct.state
      assert List.first(data)["stock_divident"]             == struct.stock_divident
      assert List.first(data)["tax_year"]                   == struct.tax_year
      assert List.first(data)["user"]["id"]                 == user.id
      assert List.first(data)["user"]["email"]              == user.email
      assert List.first(data)["user"]["role"]               == user.role

      {:ok, %{data: %{"allIndividualTaxReturns" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                         == struct.id
      assert first["deadline"]                   == format_deadline(struct.deadline)
      assert first["financial_situation"]        == struct.financial_situation
      assert first["foreign_account"]            == struct.foreign_account
      assert first["foreign_account_limit"]      == struct.foreign_account_limit
      assert first["foreign_financial_interest"] == struct.foreign_financial_interest
      assert first["home_owner"]                 == struct.home_owner
      assert first["k1_count"]                   == struct.k1_count
      assert first["k1_income"]                  == struct.k1_income
      assert first["living_abroad"]              == struct.living_abroad
      assert first["non_resident_earning"]       == struct.non_resident_earning
      assert first["none_expat"]                 == struct.none_expat
      assert first["own_stock_crypto"]           == struct.own_stock_crypto
      assert first["rental_property_count"]      == struct.rental_property_count
      assert first["rental_property_income"]     == struct.rental_property_income
      assert first["sole_proprietorship_count"]  == struct.sole_proprietorship_count
      assert first["state"]                      == struct.state
      assert first["stock_divident"]             == struct.stock_divident
      assert first["tax_year"]                   == struct.tax_year
      assert first["user"]["id"]                 == user.id
      assert first["user"]["email"]              == user.email
      assert first["user"]["role"]               == user.role
    end

    it "returns IndividualTaxReturn by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_individual_tax_return, %{user: user})
      insert(:tp_individual_employment_status, individual_tax_returns: struct)
      insert(:tp_individual_filing_status, individual_tax_returns: struct)
      insert(:tp_individual_industry, individual_tax_returns: struct)
      insert(:tp_individual_itemized_deduction, individual_tax_returns: struct)
      context = %{current_user: user}

      query = """
      {
        allIndividualTaxReturns {
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
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allIndividualTaxReturns"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allIndividualTaxReturns"]

      assert List.first(data)["id"]                              == struct.id
      assert List.first(data)["foreign_account"]                 == struct.foreign_account
      assert List.first(data)["home_owner"]                      == struct.home_owner
      assert List.first(data)["living_abroad"]                   == struct.living_abroad
      assert List.first(data)["non_resident_earning"]            == struct.non_resident_earning
      assert List.first(data)["none_expat"]                      == struct.none_expat
      assert List.first(data)["own_stock_crypto"]                == struct.own_stock_crypto
      assert List.first(data)["price_foreign_account"]           == struct.price_foreign_account
      assert List.first(data)["price_home_owner"]                == struct.price_home_owner
      assert List.first(data)["price_living_abroad"]             == struct.price_living_abroad
      assert List.first(data)["price_non_resident_earning"]      == struct.price_non_resident_earning
      assert List.first(data)["price_own_stock_crypto"]          == struct.price_own_stock_crypto
      assert List.first(data)["price_rental_property_income"]    == struct.price_rental_property_income
      assert List.first(data)["price_sole_proprietorship_count"] == struct.price_sole_proprietorship_count
      assert List.first(data)["price_state"]                     == struct.price_state
      assert List.first(data)["price_stock_divident"]            == struct.price_stock_divident
      assert List.first(data)["price_tax_year"]                  == struct.price_tax_year
      assert List.first(data)["rental_property_income"]          == struct.rental_property_income
      assert List.first(data)["stock_divident"]                  == struct.stock_divident
      assert List.first(data)["user"]["id"]                      == user.id
      assert List.first(data)["user"]["email"]                   == user.email
      assert List.first(data)["user"]["role"]                    == user.role

      {:ok, %{data: %{"allIndividualTaxReturns" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                              == struct.id
      assert first["foreign_account"]                 == struct.foreign_account
      assert first["home_owner"]                      == struct.home_owner
      assert first["living_abroad"]                   == struct.living_abroad
      assert first["non_resident_earning"]            == struct.non_resident_earning
      assert first["none_expat"]                      == struct.none_expat
      assert first["own_stock_crypto"]                == struct.own_stock_crypto
      assert first["price_foreign_account"]           == struct.price_foreign_account
      assert first["price_home_owner"]                == struct.price_home_owner
      assert first["price_living_abroad"]             == struct.price_living_abroad
      assert first["price_non_resident_earning"]      == struct.price_non_resident_earning
      assert first["price_own_stock_crypto"]          == struct.price_own_stock_crypto
      assert first["price_rental_property_income"]    == struct.price_rental_property_income
      assert first["price_sole_proprietorship_count"] == struct.price_sole_proprietorship_count
      assert first["price_state"]                     == struct.price_state
      assert first["price_stock_divident"]            == struct.price_stock_divident
      assert first["price_tax_year"]                  == struct.price_tax_year
      assert first["rental_property_income"]          == struct.rental_property_income
      assert first["stock_divident"]                  == struct.stock_divident
      assert first["user"]["id"]                      == user.id
      assert first["user"]["email"]                   == user.email
      assert first["user"]["role"]                    == user.role
    end
  end

  describe "#show" do
    it "returns specific IndividualTaxReturn by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_individual_tax_return, %{user: user})
      insert(:tp_individual_employment_status, individual_tax_returns: struct)
      insert(:tp_individual_filing_status, individual_tax_returns: struct)
      insert(:tp_individual_foreign_account_count, individual_tax_returns: struct)
      insert(:tp_individual_industry, individual_tax_returns: struct)
      insert(:tp_individual_itemized_deduction, individual_tax_returns: struct)
      insert(:tp_individual_stock_transaction_count, individual_tax_returns: struct)
      context = %{current_user: user}

      query = """
      {
        showIndividualTaxReturn(id: \"#{struct.id}\") {
          id
          deadline
          financial_situation
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
      """

      {:ok, %{data: %{"showIndividualTaxReturn" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                         == struct.id
      assert found["deadline"]                   == format_deadline(struct.deadline)
      assert found["financial_situation"]        == struct.financial_situation
      assert found["foreign_account"]            == struct.foreign_account
      assert found["foreign_account_limit"]      == struct.foreign_account_limit
      assert found["foreign_financial_interest"] == struct.foreign_financial_interest
      assert found["home_owner"]                 == struct.home_owner
      assert found["k1_count"]                   == struct.k1_count
      assert found["k1_income"]                  == struct.k1_income
      assert found["living_abroad"]              == struct.living_abroad
      assert found["non_resident_earning"]       == struct.non_resident_earning
      assert found["none_expat"]                 == struct.none_expat
      assert found["own_stock_crypto"]           == struct.own_stock_crypto
      assert found["rental_property_count"]      == struct.rental_property_count
      assert found["rental_property_income"]     == struct.rental_property_income
      assert found["sole_proprietorship_count"]  == struct.sole_proprietorship_count
      assert found["state"]                      == struct.state
      assert found["stock_divident"]             == struct.stock_divident
      assert found["tax_year"]                   == struct.tax_year
      assert found["user"]["id"]                 == user.id
      assert found["user"]["email"]              == user.email
      assert found["user"]["role"]               == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showIndividualTaxReturn"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showIndividualTaxReturn"]

      assert found["id"]                         == struct.id
      assert found["deadline"]                   == format_deadline(struct.deadline)
      assert found["financial_situation"]        == struct.financial_situation
      assert found["foreign_account"]            == struct.foreign_account
      assert found["foreign_account_limit"]      == struct.foreign_account_limit
      assert found["foreign_financial_interest"] == struct.foreign_financial_interest
      assert found["home_owner"]                 == struct.home_owner
      assert found["k1_count"]                   == struct.k1_count
      assert found["k1_income"]                  == struct.k1_income
      assert found["living_abroad"]              == struct.living_abroad
      assert found["non_resident_earning"]       == struct.non_resident_earning
      assert found["none_expat"]                 == struct.none_expat
      assert found["own_stock_crypto"]           == struct.own_stock_crypto
      assert found["rental_property_count"]      == struct.rental_property_count
      assert found["rental_property_income"]     == struct.rental_property_income
      assert found["sole_proprietorship_count"]  == struct.sole_proprietorship_count
      assert found["state"]                      == struct.state
      assert found["stock_divident"]             == struct.stock_divident
      assert found["tax_year"]                   == struct.tax_year
      assert found["user"]["id"]                 == user.id
      assert found["user"]["email"]              == user.email
      assert found["user"]["role"]               == user.role
    end

    it "returns specific IndividualTaxReturn by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_individual_tax_return, %{user: user})
      insert(:tp_individual_employment_status, individual_tax_returns: struct)
      insert(:tp_individual_filing_status, individual_tax_returns: struct)
      insert(:tp_individual_industry, individual_tax_returns: struct)
      insert(:tp_individual_itemized_deduction, individual_tax_returns: struct)
      context = %{current_user: user}

      query = """
      {
        showIndividualTaxReturn(id: \"#{struct.id}\") {
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
      """

      {:ok, %{data: %{"showIndividualTaxReturn" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                              == struct.id
      assert found["foreign_account"]                 == struct.foreign_account
      assert found["home_owner"]                      == struct.home_owner
      assert found["living_abroad"]                   == struct.living_abroad
      assert found["non_resident_earning"]            == struct.non_resident_earning
      assert found["none_expat"]                      == struct.none_expat
      assert found["own_stock_crypto"]                == struct.own_stock_crypto
      assert found["price_foreign_account"]           == struct.price_foreign_account
      assert found["price_home_owner"]                == struct.price_home_owner
      assert found["price_living_abroad"]             == struct.price_living_abroad
      assert found["price_non_resident_earning"]      == struct.price_non_resident_earning
      assert found["price_own_stock_crypto"]          == struct.price_own_stock_crypto
      assert found["price_rental_property_income"]    == struct.price_rental_property_income
      assert found["price_sole_proprietorship_count"] == struct.price_sole_proprietorship_count
      assert found["price_state"]                     == struct.price_state
      assert found["price_stock_divident"]            == struct.price_stock_divident
      assert found["price_tax_year"]                  == struct.price_tax_year
      assert found["rental_property_income"]          == struct.rental_property_income
      assert found["stock_divident"]                  == struct.stock_divident
      assert found["user"]["id"]                      == user.id
      assert found["user"]["email"]                   == user.email
      assert found["user"]["role"]                    == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showIndividualTaxReturn"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showIndividualTaxReturn"]

      assert found["id"]                              == struct.id
      assert found["foreign_account"]                 == struct.foreign_account
      assert found["home_owner"]                      == struct.home_owner
      assert found["living_abroad"]                   == struct.living_abroad
      assert found["non_resident_earning"]            == struct.non_resident_earning
      assert found["none_expat"]                      == struct.none_expat
      assert found["own_stock_crypto"]                == struct.own_stock_crypto
      assert found["price_foreign_account"]           == struct.price_foreign_account
      assert found["price_home_owner"]                == struct.price_home_owner
      assert found["price_living_abroad"]             == struct.price_living_abroad
      assert found["price_non_resident_earning"]      == struct.price_non_resident_earning
      assert found["price_own_stock_crypto"]          == struct.price_own_stock_crypto
      assert found["price_rental_property_income"]    == struct.price_rental_property_income
      assert found["price_sole_proprietorship_count"] == struct.price_sole_proprietorship_count
      assert found["price_state"]                     == struct.price_state
      assert found["price_stock_divident"]            == struct.price_stock_divident
      assert found["price_tax_year"]                  == struct.price_tax_year
      assert found["rental_property_income"]          == struct.rental_property_income
      assert found["stock_divident"]                  == struct.stock_divident
      assert found["user"]["id"]                      == user.id
      assert found["user"]["email"]                   == user.email
      assert found["user"]["role"]                    == user.role
    end
  end

  describe "#find" do
    it "returns specific IndividualTaxReturn by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_individual_tax_return, %{user: user})
      insert(:tp_individual_employment_status, individual_tax_returns: struct)
      insert(:tp_individual_filing_status, individual_tax_returns: struct)
      insert(:tp_individual_foreign_account_count, individual_tax_returns: struct)
      insert(:tp_individual_industry, individual_tax_returns: struct)
      insert(:tp_individual_itemized_deduction, individual_tax_returns: struct)
      insert(:tp_individual_stock_transaction_count, individual_tax_returns: struct)
      context = %{current_user: user}

      query = """
      {
        findIndividualTaxReturn(id: \"#{struct.id}\") {
          id
          deadline
          financial_situation
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
      """

      {:ok, %{data: %{"findIndividualTaxReturn" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                         == struct.id
      assert found["deadline"]                   == format_deadline(struct.deadline)
      assert found["financial_situation"]        == struct.financial_situation
      assert found["foreign_account"]            == struct.foreign_account
      assert found["foreign_account_limit"]      == struct.foreign_account_limit
      assert found["foreign_financial_interest"] == struct.foreign_financial_interest
      assert found["home_owner"]                 == struct.home_owner
      assert found["k1_count"]                   == struct.k1_count
      assert found["k1_income"]                  == struct.k1_income
      assert found["living_abroad"]              == struct.living_abroad
      assert found["non_resident_earning"]       == struct.non_resident_earning
      assert found["none_expat"]                 == struct.none_expat
      assert found["own_stock_crypto"]           == struct.own_stock_crypto
      assert found["rental_property_count"]      == struct.rental_property_count
      assert found["rental_property_income"]     == struct.rental_property_income
      assert found["sole_proprietorship_count"]  == struct.sole_proprietorship_count
      assert found["state"]                      == struct.state
      assert found["stock_divident"]             == struct.stock_divident
      assert found["tax_year"]                   == struct.tax_year
      assert found["user"]["id"]                 == user.id
      assert found["user"]["email"]              == user.email
      assert found["user"]["role"]               == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualTaxReturn"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualTaxReturn"]

      assert found["id"]                         == struct.id
      assert found["deadline"]                   == format_deadline(struct.deadline)
      assert found["financial_situation"]        == struct.financial_situation
      assert found["foreign_account"]            == struct.foreign_account
      assert found["foreign_account_limit"]      == struct.foreign_account_limit
      assert found["foreign_financial_interest"] == struct.foreign_financial_interest
      assert found["home_owner"]                 == struct.home_owner
      assert found["k1_count"]                   == struct.k1_count
      assert found["k1_income"]                  == struct.k1_income
      assert found["living_abroad"]              == struct.living_abroad
      assert found["non_resident_earning"]       == struct.non_resident_earning
      assert found["none_expat"]                 == struct.none_expat
      assert found["own_stock_crypto"]           == struct.own_stock_crypto
      assert found["rental_property_count"]      == struct.rental_property_count
      assert found["rental_property_income"]     == struct.rental_property_income
      assert found["sole_proprietorship_count"]  == struct.sole_proprietorship_count
      assert found["state"]                      == struct.state
      assert found["stock_divident"]             == struct.stock_divident
      assert found["tax_year"]                   == struct.tax_year
      assert found["user"]["id"]                 == user.id
      assert found["user"]["email"]              == user.email
      assert found["user"]["role"]               == user.role
    end

    it "returns specific IndividualTaxReturn by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_individual_tax_return, %{user: user})
      insert(:tp_individual_employment_status, individual_tax_returns: struct)
      insert(:tp_individual_filing_status, individual_tax_returns: struct)
      insert(:tp_individual_industry, individual_tax_returns: struct)
      insert(:tp_individual_itemized_deduction, individual_tax_returns: struct)
      context = %{current_user: user}

      query = """
      {
        findIndividualTaxReturn(id: \"#{struct.id}\") {
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
      """

      {:ok, %{data: %{"findIndividualTaxReturn" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                              == struct.id
      assert found["foreign_account"]                 == struct.foreign_account
      assert found["home_owner"]                      == struct.home_owner
      assert found["living_abroad"]                   == struct.living_abroad
      assert found["non_resident_earning"]            == struct.non_resident_earning
      assert found["none_expat"]                      == struct.none_expat
      assert found["own_stock_crypto"]                == struct.own_stock_crypto
      assert found["price_foreign_account"]           == struct.price_foreign_account
      assert found["price_home_owner"]                == struct.price_home_owner
      assert found["price_living_abroad"]             == struct.price_living_abroad
      assert found["price_non_resident_earning"]      == struct.price_non_resident_earning
      assert found["price_own_stock_crypto"]          == struct.price_own_stock_crypto
      assert found["price_rental_property_income"]    == struct.price_rental_property_income
      assert found["price_sole_proprietorship_count"] == struct.price_sole_proprietorship_count
      assert found["price_state"]                     == struct.price_state
      assert found["price_stock_divident"]            == struct.price_stock_divident
      assert found["price_tax_year"]                  == struct.price_tax_year
      assert found["rental_property_income"]          == struct.rental_property_income
      assert found["stock_divident"]                  == struct.stock_divident
      assert found["user"]["id"]                      == user.id
      assert found["user"]["email"]                   == user.email
      assert found["user"]["role"]                    == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualTaxReturn"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualTaxReturn"]

      assert found["id"]                              == struct.id
      assert found["foreign_account"]                 == struct.foreign_account
      assert found["home_owner"]                      == struct.home_owner
      assert found["living_abroad"]                   == struct.living_abroad
      assert found["non_resident_earning"]            == struct.non_resident_earning
      assert found["none_expat"]                      == struct.none_expat
      assert found["own_stock_crypto"]                == struct.own_stock_crypto
      assert found["price_foreign_account"]           == struct.price_foreign_account
      assert found["price_home_owner"]                == struct.price_home_owner
      assert found["price_living_abroad"]             == struct.price_living_abroad
      assert found["price_non_resident_earning"]      == struct.price_non_resident_earning
      assert found["price_own_stock_crypto"]          == struct.price_own_stock_crypto
      assert found["price_rental_property_income"]    == struct.price_rental_property_income
      assert found["price_sole_proprietorship_count"] == struct.price_sole_proprietorship_count
      assert found["price_state"]                     == struct.price_state
      assert found["price_stock_divident"]            == struct.price_stock_divident
      assert found["price_tax_year"]                  == struct.price_tax_year
      assert found["rental_property_income"]          == struct.rental_property_income
      assert found["stock_divident"]                  == struct.stock_divident
      assert found["user"]["id"]                      == user.id
      assert found["user"]["email"]                   == user.email
      assert found["user"]["role"]                    == user.role
    end
  end

  describe "#create" do
    it "created IndividualTaxReturn by role's Tp" do
      user = insert(:tp_user)

      mutation = """
      {
        createIndividualTaxReturn(
          deadline: \"#{Date.utc_today()}\",
          financial_situation: "some text",
          foreign_account: true,
          foreign_account_limit: true,
          foreign_financial_interest: true,
          home_owner: true,
          k1_count: 22,
          k1_income: true,
          living_abroad: true,
          non_resident_earning: true,
          none_expat: true,
          own_stock_crypto: true,
          rental_property_count: 22,
          rental_property_income: true,
          sole_proprietorship_count: 22,
          state: ["Alabama", "New York"],
          stock_divident: true,
          tax_year: ["2017", "2018"],
          userId: \"#{user.id}\"
        ) {
          id
          deadline
          financial_situation
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
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createIndividualTaxReturn"]

      assert created["deadline"]                   == format_deadline(Date.utc_today())
      assert created["financial_situation"]        == "some text"
      assert created["foreign_account"]            == true
      assert created["foreign_account_limit"]      == true
      assert created["foreign_financial_interest"] == true
      assert created["home_owner"]                 == true
      assert created["k1_count"]                   == 22
      assert created["k1_income"]                  == true
      assert created["living_abroad"]              == true
      assert created["non_resident_earning"]       == true
      assert created["none_expat"]                 == true
      assert created["own_stock_crypto"]           == true
      assert created["rental_property_count"]      == 22
      assert created["rental_property_income"]     == true
      assert created["sole_proprietorship_count"]  == 22
      assert created["state"]                      == ["Alabama", "New York"]
      assert created["stock_divident"]             == true
      assert created["tax_year"]                   == ["2017", "2018"]
      assert created["user"]["id"]                 == user.id
      assert created["user"]["email"]              == user.email
      assert created["user"]["role"]               == user.role
    end

    it "created IndividualTaxReturn by role's Pro" do
      user = insert(:pro_user)

      mutation = """
      {
        createIndividualTaxReturn(
          foreign_account: true,
          home_owner: true,
          living_abroad: true,
          non_resident_earning: true,
          none_expat: true,
          own_stock_crypto: true,
          price_foreign_account: 22,
          price_home_owner: 22,
          price_living_abroad: 22,
          price_non_resident_earning: 22,
          price_own_stock_crypto: 22,
          price_rental_property_income: 22,
          price_sole_proprietorship_count: 22,
          price_state: 22,
          price_stock_divident: 22,
          price_tax_year: 22,
          rental_property_income: true,
          stock_divident: true,
          userId: \"#{user.id}\"
        ) {
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
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createIndividualTaxReturn"]

      assert created["foreign_account"]                 == true
      assert created["home_owner"]                      == true
      assert created["living_abroad"]                   == true
      assert created["non_resident_earning"]            == true
      assert created["none_expat"]                      == true
      assert created["own_stock_crypto"]                == true
      assert created["price_foreign_account"]           == 22
      assert created["price_home_owner"]                == 22
      assert created["price_living_abroad"]             == 22
      assert created["price_non_resident_earning"]      == 22
      assert created["price_own_stock_crypto"]          == 22
      assert created["price_rental_property_income"]    == 22
      assert created["price_sole_proprietorship_count"] == 22
      assert created["price_state"]                     == 22
      assert created["price_stock_divident"]            == 22
      assert created["price_tax_year"]                  == 22
      assert created["rental_property_income"]          == true
      assert created["stock_divident"]                  == true
      assert created["user"]["id"]                      == user.id
      assert created["user"]["email"]                   == user.email
      assert created["user"]["role"]                    == user.role
    end
  end

  describe "#update" do
    it "updated specific IndividualTaxReturn by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_individual_tax_return, %{user: user})
      insert(:tp_individual_employment_status, individual_tax_returns: struct)
      insert(:tp_individual_filing_status, individual_tax_returns: struct)
      insert(:tp_individual_foreign_account_count, individual_tax_returns: struct)
      insert(:tp_individual_industry, individual_tax_returns: struct)
      insert(:tp_individual_itemized_deduction, individual_tax_returns: struct)
      insert(:tp_individual_stock_transaction_count, individual_tax_returns: struct)

      mutation = """
      {
        updateIndividualTaxReturn(
          id: \"#{struct.id}\",
          IndividualTaxReturn: {
            deadline: \"#{Date.utc_today |> Date.add(-3)}\",
            financial_situation: "updated text",
            foreign_account: false,
            foreign_account_limit: false,
            foreign_financial_interest: false,
            home_owner: false,
            k1_count: 33,
            k1_income: false,
            living_abroad: false,
            non_resident_earning: false,
            none_expat: false,
            own_stock_crypto: false,
            rental_property_count: 33,
            rental_property_income: false,
            sole_proprietorship_count: 33,
            state: ["Alabama"],
            stock_divident: false,
            tax_year: ["2019"],
            userId: \"#{user.id}\"
          }
        )
        {
          id
          deadline
          financial_situation
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
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateIndividualTaxReturn"]

      assert updated["id"]                         == struct.id
      assert updated["deadline"]                   == format_deadline(Date.utc_today |> Date.add(-3))
      assert updated["financial_situation"]        == "updated text"
      assert updated["foreign_account"]            == false
      assert updated["foreign_account_limit"]      == false
      assert updated["foreign_financial_interest"] == false
      assert updated["home_owner"]                 == false
      assert updated["k1_count"]                   == 33
      assert updated["k1_income"]                  == false
      assert updated["living_abroad"]              == false
      assert updated["non_resident_earning"]       == false
      assert updated["none_expat"]                 == false
      assert updated["own_stock_crypto"]           == false
      assert updated["rental_property_count"]      == 33
      assert updated["rental_property_income"]     == false
      assert updated["sole_proprietorship_count"]  == 33
      assert updated["state"]                      == ["Alabama"]
      assert updated["stock_divident"]             == false
      assert updated["tax_year"]                   == ["2019"]
      assert updated["user"]["id"]                 == user.id
      assert updated["user"]["email"]              == user.email
      assert updated["user"]["role"]               == user.role
    end

    it "updated specific IndividualTaxReturn by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_individual_tax_return, %{user: user})
      insert(:tp_individual_employment_status, individual_tax_returns: struct)
      insert(:tp_individual_filing_status, individual_tax_returns: struct)
      insert(:tp_individual_industry, individual_tax_returns: struct)
      insert(:tp_individual_itemized_deduction, individual_tax_returns: struct)

      mutation = """
      {
        updateIndividualTaxReturn(
          id: \"#{struct.id}\",
          IndividualTaxReturn: {
            foreign_account: false,
            home_owner: false,
            living_abroad: false,
            non_resident_earning: false,
            none_expat: false,
            own_stock_crypto: false,
            price_foreign_account: 33,
            price_home_owner: 33,
            price_living_abroad: 33,
            price_non_resident_earning: 33,
            price_own_stock_crypto: 33,
            price_rental_property_income: 33,
            price_sole_proprietorship_count: 33,
            price_state: 33,
            price_stock_divident: 33,
            price_tax_year: 33,
            rental_property_income: false,
            stock_divident: false,
            userId: \"#{user.id}\"
          }
        )
        {
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
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateIndividualTaxReturn"]

      assert updated["id"]                              == struct.id
      assert updated["foreign_account"]                 == false
      assert updated["home_owner"]                      == false
      assert updated["living_abroad"]                   == false
      assert updated["non_resident_earning"]            == false
      assert updated["none_expat"]                      == false
      assert updated["own_stock_crypto"]                == false
      assert updated["price_foreign_account"]           == 33
      assert updated["price_home_owner"]                == 33
      assert updated["price_living_abroad"]             == 33
      assert updated["price_non_resident_earning"]      == 33
      assert updated["price_own_stock_crypto"]          == 33
      assert updated["price_rental_property_income"]    == 33
      assert updated["price_sole_proprietorship_count"] == 33
      assert updated["price_state"]                     == 33
      assert updated["price_stock_divident"]            == 33
      assert updated["price_tax_year"]                  == 33
      assert updated["rental_property_income"]          == false
      assert updated["stock_divident"]                  == false
      assert updated["user"]["id"]                      == user.id
      assert updated["user"]["email"]                   == user.email
      assert updated["user"]["role"]                    == user.role
    end
  end

  describe "#delete" do
    it "delete specific IndividualTaxReturn" do
      user = insert(:user)
      struct = insert(:individual_tax_return, %{user: user})
      insert(:individual_employment_status, individual_tax_returns: struct)
      insert(:individual_filing_status, individual_tax_returns: struct)
      insert(:individual_foreign_account_count, individual_tax_returns: struct)
      insert(:individual_industry, individual_tax_returns: struct)
      insert(:individual_itemized_deduction, individual_tax_returns: struct)
      insert(:individual_stock_transaction_count, individual_tax_returns: struct)

      mutation = """
      {
        deleteIndividualTaxReturn(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteIndividualTaxReturn"]
      assert deleted["id"] == struct.id
    end
  end

  describe "#dataloads" do
    it "created IndividualTaxReturn" do
      user = insert(:user)
      struct = %{id: id} = insert(:individual_tax_return, %{user: user})
      insert(:individual_employment_status, individual_tax_returns: struct)
      insert(:individual_filing_status, individual_tax_returns: struct)
      insert(:individual_foreign_account_count, individual_tax_returns: struct)
      insert(:individual_industry, individual_tax_returns: struct)
      insert(:individual_itemized_deduction, individual_tax_returns: struct)
      insert(:individual_stock_transaction_count, individual_tax_returns: struct)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:individual_tax_returns, source)
        |> Dataloader.load(:individual_tax_returns, Core.Services.IndividualTaxReturn, id)
        |> Dataloader.run

      data = Dataloader.get(loader, :individual_tax_returns, Core.Services.IndividualTaxReturn, id)

      assert data.id == id
    end
  end

  @spec format_deadline(Date.t()) :: String.t()
  defp format_deadline(data), do: to_string(data)
end

defmodule ServerWeb.GraphQL.Integration.Products.IndividualItemizedDeductionIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns IndividualItemizedDeduction by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      struct = insert(:tp_individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        allIndividualItemizedDeductions {
          id
          name
          price
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allIndividualItemizedDeductions"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allIndividualItemizedDeductions"]

      assert List.first(data)["id"]                                                   == struct.id
      assert List.first(data)["name"]                                                 == format_field(struct.name)
      assert List.first(data)["price"]                                                == nil
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

      {:ok, %{data: %{"allIndividualItemizedDeductions" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                                   == struct.id
      assert first["name"]                                                 == format_field(struct.name)
      assert first["price"]                                                == nil
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

    it "returns IndividualItemizedDeduction by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      struct = insert(:pro_individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        allIndividualItemizedDeductions {
          id
          name
          price
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allIndividualItemizedDeductions"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allIndividualItemizedDeductions"]

      assert List.first(data)["id"]                                                        == struct.id
      assert List.first(data)["name"]                                                      == format_field(struct.name)
      assert List.first(data)["price"]                                                     == struct.price
      assert List.first(data)["individual_tax_returns"]["id"]                              == struct.individual_tax_returns.id
      assert List.first(data)["individual_tax_returns"]["foreign_account"]                 == struct.individual_tax_returns.foreign_account
      assert List.first(data)["individual_tax_returns"]["home_owner"]                      == struct.individual_tax_returns.home_owner
      assert List.first(data)["individual_tax_returns"]["living_abroad"]                   == struct.individual_tax_returns.living_abroad
      assert List.first(data)["individual_tax_returns"]["non_resident_earning"]            == struct.individual_tax_returns.non_resident_earning
      assert List.first(data)["individual_tax_returns"]["none_expat"]                      == struct.individual_tax_returns.none_expat
      assert List.first(data)["individual_tax_returns"]["own_stock_crypto"]                == struct.individual_tax_returns.own_stock_crypto
      assert List.first(data)["individual_tax_returns"]["price_foreign_account"]           == struct.individual_tax_returns.price_foreign_account
      assert List.first(data)["individual_tax_returns"]["price_home_owner"]                == struct.individual_tax_returns.price_home_owner
      assert List.first(data)["individual_tax_returns"]["price_living_abroad"]             == struct.individual_tax_returns.price_living_abroad
      assert List.first(data)["individual_tax_returns"]["price_non_resident_earning"]      == struct.individual_tax_returns.price_non_resident_earning
      assert List.first(data)["individual_tax_returns"]["price_own_stock_crypto"]          == struct.individual_tax_returns.price_own_stock_crypto
      assert List.first(data)["individual_tax_returns"]["price_rental_property_income"]    == struct.individual_tax_returns.price_rental_property_income
      assert List.first(data)["individual_tax_returns"]["price_sole_proprietorship_count"] == struct.individual_tax_returns.price_sole_proprietorship_count
      assert List.first(data)["individual_tax_returns"]["price_state"]                     == struct.individual_tax_returns.price_state
      assert List.first(data)["individual_tax_returns"]["price_stock_divident"]            == struct.individual_tax_returns.price_stock_divident
      assert List.first(data)["individual_tax_returns"]["price_tax_year"]                  == struct.individual_tax_returns.price_tax_year
      assert List.first(data)["individual_tax_returns"]["rental_property_income"]          == struct.individual_tax_returns.rental_property_income
      assert List.first(data)["individual_tax_returns"]["stock_divident"]                  == struct.individual_tax_returns.stock_divident
      assert List.first(data)["individual_tax_returns"]["user"]["id"]                      == user.id
      assert List.first(data)["individual_tax_returns"]["user"]["email"]                   == user.email
      assert List.first(data)["individual_tax_returns"]["user"]["role"]                    == user.role

      {:ok, %{data: %{"allIndividualItemizedDeductions" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                                        == struct.id
      assert first["name"]                                                      == format_field(struct.name)
      assert first["price"]                                                     == struct.price
      assert first["individual_tax_returns"]["id"]                              == struct.individual_tax_returns.id
      assert first["individual_tax_returns"]["foreign_account"]                 == struct.individual_tax_returns.foreign_account
      assert first["individual_tax_returns"]["home_owner"]                      == struct.individual_tax_returns.home_owner
      assert first["individual_tax_returns"]["living_abroad"]                   == struct.individual_tax_returns.living_abroad
      assert first["individual_tax_returns"]["non_resident_earning"]            == struct.individual_tax_returns.non_resident_earning
      assert first["individual_tax_returns"]["none_expat"]                      == struct.individual_tax_returns.none_expat
      assert first["individual_tax_returns"]["own_stock_crypto"]                == struct.individual_tax_returns.own_stock_crypto
      assert first["individual_tax_returns"]["price_foreign_account"]           == struct.individual_tax_returns.price_foreign_account
      assert first["individual_tax_returns"]["price_home_owner"]                == struct.individual_tax_returns.price_home_owner
      assert first["individual_tax_returns"]["price_living_abroad"]             == struct.individual_tax_returns.price_living_abroad
      assert first["individual_tax_returns"]["price_non_resident_earning"]      == struct.individual_tax_returns.price_non_resident_earning
      assert first["individual_tax_returns"]["price_own_stock_crypto"]          == struct.individual_tax_returns.price_own_stock_crypto
      assert first["individual_tax_returns"]["price_rental_property_income"]    == struct.individual_tax_returns.price_rental_property_income
      assert first["individual_tax_returns"]["price_sole_proprietorship_count"] == struct.individual_tax_returns.price_sole_proprietorship_count
      assert first["individual_tax_returns"]["price_state"]                     == struct.individual_tax_returns.price_state
      assert first["individual_tax_returns"]["price_stock_divident"]            == struct.individual_tax_returns.price_stock_divident
      assert first["individual_tax_returns"]["price_tax_year"]                  == struct.individual_tax_returns.price_tax_year
      assert first["individual_tax_returns"]["rental_property_income"]          == struct.individual_tax_returns.rental_property_income
      assert first["individual_tax_returns"]["stock_divident"]                  == struct.individual_tax_returns.stock_divident
      assert first["individual_tax_returns"]["user"]["id"]                      == user.id
      assert first["individual_tax_returns"]["user"]["email"]                   == user.email
      assert first["individual_tax_returns"]["user"]["role"]                    == user.role
    end
  end

  describe "#show" do
    it "returns specific IndividualItemizedDeduction by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      struct = insert(:tp_individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        showIndividualItemizedDeduction(id: \"#{struct.id}\") {
          id
          name
          price
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

      {:ok, %{data: %{"showIndividualItemizedDeduction" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                                   == struct.id
      assert found["name"]                                                 == format_field(struct.name)
      assert found["price"]                                                == nil
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showIndividualItemizedDeduction"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showIndividualItemizedDeduction"]

      assert found["id"]                                                   == struct.id
      assert found["name"]                                                 == format_field(struct.name)
      assert found["price"]                                                == nil
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

    it "returns specific IndividualItemizedDeduction by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      struct = insert(:pro_individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        showIndividualItemizedDeduction(id: \"#{struct.id}\") {
          id
          name
          price
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

      {:ok, %{data: %{"showIndividualItemizedDeduction" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                                        == struct.id
      assert found["name"]                                                      == format_field(struct.name)
      assert found["price"]                                                     == struct.price
      assert found["individual_tax_returns"]["id"]                              == struct.individual_tax_returns.id
      assert found["individual_tax_returns"]["foreign_account"]                 == struct.individual_tax_returns.foreign_account
      assert found["individual_tax_returns"]["home_owner"]                      == struct.individual_tax_returns.home_owner
      assert found["individual_tax_returns"]["living_abroad"]                   == struct.individual_tax_returns.living_abroad
      assert found["individual_tax_returns"]["non_resident_earning"]            == struct.individual_tax_returns.non_resident_earning
      assert found["individual_tax_returns"]["none_expat"]                      == struct.individual_tax_returns.none_expat
      assert found["individual_tax_returns"]["own_stock_crypto"]                == struct.individual_tax_returns.own_stock_crypto
      assert found["individual_tax_returns"]["price_foreign_account"]           == struct.individual_tax_returns.price_foreign_account
      assert found["individual_tax_returns"]["price_home_owner"]                == struct.individual_tax_returns.price_home_owner
      assert found["individual_tax_returns"]["price_living_abroad"]             == struct.individual_tax_returns.price_living_abroad
      assert found["individual_tax_returns"]["price_non_resident_earning"]      == struct.individual_tax_returns.price_non_resident_earning
      assert found["individual_tax_returns"]["price_own_stock_crypto"]          == struct.individual_tax_returns.price_own_stock_crypto
      assert found["individual_tax_returns"]["price_rental_property_income"]    == struct.individual_tax_returns.price_rental_property_income
      assert found["individual_tax_returns"]["price_sole_proprietorship_count"] == struct.individual_tax_returns.price_sole_proprietorship_count
      assert found["individual_tax_returns"]["price_state"]                     == struct.individual_tax_returns.price_state
      assert found["individual_tax_returns"]["price_stock_divident"]            == struct.individual_tax_returns.price_stock_divident
      assert found["individual_tax_returns"]["price_tax_year"]                  == struct.individual_tax_returns.price_tax_year
      assert found["individual_tax_returns"]["rental_property_income"]          == struct.individual_tax_returns.rental_property_income
      assert found["individual_tax_returns"]["stock_divident"]                  == struct.individual_tax_returns.stock_divident
      assert found["individual_tax_returns"]["user"]["id"]                      == user.id
      assert found["individual_tax_returns"]["user"]["email"]                   == user.email
      assert found["individual_tax_returns"]["user"]["role"]                    == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showIndividualItemizedDeduction"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showIndividualItemizedDeduction"]

      assert found["id"]                                                        == struct.id
      assert found["name"]                                                      == format_field(struct.name)
      assert found["price"]                                                     == struct.price
      assert found["individual_tax_returns"]["id"]                              == struct.individual_tax_returns.id
      assert found["individual_tax_returns"]["foreign_account"]                 == struct.individual_tax_returns.foreign_account
      assert found["individual_tax_returns"]["home_owner"]                      == struct.individual_tax_returns.home_owner
      assert found["individual_tax_returns"]["living_abroad"]                   == struct.individual_tax_returns.living_abroad
      assert found["individual_tax_returns"]["non_resident_earning"]            == struct.individual_tax_returns.non_resident_earning
      assert found["individual_tax_returns"]["none_expat"]                      == struct.individual_tax_returns.none_expat
      assert found["individual_tax_returns"]["own_stock_crypto"]                == struct.individual_tax_returns.own_stock_crypto
      assert found["individual_tax_returns"]["price_foreign_account"]           == struct.individual_tax_returns.price_foreign_account
      assert found["individual_tax_returns"]["price_home_owner"]                == struct.individual_tax_returns.price_home_owner
      assert found["individual_tax_returns"]["price_living_abroad"]             == struct.individual_tax_returns.price_living_abroad
      assert found["individual_tax_returns"]["price_non_resident_earning"]      == struct.individual_tax_returns.price_non_resident_earning
      assert found["individual_tax_returns"]["price_own_stock_crypto"]          == struct.individual_tax_returns.price_own_stock_crypto
      assert found["individual_tax_returns"]["price_rental_property_income"]    == struct.individual_tax_returns.price_rental_property_income
      assert found["individual_tax_returns"]["price_sole_proprietorship_count"] == struct.individual_tax_returns.price_sole_proprietorship_count
      assert found["individual_tax_returns"]["price_state"]                     == struct.individual_tax_returns.price_state
      assert found["individual_tax_returns"]["price_stock_divident"]            == struct.individual_tax_returns.price_stock_divident
      assert found["individual_tax_returns"]["price_tax_year"]                  == struct.individual_tax_returns.price_tax_year
      assert found["individual_tax_returns"]["rental_property_income"]          == struct.individual_tax_returns.rental_property_income
      assert found["individual_tax_returns"]["stock_divident"]                  == struct.individual_tax_returns.stock_divident
      assert found["individual_tax_returns"]["user"]["id"]                      == user.id
      assert found["individual_tax_returns"]["user"]["email"]                   == user.email
      assert found["individual_tax_returns"]["user"]["role"]                    == user.role
    end
  end

  describe "#find" do
    it "returns specific IndividualItemizedDeduction by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      struct = insert(:tp_individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        findIndividualItemizedDeduction(id: \"#{struct.id}\") {
          id
          name
          price
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

      {:ok, %{data: %{"findIndividualItemizedDeduction" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                                   == struct.id
      assert found["name"]                                                 == format_field(struct.name)
      assert found["price"]                                                == nil
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualItemizedDeduction"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualItemizedDeduction"]

      assert found["id"]                                                   == struct.id
      assert found["name"]                                                 == format_field(struct.name)
      assert found["price"]                                                == nil
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

    it "returns specific IndividualItemizedDeduction by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      struct = insert(:pro_individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{current_user: user}

      query = """
      {
        findIndividualItemizedDeduction(id: \"#{struct.id}\") {
          id
          name
          price
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

      {:ok, %{data: %{"findIndividualItemizedDeduction" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                                        == struct.id
      assert found["name"]                                                      == format_field(struct.name)
      assert found["price"]                                                     == struct.price
      assert found["individual_tax_returns"]["id"]                              == struct.individual_tax_returns.id
      assert found["individual_tax_returns"]["foreign_account"]                 == struct.individual_tax_returns.foreign_account
      assert found["individual_tax_returns"]["home_owner"]                      == struct.individual_tax_returns.home_owner
      assert found["individual_tax_returns"]["living_abroad"]                   == struct.individual_tax_returns.living_abroad
      assert found["individual_tax_returns"]["non_resident_earning"]            == struct.individual_tax_returns.non_resident_earning
      assert found["individual_tax_returns"]["none_expat"]                      == struct.individual_tax_returns.none_expat
      assert found["individual_tax_returns"]["own_stock_crypto"]                == struct.individual_tax_returns.own_stock_crypto
      assert found["individual_tax_returns"]["price_foreign_account"]           == struct.individual_tax_returns.price_foreign_account
      assert found["individual_tax_returns"]["price_home_owner"]                == struct.individual_tax_returns.price_home_owner
      assert found["individual_tax_returns"]["price_living_abroad"]             == struct.individual_tax_returns.price_living_abroad
      assert found["individual_tax_returns"]["price_non_resident_earning"]      == struct.individual_tax_returns.price_non_resident_earning
      assert found["individual_tax_returns"]["price_own_stock_crypto"]          == struct.individual_tax_returns.price_own_stock_crypto
      assert found["individual_tax_returns"]["price_rental_property_income"]    == struct.individual_tax_returns.price_rental_property_income
      assert found["individual_tax_returns"]["price_sole_proprietorship_count"] == struct.individual_tax_returns.price_sole_proprietorship_count
      assert found["individual_tax_returns"]["price_state"]                     == struct.individual_tax_returns.price_state
      assert found["individual_tax_returns"]["price_stock_divident"]            == struct.individual_tax_returns.price_stock_divident
      assert found["individual_tax_returns"]["price_tax_year"]                  == struct.individual_tax_returns.price_tax_year
      assert found["individual_tax_returns"]["rental_property_income"]          == struct.individual_tax_returns.rental_property_income
      assert found["individual_tax_returns"]["stock_divident"]                  == struct.individual_tax_returns.stock_divident
      assert found["individual_tax_returns"]["user"]["id"]                      == user.id
      assert found["individual_tax_returns"]["user"]["email"]                   == user.email
      assert found["individual_tax_returns"]["user"]["role"]                    == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualItemizedDeduction"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualItemizedDeduction"]

      assert found["id"]                                                        == struct.id
      assert found["name"]                                                      == format_field(struct.name)
      assert found["price"]                                                     == struct.price
      assert found["individual_tax_returns"]["id"]                              == struct.individual_tax_returns.id
      assert found["individual_tax_returns"]["foreign_account"]                 == struct.individual_tax_returns.foreign_account
      assert found["individual_tax_returns"]["home_owner"]                      == struct.individual_tax_returns.home_owner
      assert found["individual_tax_returns"]["living_abroad"]                   == struct.individual_tax_returns.living_abroad
      assert found["individual_tax_returns"]["non_resident_earning"]            == struct.individual_tax_returns.non_resident_earning
      assert found["individual_tax_returns"]["none_expat"]                      == struct.individual_tax_returns.none_expat
      assert found["individual_tax_returns"]["own_stock_crypto"]                == struct.individual_tax_returns.own_stock_crypto
      assert found["individual_tax_returns"]["price_foreign_account"]           == struct.individual_tax_returns.price_foreign_account
      assert found["individual_tax_returns"]["price_home_owner"]                == struct.individual_tax_returns.price_home_owner
      assert found["individual_tax_returns"]["price_living_abroad"]             == struct.individual_tax_returns.price_living_abroad
      assert found["individual_tax_returns"]["price_non_resident_earning"]      == struct.individual_tax_returns.price_non_resident_earning
      assert found["individual_tax_returns"]["price_own_stock_crypto"]          == struct.individual_tax_returns.price_own_stock_crypto
      assert found["individual_tax_returns"]["price_rental_property_income"]    == struct.individual_tax_returns.price_rental_property_income
      assert found["individual_tax_returns"]["price_sole_proprietorship_count"] == struct.individual_tax_returns.price_sole_proprietorship_count
      assert found["individual_tax_returns"]["price_state"]                     == struct.individual_tax_returns.price_state
      assert found["individual_tax_returns"]["price_stock_divident"]            == struct.individual_tax_returns.price_stock_divident
      assert found["individual_tax_returns"]["price_tax_year"]                  == struct.individual_tax_returns.price_tax_year
      assert found["individual_tax_returns"]["rental_property_income"]          == struct.individual_tax_returns.rental_property_income
      assert found["individual_tax_returns"]["stock_divident"]                  == struct.individual_tax_returns.stock_divident
      assert found["individual_tax_returns"]["user"]["id"]                      == user.id
      assert found["individual_tax_returns"]["user"]["email"]                   == user.email
      assert found["individual_tax_returns"]["user"]["role"]                    == user.role
    end
  end

  describe "#create" do
    it "created IndividualItemizedDeduction by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})

      mutation = """
      {
        createIndividualItemizedDeduction(
          name: "Charitable contributions",
          individual_tax_returnId: \"#{individual_tax_return.id}\"
        ) {
          id
          name
          price
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

      created = json_response(res, 200)["data"]["createIndividualItemizedDeduction"]

      assert created["name"]                                                 == "Charitable contributions"
      assert created["price"]                                                == nil
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

    it "created IndividualItemizedDeduction by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})

      mutation = """
      {
        createIndividualItemizedDeduction(
          name: "Charitable contributions",
          price: 22,
          individual_tax_returnId: \"#{individual_tax_return.id}\"
        ) {
          id
          name
          price
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

      created = json_response(res, 200)["data"]["createIndividualItemizedDeduction"]

      assert created["name"]                                                      == "Charitable contributions"
      assert created["price"]                                                     == 22
      assert created["individual_tax_returns"]["id"]                              == individual_tax_return.id
      assert created["individual_tax_returns"]["foreign_account"]                 == individual_tax_return.foreign_account
      assert created["individual_tax_returns"]["home_owner"]                      == individual_tax_return.home_owner
      assert created["individual_tax_returns"]["living_abroad"]                   == individual_tax_return.living_abroad
      assert created["individual_tax_returns"]["non_resident_earning"]            == individual_tax_return.non_resident_earning
      assert created["individual_tax_returns"]["none_expat"]                      == individual_tax_return.none_expat
      assert created["individual_tax_returns"]["own_stock_crypto"]                == individual_tax_return.own_stock_crypto
      assert created["individual_tax_returns"]["price_foreign_account"]           == individual_tax_return.price_foreign_account
      assert created["individual_tax_returns"]["price_home_owner"]                == individual_tax_return.price_home_owner
      assert created["individual_tax_returns"]["price_living_abroad"]             == individual_tax_return.price_living_abroad
      assert created["individual_tax_returns"]["price_non_resident_earning"]      == individual_tax_return.price_non_resident_earning
      assert created["individual_tax_returns"]["price_own_stock_crypto"]          == individual_tax_return.price_own_stock_crypto
      assert created["individual_tax_returns"]["price_rental_property_income"]    == individual_tax_return.price_rental_property_income
      assert created["individual_tax_returns"]["price_sole_proprietorship_count"] == individual_tax_return.price_sole_proprietorship_count
      assert created["individual_tax_returns"]["price_state"]                     == individual_tax_return.price_state
      assert created["individual_tax_returns"]["price_stock_divident"]            == individual_tax_return.price_stock_divident
      assert created["individual_tax_returns"]["price_tax_year"]                  == individual_tax_return.price_tax_year
      assert created["individual_tax_returns"]["rental_property_income"]          == individual_tax_return.rental_property_income
      assert created["individual_tax_returns"]["stock_divident"]                  == individual_tax_return.stock_divident
      assert created["individual_tax_returns"]["user"]["id"]                      == user.id
      assert created["individual_tax_returns"]["user"]["email"]                   == user.email
      assert created["individual_tax_returns"]["user"]["role"]                    == user.role
    end
  end

  describe "#update" do
    it "updated specific IndividualItemizedDeduction by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      struct = insert(:tp_individual_itemized_deduction, %{name: "Charitable contributions", individual_tax_returns: individual_tax_return})

      mutation = """
      {
        updateIndividualItemizedDeduction(
          id: \"#{struct.id}\",
          IndividualItemizedDeduction: {
            name: "Medical and dental expenses",
            individual_tax_returnId: \"#{individual_tax_return.id}\"
          }
        )
        {
          id
          name
          price
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

      updated = json_response(res, 200)["data"]["updateIndividualItemizedDeduction"]

      assert updated["id"]                                                   == struct.id
      assert updated["name"]                                                 == "Medical and dental expenses"
      assert updated["price"]                                                == nil
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

    it "updated specific IndividualItemizedDeduction by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      struct = insert(:pro_individual_itemized_deduction, %{name: "Charitable contributions", individual_tax_returns: individual_tax_return})

      mutation = """
      {
        updateIndividualItemizedDeduction(
          id: \"#{struct.id}\",
          IndividualItemizedDeduction: {
            name: "Medical and dental expenses",
            price: 33,
            individual_tax_returnId: \"#{individual_tax_return.id}\"
          }
        )
        {
          id
          name
          price
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

      updated = json_response(res, 200)["data"]["updateIndividualItemizedDeduction"]

      assert updated["id"]                                                        == struct.id
      assert updated["name"]                                                      == "Medical and dental expenses"
      assert updated["price"]                                                     == 33
      assert updated["individual_tax_returns"]["id"]                              == struct.individual_tax_returns.id
      assert updated["individual_tax_returns"]["foreign_account"]                 == struct.individual_tax_returns.foreign_account
      assert updated["individual_tax_returns"]["home_owner"]                      == struct.individual_tax_returns.home_owner
      assert updated["individual_tax_returns"]["living_abroad"]                   == struct.individual_tax_returns.living_abroad
      assert updated["individual_tax_returns"]["non_resident_earning"]            == struct.individual_tax_returns.non_resident_earning
      assert updated["individual_tax_returns"]["none_expat"]                      == struct.individual_tax_returns.none_expat
      assert updated["individual_tax_returns"]["own_stock_crypto"]                == struct.individual_tax_returns.own_stock_crypto
      assert updated["individual_tax_returns"]["price_foreign_account"]           == struct.individual_tax_returns.price_foreign_account
      assert updated["individual_tax_returns"]["price_home_owner"]                == struct.individual_tax_returns.price_home_owner
      assert updated["individual_tax_returns"]["price_living_abroad"]             == struct.individual_tax_returns.price_living_abroad
      assert updated["individual_tax_returns"]["price_non_resident_earning"]      == struct.individual_tax_returns.price_non_resident_earning
      assert updated["individual_tax_returns"]["price_own_stock_crypto"]          == struct.individual_tax_returns.price_own_stock_crypto
      assert updated["individual_tax_returns"]["price_rental_property_income"]    == struct.individual_tax_returns.price_rental_property_income
      assert updated["individual_tax_returns"]["price_sole_proprietorship_count"] == struct.individual_tax_returns.price_sole_proprietorship_count
      assert updated["individual_tax_returns"]["price_state"]                     == struct.individual_tax_returns.price_state
      assert updated["individual_tax_returns"]["price_stock_divident"]            == struct.individual_tax_returns.price_stock_divident
      assert updated["individual_tax_returns"]["price_tax_year"]                  == struct.individual_tax_returns.price_tax_year
      assert updated["individual_tax_returns"]["rental_property_income"]          == struct.individual_tax_returns.rental_property_income
      assert updated["individual_tax_returns"]["stock_divident"]                  == struct.individual_tax_returns.stock_divident
      assert updated["individual_tax_returns"]["user"]["id"]                      == user.id
      assert updated["individual_tax_returns"]["user"]["email"]                   == user.email
      assert updated["individual_tax_returns"]["user"]["role"]                    == user.role
    end
  end

  describe "#delete" do
    it "delete specific IndividualItemizedDeduction" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, %{user: user})
      struct = insert(:individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})

      mutation = """
      {
        deleteIndividualItemizedDeduction(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteIndividualItemizedDeduction"]
      assert deleted["id"] == struct.id
    end
  end

  describe "#dataloads" do
    it "created IndividualItemizedDeduction" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, %{user: user})
      %{id: id} = insert(:individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:individual_itemized_deductions, source)
        |> Dataloader.load(:individual_itemized_deductions, Core.Services.IndividualItemizedDeduction, id)
        |> Dataloader.run

      data = Dataloader.get(loader, :individual_itemized_deductions, Core.Services.IndividualItemizedDeduction, id)

      assert data.id == id
    end
  end

  @spec format_field(atom()) :: String.t()
  defp format_field(data), do: to_string(data)

  @spec format_deadline(Date.t()) :: String.t()
  defp format_deadline(data), do: to_string(data)
end

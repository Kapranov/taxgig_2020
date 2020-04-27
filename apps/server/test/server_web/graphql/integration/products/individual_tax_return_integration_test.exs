defmodule ServerWeb.GraphQL.Integration.Products.IndividualTaxReturnIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns IndividualTaxReturn by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      context = %{current_user: user}

      query = """
      {
        allIndividualTaxReturns {
          id
          foreign_account
          foreign_account_limit
          foreign_financial_interest
          home_owner
          inserted_at
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
          updated_at
          user {
            id
            active
            avatar
            bio
            birthday
            email
            first_name
            init_setup
            last_name
            middle_name
            phone
            provider
            role
            sex
            ssn
            street
            zip
            inserted_at
            updated_at
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allIndividualTaxReturns"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allIndividualTaxReturns"]

      assert List.first(data)["id"]                             == individual_tax_return.id
      assert List.first(data)["foreign_account"]                == individual_tax_return.foreign_account
      assert List.first(data)["foreign_account_limit"]          == individual_tax_return.foreign_account_limit
      assert List.first(data)["foreign_financial_interest"]     == individual_tax_return.foreign_financial_interest
      assert List.first(data)["home_owner"]                     == individual_tax_return.home_owner
      assert List.first(data)["inserted_at"]                    == formatting_time(individual_tax_return.inserted_at)
      assert List.first(data)["k1_count"]                       == individual_tax_return.k1_count
      assert List.first(data)["k1_income"]                      == individual_tax_return.k1_income
      assert List.first(data)["living_abroad"]                  == individual_tax_return.living_abroad
      assert List.first(data)["non_resident_earning"]           == individual_tax_return.non_resident_earning
      assert List.first(data)["none_expat"]                     == individual_tax_return.none_expat
      assert List.first(data)["own_stock_crypto"]               == individual_tax_return.own_stock_crypto
      assert List.first(data)["rental_property_count"]          == individual_tax_return.rental_property_count
      assert List.first(data)["rental_property_income"]         == individual_tax_return.rental_property_income
      assert List.first(data)["sole_proprietorship_count"]      == individual_tax_return.sole_proprietorship_count
      assert List.first(data)["state"]                          == individual_tax_return.state
      assert List.first(data)["stock_divident"]                 == individual_tax_return.stock_divident
      assert List.first(data)["tax_year"]                       == individual_tax_return.tax_year
      assert List.first(data)["updated_at"]                     == formatting_time(individual_tax_return.updated_at)
      assert List.first(data)["user"]["id"]                     == individual_tax_return.user.id
      assert List.first(data)["user"]["active"]                 == individual_tax_return.user.active
      assert List.first(data)["user"]["avatar"]                 == individual_tax_return.user.avatar
      assert List.first(data)["user"]["bio"]                    == individual_tax_return.user.bio
      assert List.first(data)["user"]["birthday"]               == to_string(individual_tax_return.user.birthday)
      assert List.first(data)["user"]["email"]                  == individual_tax_return.user.email
      assert List.first(data)["user"]["first_name"]             == individual_tax_return.user.first_name
      assert List.first(data)["user"]["init_setup"]             == individual_tax_return.user.init_setup
      assert List.first(data)["user"]["last_name"]              == individual_tax_return.user.last_name
      assert List.first(data)["user"]["middle_name"]            == individual_tax_return.user.middle_name
      assert List.first(data)["user"]["phone"]                  == individual_tax_return.user.phone
      assert List.first(data)["user"]["provider"]               == individual_tax_return.user.provider
      assert List.first(data)["user"]["role"]                   == individual_tax_return.user.role
      assert List.first(data)["user"]["sex"]                    == individual_tax_return.user.sex
      assert List.first(data)["user"]["ssn"]                    == individual_tax_return.user.ssn
      assert List.first(data)["user"]["street"]                 == individual_tax_return.user.street
      assert List.first(data)["user"]["zip"]                    == individual_tax_return.user.zip
      assert List.first(data)["user"]["inserted_at"]            == formatting_time(individual_tax_return.user.inserted_at)
      assert List.first(data)["user"]["updated_at"]             == formatting_time(individual_tax_return.user.updated_at)

      {:ok, %{data: %{"allIndividualTaxReturns" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                             == individual_tax_return.id
      assert first["foreign_account"]                == individual_tax_return.foreign_account
      assert first["foreign_account_limit"]          == individual_tax_return.foreign_account_limit
      assert first["foreign_financial_interest"]     == individual_tax_return.foreign_financial_interest
      assert first["home_owner"]                     == individual_tax_return.home_owner
      assert first["inserted_at"]                    == formatting_time(individual_tax_return.inserted_at)
      assert first["k1_count"]                       == individual_tax_return.k1_count
      assert first["k1_income"]                      == individual_tax_return.k1_income
      assert first["living_abroad"]                  == individual_tax_return.living_abroad
      assert first["non_resident_earning"]           == individual_tax_return.non_resident_earning
      assert first["none_expat"]                     == individual_tax_return.none_expat
      assert first["own_stock_crypto"]               == individual_tax_return.own_stock_crypto
      assert first["rental_property_count"]          == individual_tax_return.rental_property_count
      assert first["rental_property_income"]         == individual_tax_return.rental_property_income
      assert first["sole_proprietorship_count"]      == individual_tax_return.sole_proprietorship_count
      assert first["state"]                          == individual_tax_return.state
      assert first["stock_divident"]                 == individual_tax_return.stock_divident
      assert first["tax_year"]                       == individual_tax_return.tax_year
      assert first["updated_at"]                     == formatting_time(individual_tax_return.updated_at)
      assert first["user"]["id"]                     == individual_tax_return.user.id
      assert first["user"]["active"]                 == individual_tax_return.user.active
      assert first["user"]["avatar"]                 == individual_tax_return.user.avatar
      assert first["user"]["bio"]                    == individual_tax_return.user.bio
      assert first["user"]["birthday"]               == to_string(individual_tax_return.user.birthday)
      assert first["user"]["email"]                  == individual_tax_return.user.email
      assert first["user"]["first_name"]             == individual_tax_return.user.first_name
      assert first["user"]["init_setup"]             == individual_tax_return.user.init_setup
      assert first["user"]["last_name"]              == individual_tax_return.user.last_name
      assert first["user"]["middle_name"]            == individual_tax_return.user.middle_name
      assert first["user"]["phone"]                  == individual_tax_return.user.phone
      assert first["user"]["provider"]               == individual_tax_return.user.provider
      assert first["user"]["role"]                   == individual_tax_return.user.role
      assert first["user"]["sex"]                    == individual_tax_return.user.sex
      assert first["user"]["ssn"]                    == individual_tax_return.user.ssn
      assert first["user"]["street"]                 == individual_tax_return.user.street
      assert first["user"]["zip"]                    == individual_tax_return.user.zip
      assert first["user"]["inserted_at"]            == formatting_time(individual_tax_return.user.inserted_at)
      assert first["user"]["updated_at"]             == formatting_time(individual_tax_return.user.updated_at)
    end

    it "returns IndividualTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      context = %{current_user: user}

      query = """
      {
        allIndividualTaxReturns {
          id
          foreign_account
          home_owner
          inserted_at
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
          updated_at
          user {
            id
            active
            avatar
            bio
            birthday
            email
            first_name
            init_setup
            last_name
            middle_name
            phone
            provider
            role
            sex
            ssn
            street
            zip
            inserted_at
            updated_at
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allIndividualTaxReturns"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allIndividualTaxReturns"]

      assert List.first(data)["id"]                              == individual_tax_return.id
      assert List.first(data)["foreign_account"]                 == individual_tax_return.foreign_account
      assert List.first(data)["home_owner"]                      == individual_tax_return.home_owner
      assert List.first(data)["inserted_at"]                     == formatting_time(individual_tax_return.inserted_at)
      assert List.first(data)["living_abroad"]                   == individual_tax_return.living_abroad
      assert List.first(data)["non_resident_earning"]            == individual_tax_return.non_resident_earning
      assert List.first(data)["none_expat"]                      == individual_tax_return.none_expat
      assert List.first(data)["own_stock_crypto"]                == individual_tax_return.own_stock_crypto
      assert List.first(data)["price_foreign_account"]           == individual_tax_return.price_foreign_account
      assert List.first(data)["price_home_owner"]                == individual_tax_return.price_home_owner
      assert List.first(data)["price_living_abroad"]             == individual_tax_return.price_living_abroad
      assert List.first(data)["price_non_resident_earning"]      == individual_tax_return.price_non_resident_earning
      assert List.first(data)["price_own_stock_crypto"]          == individual_tax_return.price_own_stock_crypto
      assert List.first(data)["price_rental_property_income"]    == individual_tax_return.price_rental_property_income
      assert List.first(data)["price_sole_proprietorship_count"] == individual_tax_return.price_sole_proprietorship_count
      assert List.first(data)["price_state"]                     == individual_tax_return.price_state
      assert List.first(data)["price_stock_divident"]            == individual_tax_return.price_stock_divident
      assert List.first(data)["price_tax_year"]                  == individual_tax_return.price_tax_year
      assert List.first(data)["rental_property_income"]          == individual_tax_return.rental_property_income
      assert List.first(data)["stock_divident"]                  == individual_tax_return.stock_divident
      assert List.first(data)["updated_at"]                      == formatting_time(individual_tax_return.updated_at)
      assert List.first(data)["user"]["id"]                      == individual_tax_return.user.id
      assert List.first(data)["user"]["active"]                  == individual_tax_return.user.active
      assert List.first(data)["user"]["avatar"]                  == individual_tax_return.user.avatar
      assert List.first(data)["user"]["bio"]                     == individual_tax_return.user.bio
      assert List.first(data)["user"]["birthday"]                == to_string(individual_tax_return.user.birthday)
      assert List.first(data)["user"]["email"]                   == individual_tax_return.user.email
      assert List.first(data)["user"]["first_name"]              == individual_tax_return.user.first_name
      assert List.first(data)["user"]["init_setup"]              == individual_tax_return.user.init_setup
      assert List.first(data)["user"]["last_name"]               == individual_tax_return.user.last_name
      assert List.first(data)["user"]["middle_name"]             == individual_tax_return.user.middle_name
      assert List.first(data)["user"]["phone"]                   == individual_tax_return.user.phone
      assert List.first(data)["user"]["provider"]                == individual_tax_return.user.provider
      assert List.first(data)["user"]["role"]                    == individual_tax_return.user.role
      assert List.first(data)["user"]["sex"]                     == individual_tax_return.user.sex
      assert List.first(data)["user"]["ssn"]                     == individual_tax_return.user.ssn
      assert List.first(data)["user"]["street"]                  == individual_tax_return.user.street
      assert List.first(data)["user"]["zip"]                     == individual_tax_return.user.zip
      assert List.first(data)["user"]["inserted_at"]             == formatting_time(individual_tax_return.user.inserted_at)
      assert List.first(data)["user"]["updated_at"]              == formatting_time(individual_tax_return.user.updated_at)

      {:ok, %{data: %{"allIndividualTaxReturns" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                              == individual_tax_return.id
      assert first["foreign_account"]                 == individual_tax_return.foreign_account
      assert first["home_owner"]                      == individual_tax_return.home_owner
      assert first["inserted_at"]                     == formatting_time(individual_tax_return.inserted_at)
      assert first["living_abroad"]                   == individual_tax_return.living_abroad
      assert first["non_resident_earning"]            == individual_tax_return.non_resident_earning
      assert first["none_expat"]                      == individual_tax_return.none_expat
      assert first["own_stock_crypto"]                == individual_tax_return.own_stock_crypto
      assert first["price_foreign_account"]           == individual_tax_return.price_foreign_account
      assert first["price_home_owner"]                == individual_tax_return.price_home_owner
      assert first["price_living_abroad"]             == individual_tax_return.price_living_abroad
      assert first["price_non_resident_earning"]      == individual_tax_return.price_non_resident_earning
      assert first["price_own_stock_crypto"]          == individual_tax_return.price_own_stock_crypto
      assert first["price_rental_property_income"]    == individual_tax_return.price_rental_property_income
      assert first["price_sole_proprietorship_count"] == individual_tax_return.price_sole_proprietorship_count
      assert first["price_state"]                     == individual_tax_return.price_state
      assert first["price_stock_divident"]            == individual_tax_return.price_stock_divident
      assert first["price_tax_year"]                  == individual_tax_return.price_tax_year
      assert first["rental_property_income"]          == individual_tax_return.rental_property_income
      assert first["stock_divident"]                  == individual_tax_return.stock_divident
      assert first["updated_at"]                      == formatting_time(individual_tax_return.updated_at)
      assert first["user"]["id"]                      == individual_tax_return.user.id
      assert first["user"]["active"]                  == individual_tax_return.user.active
      assert first["user"]["avatar"]                  == individual_tax_return.user.avatar
      assert first["user"]["bio"]                     == individual_tax_return.user.bio
      assert first["user"]["birthday"]                == to_string(individual_tax_return.user.birthday)
      assert first["user"]["email"]                   == individual_tax_return.user.email
      assert first["user"]["first_name"]              == individual_tax_return.user.first_name
      assert first["user"]["init_setup"]              == individual_tax_return.user.init_setup
      assert first["user"]["last_name"]               == individual_tax_return.user.last_name
      assert first["user"]["middle_name"]             == individual_tax_return.user.middle_name
      assert first["user"]["phone"]                   == individual_tax_return.user.phone
      assert first["user"]["provider"]                == individual_tax_return.user.provider
      assert first["user"]["role"]                    == individual_tax_return.user.role
      assert first["user"]["sex"]                     == individual_tax_return.user.sex
      assert first["user"]["ssn"]                     == individual_tax_return.user.ssn
      assert first["user"]["street"]                  == individual_tax_return.user.street
      assert first["user"]["zip"]                     == individual_tax_return.user.zip
      assert first["user"]["inserted_at"]             == formatting_time(individual_tax_return.user.inserted_at)
      assert first["user"]["updated_at"]              == formatting_time(individual_tax_return.user.updated_at)
    end
  end

  describe "#show" do
    it "returns specific IndividualTaxReturn by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      context = %{current_user: user}

      query = """
      {
        showIndividualTaxReturn(id: \"#{individual_tax_return.id}\") {
          id
          foreign_account
          foreign_account_limit
          foreign_financial_interest
          home_owner
          inserted_at
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
          updated_at
          user {
            id
            active
            avatar
            bio
            birthday
            email
            first_name
            init_setup
            last_name
            middle_name
            phone
            provider
            role
            sex
            ssn
            street
            zip
            inserted_at
            updated_at
          }
        }
      }
      """

      {:ok, %{data: %{"showIndividualTaxReturn" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                              == individual_tax_return.id
      assert found["foreign_account"]                 == individual_tax_return.foreign_account
      assert found["foreign_account_limit"]           == individual_tax_return.foreign_account_limit
      assert found["foreign_financial_interest"]      == individual_tax_return.foreign_financial_interest
      assert found["home_owner"]                      == individual_tax_return.home_owner
      assert found["inserted_at"]                     == formatting_time(individual_tax_return.inserted_at)
      assert found["k1_count"]                        == individual_tax_return.k1_count
      assert found["k1_income"]                       == individual_tax_return.k1_income
      assert found["living_abroad"]                   == individual_tax_return.living_abroad
      assert found["non_resident_earning"]            == individual_tax_return.non_resident_earning
      assert found["none_expat"]                      == individual_tax_return.none_expat
      assert found["own_stock_crypto"]                == individual_tax_return.own_stock_crypto
      assert found["rental_property_count"]           == individual_tax_return.rental_property_count
      assert found["rental_property_income"]          == individual_tax_return.rental_property_income
      assert found["sole_proprietorship_count"]       == individual_tax_return.sole_proprietorship_count
      assert found["state"]                           == individual_tax_return.state
      assert found["stock_divident"]                  == individual_tax_return.stock_divident
      assert found["tax_year"]                        == individual_tax_return.tax_year
      assert found["updated_at"]                      == formatting_time(individual_tax_return.updated_at)
      assert found["user"]["id"]                      == individual_tax_return.user.id
      assert found["user"]["active"]                  == individual_tax_return.user.active
      assert found["user"]["avatar"]                  == individual_tax_return.user.avatar
      assert found["user"]["bio"]                     == individual_tax_return.user.bio
      assert found["user"]["birthday"]                == to_string(individual_tax_return.user.birthday)
      assert found["user"]["email"]                   == individual_tax_return.user.email
      assert found["user"]["first_name"]              == individual_tax_return.user.first_name
      assert found["user"]["init_setup"]              == individual_tax_return.user.init_setup
      assert found["user"]["last_name"]               == individual_tax_return.user.last_name
      assert found["user"]["middle_name"]             == individual_tax_return.user.middle_name
      assert found["user"]["phone"]                   == individual_tax_return.user.phone
      assert found["user"]["provider"]                == individual_tax_return.user.provider
      assert found["user"]["role"]                    == individual_tax_return.user.role
      assert found["user"]["sex"]                     == individual_tax_return.user.sex
      assert found["user"]["ssn"]                     == individual_tax_return.user.ssn
      assert found["user"]["street"]                  == individual_tax_return.user.street
      assert found["user"]["zip"]                     == individual_tax_return.user.zip
      assert found["user"]["inserted_at"]             == formatting_time(individual_tax_return.user.inserted_at)
      assert found["user"]["updated_at"]              == formatting_time(individual_tax_return.user.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showIndividualTaxReturn"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showIndividualTaxReturn"]

      assert found["id"]                              == individual_tax_return.id
      assert found["foreign_account"]                 == individual_tax_return.foreign_account
      assert found["foreign_account_limit"]           == individual_tax_return.foreign_account_limit
      assert found["foreign_financial_interest"]      == individual_tax_return.foreign_financial_interest
      assert found["home_owner"]                      == individual_tax_return.home_owner
      assert found["inserted_at"]                     == formatting_time(individual_tax_return.inserted_at)
      assert found["k1_count"]                        == individual_tax_return.k1_count
      assert found["k1_income"]                       == individual_tax_return.k1_income
      assert found["living_abroad"]                   == individual_tax_return.living_abroad
      assert found["non_resident_earning"]            == individual_tax_return.non_resident_earning
      assert found["none_expat"]                      == individual_tax_return.none_expat
      assert found["own_stock_crypto"]                == individual_tax_return.own_stock_crypto
      assert found["rental_property_count"]           == individual_tax_return.rental_property_count
      assert found["rental_property_income"]          == individual_tax_return.rental_property_income
      assert found["sole_proprietorship_count"]       == individual_tax_return.sole_proprietorship_count
      assert found["state"]                           == individual_tax_return.state
      assert found["stock_divident"]                  == individual_tax_return.stock_divident
      assert found["tax_year"]                        == individual_tax_return.tax_year
      assert found["updated_at"]                      == formatting_time(individual_tax_return.updated_at)
      assert found["user"]["id"]                      == individual_tax_return.user.id
      assert found["user"]["active"]                  == individual_tax_return.user.active
      assert found["user"]["avatar"]                  == individual_tax_return.user.avatar
      assert found["user"]["bio"]                     == individual_tax_return.user.bio
      assert found["user"]["birthday"]                == to_string(individual_tax_return.user.birthday)
      assert found["user"]["email"]                   == individual_tax_return.user.email
      assert found["user"]["first_name"]              == individual_tax_return.user.first_name
      assert found["user"]["init_setup"]              == individual_tax_return.user.init_setup
      assert found["user"]["last_name"]               == individual_tax_return.user.last_name
      assert found["user"]["middle_name"]             == individual_tax_return.user.middle_name
      assert found["user"]["phone"]                   == individual_tax_return.user.phone
      assert found["user"]["provider"]                == individual_tax_return.user.provider
      assert found["user"]["role"]                    == individual_tax_return.user.role
      assert found["user"]["sex"]                     == individual_tax_return.user.sex
      assert found["user"]["ssn"]                     == individual_tax_return.user.ssn
      assert found["user"]["street"]                  == individual_tax_return.user.street
      assert found["user"]["zip"]                     == individual_tax_return.user.zip
      assert found["user"]["inserted_at"]             == formatting_time(individual_tax_return.user.inserted_at)
      assert found["user"]["updated_at"]              == formatting_time(individual_tax_return.user.updated_at)
    end

    it "returns specific IndividualTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      context = %{current_user: user}

      query = """
      {
        showIndividualTaxReturn(id: \"#{individual_tax_return.id}\") {
          id
          foreign_account
          home_owner
          inserted_at
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
          updated_at
          user {
            id
            active
            avatar
            bio
            birthday
            email
            first_name
            init_setup
            last_name
            middle_name
            phone
            provider
            role
            sex
            ssn
            street
            zip
            inserted_at
            updated_at
          }
        }
      }
      """

      {:ok, %{data: %{"showIndividualTaxReturn" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                              == individual_tax_return.id
      assert found["foreign_account"]                 == individual_tax_return.foreign_account
      assert found["home_owner"]                      == individual_tax_return.home_owner
      assert found["inserted_at"]                     == formatting_time(individual_tax_return.inserted_at)
      assert found["living_abroad"]                   == individual_tax_return.living_abroad
      assert found["non_resident_earning"]            == individual_tax_return.non_resident_earning
      assert found["none_expat"]                      == individual_tax_return.none_expat
      assert found["own_stock_crypto"]                == individual_tax_return.own_stock_crypto
      assert found["price_foreign_account"]           == individual_tax_return.price_foreign_account
      assert found["price_home_owner"]                == individual_tax_return.price_home_owner
      assert found["price_living_abroad"]             == individual_tax_return.price_living_abroad
      assert found["price_non_resident_earning"]      == individual_tax_return.price_non_resident_earning
      assert found["price_own_stock_crypto"]          == individual_tax_return.price_own_stock_crypto
      assert found["price_rental_property_income"]    == individual_tax_return.price_rental_property_income
      assert found["price_sole_proprietorship_count"] == individual_tax_return.price_sole_proprietorship_count
      assert found["price_state"]                     == individual_tax_return.price_state
      assert found["price_stock_divident"]            == individual_tax_return.price_stock_divident
      assert found["price_tax_year"]                  == individual_tax_return.price_tax_year
      assert found["rental_property_income"]          == individual_tax_return.rental_property_income
      assert found["stock_divident"]                  == individual_tax_return.stock_divident
      assert found["updated_at"]                      == formatting_time(individual_tax_return.updated_at)
      assert found["user"]["id"]                      == individual_tax_return.user.id
      assert found["user"]["active"]                  == individual_tax_return.user.active
      assert found["user"]["avatar"]                  == individual_tax_return.user.avatar
      assert found["user"]["bio"]                     == individual_tax_return.user.bio
      assert found["user"]["birthday"]                == to_string(individual_tax_return.user.birthday)
      assert found["user"]["email"]                   == individual_tax_return.user.email
      assert found["user"]["first_name"]              == individual_tax_return.user.first_name
      assert found["user"]["init_setup"]              == individual_tax_return.user.init_setup
      assert found["user"]["last_name"]               == individual_tax_return.user.last_name
      assert found["user"]["middle_name"]             == individual_tax_return.user.middle_name
      assert found["user"]["phone"]                   == individual_tax_return.user.phone
      assert found["user"]["provider"]                == individual_tax_return.user.provider
      assert found["user"]["role"]                    == individual_tax_return.user.role
      assert found["user"]["sex"]                     == individual_tax_return.user.sex
      assert found["user"]["ssn"]                     == individual_tax_return.user.ssn
      assert found["user"]["street"]                  == individual_tax_return.user.street
      assert found["user"]["zip"]                     == individual_tax_return.user.zip
      assert found["user"]["inserted_at"]             == formatting_time(individual_tax_return.user.inserted_at)
      assert found["user"]["updated_at"]              == formatting_time(individual_tax_return.user.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showIndividualTaxReturn"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showIndividualTaxReturn"]

      assert found["id"]                              == individual_tax_return.id
      assert found["foreign_account"]                 == individual_tax_return.foreign_account
      assert found["home_owner"]                      == individual_tax_return.home_owner
      assert found["inserted_at"]                     == formatting_time(individual_tax_return.inserted_at)
      assert found["living_abroad"]                   == individual_tax_return.living_abroad
      assert found["non_resident_earning"]            == individual_tax_return.non_resident_earning
      assert found["none_expat"]                      == individual_tax_return.none_expat
      assert found["own_stock_crypto"]                == individual_tax_return.own_stock_crypto
      assert found["price_foreign_account"]           == individual_tax_return.price_foreign_account
      assert found["price_home_owner"]                == individual_tax_return.price_home_owner
      assert found["price_living_abroad"]             == individual_tax_return.price_living_abroad
      assert found["price_non_resident_earning"]      == individual_tax_return.price_non_resident_earning
      assert found["price_own_stock_crypto"]          == individual_tax_return.price_own_stock_crypto
      assert found["price_rental_property_income"]    == individual_tax_return.price_rental_property_income
      assert found["price_sole_proprietorship_count"] == individual_tax_return.price_sole_proprietorship_count
      assert found["price_state"]                     == individual_tax_return.price_state
      assert found["price_stock_divident"]            == individual_tax_return.price_stock_divident
      assert found["price_tax_year"]                  == individual_tax_return.price_tax_year
      assert found["rental_property_income"]          == individual_tax_return.rental_property_income
      assert found["stock_divident"]                  == individual_tax_return.stock_divident
      assert found["updated_at"]                      == formatting_time(individual_tax_return.updated_at)
      assert found["user"]["id"]                      == individual_tax_return.user.id
      assert found["user"]["active"]                  == individual_tax_return.user.active
      assert found["user"]["avatar"]                  == individual_tax_return.user.avatar
      assert found["user"]["bio"]                     == individual_tax_return.user.bio
      assert found["user"]["birthday"]                == to_string(individual_tax_return.user.birthday)
      assert found["user"]["email"]                   == individual_tax_return.user.email
      assert found["user"]["first_name"]              == individual_tax_return.user.first_name
      assert found["user"]["init_setup"]              == individual_tax_return.user.init_setup
      assert found["user"]["last_name"]               == individual_tax_return.user.last_name
      assert found["user"]["middle_name"]             == individual_tax_return.user.middle_name
      assert found["user"]["phone"]                   == individual_tax_return.user.phone
      assert found["user"]["provider"]                == individual_tax_return.user.provider
      assert found["user"]["role"]                    == individual_tax_return.user.role
      assert found["user"]["sex"]                     == individual_tax_return.user.sex
      assert found["user"]["ssn"]                     == individual_tax_return.user.ssn
      assert found["user"]["street"]                  == individual_tax_return.user.street
      assert found["user"]["zip"]                     == individual_tax_return.user.zip
      assert found["user"]["inserted_at"]             == formatting_time(individual_tax_return.user.inserted_at)
      assert found["user"]["updated_at"]              == formatting_time(individual_tax_return.user.updated_at)
    end
  end

  describe "#find" do
    it "find specific IndividualTaxReturn by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})
      context = %{current_user: user}

      query = """
      {
        findIndividualTaxReturn(id: \"#{individual_tax_return.id}\") {
          id
          foreign_account
          foreign_account_limit
          foreign_financial_interest
          home_owner
          inserted_at
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
          updated_at
          user {
            id
            active
            avatar
            bio
            birthday
            email
            first_name
            init_setup
            last_name
            middle_name
            phone
            provider
            role
            sex
            ssn
            street
            zip
            inserted_at
            updated_at
          }
        }
      }
      """

      {:ok, %{data: %{"findIndividualTaxReturn" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                              == individual_tax_return.id
      assert found["foreign_account"]                 == individual_tax_return.foreign_account
      assert found["foreign_account_limit"]           == individual_tax_return.foreign_account_limit
      assert found["foreign_financial_interest"]      == individual_tax_return.foreign_financial_interest
      assert found["home_owner"]                      == individual_tax_return.home_owner
      assert found["inserted_at"]                     == formatting_time(individual_tax_return.inserted_at)
      assert found["k1_count"]                        == individual_tax_return.k1_count
      assert found["k1_income"]                       == individual_tax_return.k1_income
      assert found["living_abroad"]                   == individual_tax_return.living_abroad
      assert found["non_resident_earning"]            == individual_tax_return.non_resident_earning
      assert found["none_expat"]                      == individual_tax_return.none_expat
      assert found["own_stock_crypto"]                == individual_tax_return.own_stock_crypto
      assert found["rental_property_count"]           == individual_tax_return.rental_property_count
      assert found["rental_property_income"]          == individual_tax_return.rental_property_income
      assert found["sole_proprietorship_count"]       == individual_tax_return.sole_proprietorship_count
      assert found["state"]                           == individual_tax_return.state
      assert found["stock_divident"]                  == individual_tax_return.stock_divident
      assert found["tax_year"]                        == individual_tax_return.tax_year
      assert found["updated_at"]                      == formatting_time(individual_tax_return.updated_at)
      assert found["user"]["id"]                      == individual_tax_return.user.id
      assert found["user"]["active"]                  == individual_tax_return.user.active
      assert found["user"]["avatar"]                  == individual_tax_return.user.avatar
      assert found["user"]["bio"]                     == individual_tax_return.user.bio
      assert found["user"]["birthday"]                == to_string(individual_tax_return.user.birthday)
      assert found["user"]["email"]                   == individual_tax_return.user.email
      assert found["user"]["first_name"]              == individual_tax_return.user.first_name
      assert found["user"]["init_setup"]              == individual_tax_return.user.init_setup
      assert found["user"]["last_name"]               == individual_tax_return.user.last_name
      assert found["user"]["middle_name"]             == individual_tax_return.user.middle_name
      assert found["user"]["phone"]                   == individual_tax_return.user.phone
      assert found["user"]["provider"]                == individual_tax_return.user.provider
      assert found["user"]["role"]                    == individual_tax_return.user.role
      assert found["user"]["sex"]                     == individual_tax_return.user.sex
      assert found["user"]["ssn"]                     == individual_tax_return.user.ssn
      assert found["user"]["street"]                  == individual_tax_return.user.street
      assert found["user"]["zip"]                     == individual_tax_return.user.zip
      assert found["user"]["inserted_at"]             == formatting_time(individual_tax_return.user.inserted_at)
      assert found["user"]["updated_at"]              == formatting_time(individual_tax_return.user.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualTaxReturn"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualTaxReturn"]

      assert found["id"]                              == individual_tax_return.id
      assert found["foreign_account"]                 == individual_tax_return.foreign_account
      assert found["foreign_account_limit"]           == individual_tax_return.foreign_account_limit
      assert found["foreign_financial_interest"]      == individual_tax_return.foreign_financial_interest
      assert found["home_owner"]                      == individual_tax_return.home_owner
      assert found["inserted_at"]                     == formatting_time(individual_tax_return.inserted_at)
      assert found["k1_count"]                        == individual_tax_return.k1_count
      assert found["k1_income"]                       == individual_tax_return.k1_income
      assert found["living_abroad"]                   == individual_tax_return.living_abroad
      assert found["non_resident_earning"]            == individual_tax_return.non_resident_earning
      assert found["none_expat"]                      == individual_tax_return.none_expat
      assert found["own_stock_crypto"]                == individual_tax_return.own_stock_crypto
      assert found["rental_property_count"]           == individual_tax_return.rental_property_count
      assert found["rental_property_income"]          == individual_tax_return.rental_property_income
      assert found["sole_proprietorship_count"]       == individual_tax_return.sole_proprietorship_count
      assert found["state"]                           == individual_tax_return.state
      assert found["stock_divident"]                  == individual_tax_return.stock_divident
      assert found["tax_year"]                        == individual_tax_return.tax_year
      assert found["updated_at"]                      == formatting_time(individual_tax_return.updated_at)
      assert found["user"]["id"]                      == individual_tax_return.user.id
      assert found["user"]["active"]                  == individual_tax_return.user.active
      assert found["user"]["avatar"]                  == individual_tax_return.user.avatar
      assert found["user"]["bio"]                     == individual_tax_return.user.bio
      assert found["user"]["birthday"]                == to_string(individual_tax_return.user.birthday)
      assert found["user"]["email"]                   == individual_tax_return.user.email
      assert found["user"]["first_name"]              == individual_tax_return.user.first_name
      assert found["user"]["init_setup"]              == individual_tax_return.user.init_setup
      assert found["user"]["last_name"]               == individual_tax_return.user.last_name
      assert found["user"]["middle_name"]             == individual_tax_return.user.middle_name
      assert found["user"]["phone"]                   == individual_tax_return.user.phone
      assert found["user"]["provider"]                == individual_tax_return.user.provider
      assert found["user"]["role"]                    == individual_tax_return.user.role
      assert found["user"]["sex"]                     == individual_tax_return.user.sex
      assert found["user"]["ssn"]                     == individual_tax_return.user.ssn
      assert found["user"]["street"]                  == individual_tax_return.user.street
      assert found["user"]["zip"]                     == individual_tax_return.user.zip
      assert found["user"]["inserted_at"]             == formatting_time(individual_tax_return.user.inserted_at)
      assert found["user"]["updated_at"]              == formatting_time(individual_tax_return.user.updated_at)
    end

    it "find specific IndividualTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})
      context = %{current_user: user}

      query = """
      {
        findIndividualTaxReturn(id: \"#{individual_tax_return.id}\") {
          id
          foreign_account
          home_owner
          inserted_at
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
          updated_at
          user {
            id
            active
            avatar
            bio
            birthday
            email
            first_name
            init_setup
            last_name
            middle_name
            phone
            provider
            role
            sex
            ssn
            street
            zip
            inserted_at
            updated_at
          }
        }
      }
      """

      {:ok, %{data: %{"findIndividualTaxReturn" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                              == individual_tax_return.id
      assert found["foreign_account"]                 == individual_tax_return.foreign_account
      assert found["home_owner"]                      == individual_tax_return.home_owner
      assert found["inserted_at"]                     == formatting_time(individual_tax_return.inserted_at)
      assert found["living_abroad"]                   == individual_tax_return.living_abroad
      assert found["non_resident_earning"]            == individual_tax_return.non_resident_earning
      assert found["none_expat"]                      == individual_tax_return.none_expat
      assert found["own_stock_crypto"]                == individual_tax_return.own_stock_crypto
      assert found["price_foreign_account"]           == individual_tax_return.price_foreign_account
      assert found["price_home_owner"]                == individual_tax_return.price_home_owner
      assert found["price_living_abroad"]             == individual_tax_return.price_living_abroad
      assert found["price_non_resident_earning"]      == individual_tax_return.price_non_resident_earning
      assert found["price_own_stock_crypto"]          == individual_tax_return.price_own_stock_crypto
      assert found["price_rental_property_income"]    == individual_tax_return.price_rental_property_income
      assert found["price_sole_proprietorship_count"] == individual_tax_return.price_sole_proprietorship_count
      assert found["price_state"]                     == individual_tax_return.price_state
      assert found["price_stock_divident"]            == individual_tax_return.price_stock_divident
      assert found["price_tax_year"]                  == individual_tax_return.price_tax_year
      assert found["rental_property_income"]          == individual_tax_return.rental_property_income
      assert found["stock_divident"]                  == individual_tax_return.stock_divident
      assert found["updated_at"]                      == formatting_time(individual_tax_return.updated_at)
      assert found["user"]["id"]                      == individual_tax_return.user.id
      assert found["user"]["active"]                  == individual_tax_return.user.active
      assert found["user"]["avatar"]                  == individual_tax_return.user.avatar
      assert found["user"]["bio"]                     == individual_tax_return.user.bio
      assert found["user"]["birthday"]                == to_string(individual_tax_return.user.birthday)
      assert found["user"]["email"]                   == individual_tax_return.user.email
      assert found["user"]["first_name"]              == individual_tax_return.user.first_name
      assert found["user"]["init_setup"]              == individual_tax_return.user.init_setup
      assert found["user"]["last_name"]               == individual_tax_return.user.last_name
      assert found["user"]["middle_name"]             == individual_tax_return.user.middle_name
      assert found["user"]["phone"]                   == individual_tax_return.user.phone
      assert found["user"]["provider"]                == individual_tax_return.user.provider
      assert found["user"]["role"]                    == individual_tax_return.user.role
      assert found["user"]["sex"]                     == individual_tax_return.user.sex
      assert found["user"]["ssn"]                     == individual_tax_return.user.ssn
      assert found["user"]["street"]                  == individual_tax_return.user.street
      assert found["user"]["zip"]                     == individual_tax_return.user.zip
      assert found["user"]["inserted_at"]             == formatting_time(individual_tax_return.user.inserted_at)
      assert found["user"]["updated_at"]              == formatting_time(individual_tax_return.user.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findIndividualTaxReturn"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findIndividualTaxReturn"]

      assert found["id"]                              == individual_tax_return.id
      assert found["foreign_account"]                 == individual_tax_return.foreign_account
      assert found["home_owner"]                      == individual_tax_return.home_owner
      assert found["inserted_at"]                     == formatting_time(individual_tax_return.inserted_at)
      assert found["living_abroad"]                   == individual_tax_return.living_abroad
      assert found["non_resident_earning"]            == individual_tax_return.non_resident_earning
      assert found["none_expat"]                      == individual_tax_return.none_expat
      assert found["own_stock_crypto"]                == individual_tax_return.own_stock_crypto
      assert found["price_foreign_account"]           == individual_tax_return.price_foreign_account
      assert found["price_home_owner"]                == individual_tax_return.price_home_owner
      assert found["price_living_abroad"]             == individual_tax_return.price_living_abroad
      assert found["price_non_resident_earning"]      == individual_tax_return.price_non_resident_earning
      assert found["price_own_stock_crypto"]          == individual_tax_return.price_own_stock_crypto
      assert found["price_rental_property_income"]    == individual_tax_return.price_rental_property_income
      assert found["price_sole_proprietorship_count"] == individual_tax_return.price_sole_proprietorship_count
      assert found["price_state"]                     == individual_tax_return.price_state
      assert found["price_stock_divident"]            == individual_tax_return.price_stock_divident
      assert found["price_tax_year"]                  == individual_tax_return.price_tax_year
      assert found["rental_property_income"]          == individual_tax_return.rental_property_income
      assert found["stock_divident"]                  == individual_tax_return.stock_divident
      assert found["updated_at"]                      == formatting_time(individual_tax_return.updated_at)
      assert found["user"]["id"]                      == individual_tax_return.user.id
      assert found["user"]["active"]                  == individual_tax_return.user.active
      assert found["user"]["avatar"]                  == individual_tax_return.user.avatar
      assert found["user"]["bio"]                     == individual_tax_return.user.bio
      assert found["user"]["birthday"]                == to_string(individual_tax_return.user.birthday)
      assert found["user"]["email"]                   == individual_tax_return.user.email
      assert found["user"]["first_name"]              == individual_tax_return.user.first_name
      assert found["user"]["init_setup"]              == individual_tax_return.user.init_setup
      assert found["user"]["last_name"]               == individual_tax_return.user.last_name
      assert found["user"]["middle_name"]             == individual_tax_return.user.middle_name
      assert found["user"]["phone"]                   == individual_tax_return.user.phone
      assert found["user"]["provider"]                == individual_tax_return.user.provider
      assert found["user"]["role"]                    == individual_tax_return.user.role
      assert found["user"]["sex"]                     == individual_tax_return.user.sex
      assert found["user"]["ssn"]                     == individual_tax_return.user.ssn
      assert found["user"]["street"]                  == individual_tax_return.user.street
      assert found["user"]["zip"]                     == individual_tax_return.user.zip
      assert found["user"]["inserted_at"]             == formatting_time(individual_tax_return.user.inserted_at)
      assert found["user"]["updated_at"]              == formatting_time(individual_tax_return.user.updated_at)
    end
  end

  describe "#create" do
    it "created IndividualTaxReturn by role's Tp" do
      user = insert(:tp_user)

      mutation = """
      {
        createIndividualTaxReturn(
          foreign_account: true,
          foreign_account_limit: true,
          foreign_financial_interest: true,
          home_owner: true,
          k1_count: 43,
          k1_income: true,
          living_abroad: true,
          non_resident_earning: true,
          none_expat: false,
          own_stock_crypto: true,
          rental_property_count: 15,
          rental_property_income: true,
          sole_proprietorship_count: 4,
          state: ["Alabama", "New York"],
          stock_divident: true,
          tax_year: ["2017", "2018"],
          userId: \"#{user.id}\"
        ) {
          id
          foreign_account
          foreign_account_limit
          foreign_financial_interest
          home_owner
          inserted_at
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
          updated_at
          user {
            id
            active
            avatar
            bio
            birthday
            email
            first_name
            init_setup
            last_name
            middle_name
            phone
            provider
            role
            sex
            ssn
            street
            zip
            inserted_at
            updated_at
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createIndividualTaxReturn"]

      assert created["foreign_account"]                == true
      assert created["foreign_account_limit"]          == true
      assert created["foreign_financial_interest"]     == true
      assert created["home_owner"]                     == true
      assert created["inserted_at"]                    == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["k1_count"]                       == 43
      assert created["k1_income"]                      == true
      assert created["living_abroad"]                  == true
      assert created["non_resident_earning"]           == true
      assert created["none_expat"]                     == false
      assert created["own_stock_crypto"]               == true
      assert created["rental_property_count"]          == 15
      assert created["rental_property_income"]         == true
      assert created["sole_proprietorship_count"]      == 4
      assert created["state"]                          == ["Alabama", "New York"]
      assert created["stock_divident"]                 == true
      assert created["tax_year"]                       == ["2017", "2018"]
      assert created["updated_at"]                     == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["user"]["id"]                     == user.id
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
          none_expat: false,
          own_stock_crypto: true,
          price_foreign_account: 35,
          price_home_owner: 45,
          price_living_abroad: 55,
          price_non_resident_earning: 44,
          price_own_stock_crypto: 33,
          price_rental_property_income: 54,
          price_sole_proprietorship_count: 150,
          price_state: 8,
          price_stock_divident: 34,
          price_tax_year: 38,
          rental_property_income: true,
          stock_divident: true,
          userId: \"#{user.id}\"
        ) {
          id
          foreign_account
          home_owner
          inserted_at
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
          updated_at
          user {
            id
            active
            avatar
            bio
            birthday
            email
            first_name
            init_setup
            last_name
            middle_name
            phone
            provider
            role
            sex
            ssn
            street
            zip
            inserted_at
            updated_at
          }
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
      assert created["inserted_at"]                     == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["living_abroad"]                   == true
      assert created["non_resident_earning"]            == true
      assert created["none_expat"]                      == false
      assert created["own_stock_crypto"]                == true
      assert created["price_foreign_account"]           == 35
      assert created["price_home_owner"]                == 45
      assert created["price_living_abroad"]             == 55
      assert created["price_non_resident_earning"]      == 44
      assert created["price_own_stock_crypto"]          == 33
      assert created["price_rental_property_income"]    == 54
      assert created["price_sole_proprietorship_count"] == 150
      assert created["price_state"]                     == 8
      assert created["price_stock_divident"]            == 34
      assert created["price_tax_year"]                  == 38
      assert created["rental_property_income"]          == true
      assert created["stock_divident"]                  == true
      assert created["updated_at"]                      == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["user"]["id"]                      == user.id
    end
  end

  describe "#update" do
    it "updated specific IndividualTaxReturn by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, %{user: user})

      mutation = """
      {
        updateIndividualTaxReturn(
          id: \"#{individual_tax_return.id}\",
          individual_tax_return: {
            foreign_account: false,
            foreign_account_limit: false,
            foreign_financial_interest: false,
            home_owner: false,
            k1_count: 44,
            k1_income: false,
            living_abroad: false,
            non_resident_earning: false,
            none_expat: true,
            own_stock_crypto: false,
            rental_property_count: 16,
            rental_property_income: false,
            sole_proprietorship_count: 5,
            state: ["Alabama"],
            stock_divident: false,
            tax_year: ["2019"],
            userId: \"#{user.id}\"
          }
        )
        {
          id
          foreign_account
          foreign_account_limit
          foreign_financial_interest
          home_owner
          inserted_at
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
          updated_at
          user {
            id
            active
            avatar
            bio
            birthday
            email
            first_name
            init_setup
            last_name
            middle_name
            phone
            provider
            role
            sex
            ssn
            street
            zip
            inserted_at
            updated_at
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateIndividualTaxReturn"]

      assert updated["id"]                             == individual_tax_return.id
      assert updated["foreign_account"]                == false
      assert updated["foreign_account_limit"]          == false
      assert updated["foreign_financial_interest"]     == false
      assert updated["home_owner"]                     == false
      assert updated["inserted_at"]                    == formatting_time(individual_tax_return.inserted_at)
      assert updated["k1_count"]                       == 44
      assert updated["k1_income"]                      == false
      assert updated["living_abroad"]                  == false
      assert updated["non_resident_earning"]           == false
      assert updated["none_expat"]                     == true
      assert updated["own_stock_crypto"]               == false
      assert updated["rental_property_count"]          == 16
      assert updated["rental_property_income"]         == false
      assert updated["sole_proprietorship_count"]      == 5
      assert updated["state"]                          == ["Alabama"]
      assert updated["stock_divident"]                 == false
      assert updated["tax_year"]                       == ["2019"]
      assert updated["updated_at"]                     == formatting_time(individual_tax_return.updated_at)
      assert updated["user"]["id"]                     == user.id
      assert updated["user"]["active"]                 == individual_tax_return.user.active
      assert updated["user"]["avatar"]                 == individual_tax_return.user.avatar
      assert updated["user"]["bio"]                    == individual_tax_return.user.bio
      assert updated["user"]["birthday"]               == to_string(individual_tax_return.user.birthday)
      assert updated["user"]["email"]                  == individual_tax_return.user.email
      assert updated["user"]["first_name"]             == individual_tax_return.user.first_name
      assert updated["user"]["init_setup"]             == individual_tax_return.user.init_setup
      assert updated["user"]["last_name"]              == individual_tax_return.user.last_name
      assert updated["user"]["middle_name"]            == individual_tax_return.user.middle_name
      assert updated["user"]["phone"]                  == individual_tax_return.user.phone
      assert updated["user"]["provider"]               == individual_tax_return.user.provider
      assert updated["user"]["role"]                   == individual_tax_return.user.role
      assert updated["user"]["sex"]                    == individual_tax_return.user.sex
      assert updated["user"]["ssn"]                    == individual_tax_return.user.ssn
      assert updated["user"]["street"]                 == individual_tax_return.user.street
      assert updated["user"]["zip"]                    == individual_tax_return.user.zip
      assert updated["user"]["inserted_at"]            == formatting_time(individual_tax_return.user.inserted_at)
      assert updated["user"]["updated_at"]             == formatting_time(individual_tax_return.user.updated_at)
    end

    it "updated specific IndividualTaxReturn by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, %{user: user})

      mutation = """
      {
        updateIndividualTaxReturn(
          id: \"#{individual_tax_return.id}\",
          individual_tax_return: {
            foreign_account: false,
            home_owner: false,
            living_abroad: false,
            non_resident_earning: false,
            none_expat: true,
            own_stock_crypto: false,
            price_foreign_account: 36,
            price_home_owner: 46,
            price_living_abroad: 56,
            price_non_resident_earning: 45,
            price_own_stock_crypto: 34,
            price_rental_property_income: 55,
            price_sole_proprietorship_count: 151,
            price_state: 9,
            price_stock_divident: 35,
            price_tax_year: 37,
            rental_property_income: false,
            stock_divident: false,
            userId: \"#{user.id}\"
          }
        )
        {
          id
          foreign_account
          home_owner
          inserted_at
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
          updated_at
          user {
            id
            active
            avatar
            bio
            birthday
            email
            first_name
            init_setup
            last_name
            middle_name
            phone
            provider
            role
            sex
            ssn
            street
            zip
            inserted_at
            updated_at
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateIndividualTaxReturn"]

      assert updated["id"]                              == individual_tax_return.id
      assert updated["foreign_account"]                 == false
      assert updated["home_owner"]                      == false
      assert updated["living_abroad"]                   == false
      assert updated["non_resident_earning"]            == false
      assert updated["none_expat"]                      == true
      assert updated["own_stock_crypto"]                == false
      assert updated["price_foreign_account"]           == 36
      assert updated["price_home_owner"]                == 46
      assert updated["price_living_abroad"]             == 56
      assert updated["price_non_resident_earning"]      == 45
      assert updated["price_own_stock_crypto"]          == 34
      assert updated["price_rental_property_income"]    == 55
      assert updated["price_sole_proprietorship_count"] == 151
      assert updated["price_state"]                     == 9
      assert updated["price_stock_divident"]            == 35
      assert updated["price_tax_year"]                  == 37
      assert updated["rental_property_income"]          == false
      assert updated["stock_divident"]                  == false
      assert updated["inserted_at"]                     == formatting_time(individual_tax_return.inserted_at)
      assert updated["updated_at"]                      == formatting_time(individual_tax_return.updated_at)
      assert updated["user"]["id"]                      == user.id
      assert updated["user"]["active"]                  == individual_tax_return.user.active
      assert updated["user"]["avatar"]                  == individual_tax_return.user.avatar
      assert updated["user"]["bio"]                     == individual_tax_return.user.bio
      assert updated["user"]["birthday"]                == to_string(individual_tax_return.user.birthday)
      assert updated["user"]["email"]                   == individual_tax_return.user.email
      assert updated["user"]["first_name"]              == individual_tax_return.user.first_name
      assert updated["user"]["init_setup"]              == individual_tax_return.user.init_setup
      assert updated["user"]["last_name"]               == individual_tax_return.user.last_name
      assert updated["user"]["middle_name"]             == individual_tax_return.user.middle_name
      assert updated["user"]["phone"]                   == individual_tax_return.user.phone
      assert updated["user"]["provider"]                == individual_tax_return.user.provider
      assert updated["user"]["role"]                    == individual_tax_return.user.role
      assert updated["user"]["sex"]                     == individual_tax_return.user.sex
      assert updated["user"]["ssn"]                     == individual_tax_return.user.ssn
      assert updated["user"]["street"]                  == individual_tax_return.user.street
      assert updated["user"]["zip"]                     == individual_tax_return.user.zip
      assert updated["user"]["inserted_at"]             == formatting_time(individual_tax_return.user.inserted_at)
      assert updated["user"]["updated_at"]              == formatting_time(individual_tax_return.user.updated_at)
    end
  end

  describe "#delete" do
    it "delete specific IndividualTaxReturn" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)

      mutation = """
      {
        deleteIndividualTaxReturn(id: \"#{individual_tax_return.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteIndividualTaxReturn"]
      assert deleted["id"] == individual_tax_return.id
    end
  end

  describe "#dataloads" do
    it "created IndividualTaxReturn" do
      %{id: user_id} = insert(:user)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:individual_tax_returns, source)
        |> Dataloader.load(:individual_tax_returns, Core.Accounts.User, user_id)
        |> Dataloader.run

      data = Dataloader.get(loader, :individual_tax_returns, Core.Accounts.User, user_id)

      assert data.id == user_id
    end
  end

  defp formatting_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

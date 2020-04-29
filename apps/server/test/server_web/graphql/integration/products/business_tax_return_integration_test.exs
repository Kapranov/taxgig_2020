defmodule ServerWeb.GraphQL.Integration.Products.BusinessTaxReturnIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      context = %{current_user: user}

      query = """
      {
        allBusinessTaxReturns {
          id
          accounting_software
          capital_asset_sale
          church_hospital
          dispose_asset
          dispose_property
          educational_facility
          financial_situation
          foreign_account_interest
          foreign_account_value_more
          foreign_entity_interest
          foreign_partner_count
          foreign_shareholder
          foreign_value
          fundraising_over
          has_contribution
          has_loan
          income_over_thousand
          inserted_at
          invest_research
          k1_count
          lobbying
          make_distribution
          none_expat
          operate_facility
          property_sale
          public_charity
          rental_property_count
          reported_grant
          restricted_donation
          state
          tax_exemption
          tax_year
          total_asset_less
          total_asset_over
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessTaxReturns"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessTaxReturns"]

      assert List.first(data)["id"]                             == business_tax_return.id
      assert List.first(data)["accounting_software"]            == business_tax_return.accounting_software
      assert List.first(data)["capital_asset_sale"]             == business_tax_return.capital_asset_sale
      assert List.first(data)["church_hospital"]                == business_tax_return.church_hospital
      assert List.first(data)["dispose_asset"]                  == business_tax_return.dispose_asset
      assert List.first(data)["dispose_property"]               == business_tax_return.dispose_property
      assert List.first(data)["educational_facility"]           == business_tax_return.educational_facility
      assert List.first(data)["financial_situation"]            == business_tax_return.financial_situation
      assert List.first(data)["foreign_account_interest"]       == business_tax_return.foreign_account_interest
      assert List.first(data)["foreign_account_value_more"]     == business_tax_return.foreign_account_value_more
      assert List.first(data)["foreign_entity_interest"]        == business_tax_return.foreign_entity_interest
      assert List.first(data)["foreign_partner_count"]          == business_tax_return.foreign_partner_count
      assert List.first(data)["foreign_shareholder"]            == business_tax_return.foreign_shareholder
      assert List.first(data)["foreign_value"]                  == business_tax_return.foreign_value
      assert List.first(data)["fundraising_over"]               == business_tax_return.fundraising_over
      assert List.first(data)["has_contribution"]               == business_tax_return.has_contribution
      assert List.first(data)["has_loan"]                       == business_tax_return.has_loan
      assert List.first(data)["income_over_thousand"]           == business_tax_return.income_over_thousand
      assert List.first(data)["inserted_at"]                    == formatting_time(business_tax_return.inserted_at)
      assert List.first(data)["invest_research"]                == business_tax_return.invest_research
      assert List.first(data)["k1_count"]                       == business_tax_return.k1_count
      assert List.first(data)["lobbying"]                       == business_tax_return.lobbying
      assert List.first(data)["make_distribution"]              == business_tax_return.make_distribution
      assert List.first(data)["none_expat"]                     == business_tax_return.none_expat
      assert List.first(data)["operate_facility"]               == business_tax_return.operate_facility
      assert List.first(data)["property_sale"]                  == business_tax_return.property_sale
      assert List.first(data)["public_charity"]                 == business_tax_return.public_charity
      assert List.first(data)["rental_property_count"]          == business_tax_return.rental_property_count
      assert List.first(data)["reported_grant"]                 == business_tax_return.reported_grant
      assert List.first(data)["restricted_donation"]            == business_tax_return.restricted_donation
      assert List.first(data)["state"]                          == business_tax_return.state
      assert List.first(data)["tax_exemption"]                  == business_tax_return.tax_exemption
      assert List.first(data)["tax_year"]                       == business_tax_return.tax_year
      assert List.first(data)["total_asset_less"]               == business_tax_return.total_asset_less
      assert List.first(data)["total_asset_over"]               == business_tax_return.total_asset_over
      assert List.first(data)["updated_at"]                     == formatting_time(business_tax_return.updated_at)
      assert List.first(data)["user"]["id"]                     == business_tax_return.user.id
      assert List.first(data)["user"]["active"]                 == business_tax_return.user.active
      assert List.first(data)["user"]["avatar"]                 == business_tax_return.user.avatar
      assert List.first(data)["user"]["bio"]                    == business_tax_return.user.bio
      assert List.first(data)["user"]["birthday"]               == to_string(business_tax_return.user.birthday)
      assert List.first(data)["user"]["email"]                  == business_tax_return.user.email
      assert List.first(data)["user"]["first_name"]             == business_tax_return.user.first_name
      assert List.first(data)["user"]["init_setup"]             == business_tax_return.user.init_setup
      assert List.first(data)["user"]["last_name"]              == business_tax_return.user.last_name
      assert List.first(data)["user"]["middle_name"]            == business_tax_return.user.middle_name
      assert List.first(data)["user"]["phone"]                  == business_tax_return.user.phone
      assert List.first(data)["user"]["provider"]               == business_tax_return.user.provider
      assert List.first(data)["user"]["role"]                   == business_tax_return.user.role
      assert List.first(data)["user"]["sex"]                    == business_tax_return.user.sex
      assert List.first(data)["user"]["ssn"]                    == business_tax_return.user.ssn
      assert List.first(data)["user"]["street"]                 == business_tax_return.user.street
      assert List.first(data)["user"]["zip"]                    == business_tax_return.user.zip
      assert List.first(data)["user"]["inserted_at"]            == formatting_time(business_tax_return.user.inserted_at)
      assert List.first(data)["user"]["updated_at"]             == formatting_time(business_tax_return.user.updated_at)

      {:ok, %{data: %{"allBusinessTaxReturns" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                             == business_tax_return.id
      assert first["accounting_software"]            == business_tax_return.accounting_software
      assert first["capital_asset_sale"]             == business_tax_return.capital_asset_sale
      assert first["church_hospital"]                == business_tax_return.church_hospital
      assert first["dispose_asset"]                  == business_tax_return.dispose_asset
      assert first["dispose_property"]               == business_tax_return.dispose_property
      assert first["educational_facility"]           == business_tax_return.educational_facility
      assert first["financial_situation"]            == business_tax_return.financial_situation
      assert first["foreign_account_interest"]       == business_tax_return.foreign_account_interest
      assert first["foreign_account_value_more"]     == business_tax_return.foreign_account_value_more
      assert first["foreign_entity_interest"]        == business_tax_return.foreign_entity_interest
      assert first["foreign_partner_count"]          == business_tax_return.foreign_partner_count
      assert first["foreign_shareholder"]            == business_tax_return.foreign_shareholder
      assert first["foreign_value"]                  == business_tax_return.foreign_value
      assert first["fundraising_over"]               == business_tax_return.fundraising_over
      assert first["has_contribution"]               == business_tax_return.has_contribution
      assert first["has_loan"]                       == business_tax_return.has_loan
      assert first["income_over_thousand"]           == business_tax_return.income_over_thousand
      assert first["inserted_at"]                    == formatting_time(business_tax_return.inserted_at)
      assert first["invest_research"]                == business_tax_return.invest_research
      assert first["k1_count"]                       == business_tax_return.k1_count
      assert first["lobbying"]                       == business_tax_return.lobbying
      assert first["make_distribution"]              == business_tax_return.make_distribution
      assert first["none_expat"]                     == business_tax_return.none_expat
      assert first["operate_facility"]               == business_tax_return.operate_facility
      assert first["property_sale"]                  == business_tax_return.property_sale
      assert first["public_charity"]                 == business_tax_return.public_charity
      assert first["rental_property_count"]          == business_tax_return.rental_property_count
      assert first["reported_grant"]                 == business_tax_return.reported_grant
      assert first["restricted_donation"]            == business_tax_return.restricted_donation
      assert first["state"]                          == business_tax_return.state
      assert first["tax_exemption"]                  == business_tax_return.tax_exemption
      assert first["tax_year"]                       == business_tax_return.tax_year
      assert first["total_asset_less"]               == business_tax_return.total_asset_less
      assert first["total_asset_over"]               == business_tax_return.total_asset_over
      assert first["updated_at"]                     == formatting_time(business_tax_return.updated_at)
      assert first["user"]["id"]                     == business_tax_return.user.id
      assert first["user"]["active"]                 == business_tax_return.user.active
      assert first["user"]["avatar"]                 == business_tax_return.user.avatar
      assert first["user"]["bio"]                    == business_tax_return.user.bio
      assert first["user"]["birthday"]               == to_string(business_tax_return.user.birthday)
      assert first["user"]["email"]                  == business_tax_return.user.email
      assert first["user"]["first_name"]             == business_tax_return.user.first_name
      assert first["user"]["init_setup"]             == business_tax_return.user.init_setup
      assert first["user"]["last_name"]              == business_tax_return.user.last_name
      assert first["user"]["middle_name"]            == business_tax_return.user.middle_name
      assert first["user"]["phone"]                  == business_tax_return.user.phone
      assert first["user"]["provider"]               == business_tax_return.user.provider
      assert first["user"]["role"]                   == business_tax_return.user.role
      assert first["user"]["sex"]                    == business_tax_return.user.sex
      assert first["user"]["ssn"]                    == business_tax_return.user.ssn
      assert first["user"]["street"]                 == business_tax_return.user.street
      assert first["user"]["zip"]                    == business_tax_return.user.zip
      assert first["user"]["inserted_at"]            == formatting_time(business_tax_return.user.inserted_at)
      assert first["user"]["updated_at"]             == formatting_time(business_tax_return.user.updated_at)
    end

    it "returns BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      context = %{current_user: user}

      query = """
      {
        allBusinessTaxReturns {
          id
          inserted_at
          none_expat
          price_state
          price_tax_year
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessTaxReturns"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessTaxReturns"]

      assert List.first(data)["id"]                             == business_tax_return.id
      assert List.first(data)["inserted_at"]                    == formatting_time(business_tax_return.inserted_at)
      assert List.first(data)["none_expat"]                     == business_tax_return.none_expat
      assert List.first(data)["price_state"]                    == business_tax_return.price_state
      assert List.first(data)["price_tax_year"]                 == business_tax_return.price_tax_year
      assert List.first(data)["updated_at"]                     == formatting_time(business_tax_return.updated_at)
      assert List.first(data)["user"]["id"]                     == business_tax_return.user.id
      assert List.first(data)["user"]["active"]                 == business_tax_return.user.active
      assert List.first(data)["user"]["avatar"]                 == business_tax_return.user.avatar
      assert List.first(data)["user"]["bio"]                    == business_tax_return.user.bio
      assert List.first(data)["user"]["birthday"]               == to_string(business_tax_return.user.birthday)
      assert List.first(data)["user"]["email"]                  == business_tax_return.user.email
      assert List.first(data)["user"]["first_name"]             == business_tax_return.user.first_name
      assert List.first(data)["user"]["init_setup"]             == business_tax_return.user.init_setup
      assert List.first(data)["user"]["last_name"]              == business_tax_return.user.last_name
      assert List.first(data)["user"]["middle_name"]            == business_tax_return.user.middle_name
      assert List.first(data)["user"]["phone"]                  == business_tax_return.user.phone
      assert List.first(data)["user"]["provider"]               == business_tax_return.user.provider
      assert List.first(data)["user"]["role"]                   == business_tax_return.user.role
      assert List.first(data)["user"]["sex"]                    == business_tax_return.user.sex
      assert List.first(data)["user"]["ssn"]                    == business_tax_return.user.ssn
      assert List.first(data)["user"]["street"]                 == business_tax_return.user.street
      assert List.first(data)["user"]["zip"]                    == business_tax_return.user.zip
      assert List.first(data)["user"]["inserted_at"]            == formatting_time(business_tax_return.user.inserted_at)
      assert List.first(data)["user"]["updated_at"]             == formatting_time(business_tax_return.user.updated_at)


      {:ok, %{data: %{"allBusinessTaxReturns" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                             == business_tax_return.id
      assert first["inserted_at"]                    == formatting_time(business_tax_return.inserted_at)
      assert first["none_expat"]                     == business_tax_return.none_expat
      assert first["price_state"]                    == business_tax_return.price_state
      assert first["price_tax_year"]                 == business_tax_return.price_tax_year
      assert first["updated_at"]                     == formatting_time(business_tax_return.updated_at)
      assert first["user"]["id"]                     == business_tax_return.user.id
      assert first["user"]["active"]                 == business_tax_return.user.active
      assert first["user"]["avatar"]                 == business_tax_return.user.avatar
      assert first["user"]["bio"]                    == business_tax_return.user.bio
      assert first["user"]["birthday"]               == to_string(business_tax_return.user.birthday)
      assert first["user"]["email"]                  == business_tax_return.user.email
      assert first["user"]["first_name"]             == business_tax_return.user.first_name
      assert first["user"]["init_setup"]             == business_tax_return.user.init_setup
      assert first["user"]["last_name"]              == business_tax_return.user.last_name
      assert first["user"]["middle_name"]            == business_tax_return.user.middle_name
      assert first["user"]["phone"]                  == business_tax_return.user.phone
      assert first["user"]["provider"]               == business_tax_return.user.provider
      assert first["user"]["role"]                   == business_tax_return.user.role
      assert first["user"]["sex"]                    == business_tax_return.user.sex
      assert first["user"]["ssn"]                    == business_tax_return.user.ssn
      assert first["user"]["street"]                 == business_tax_return.user.street
      assert first["user"]["zip"]                    == business_tax_return.user.zip
      assert first["user"]["inserted_at"]            == formatting_time(business_tax_return.user.inserted_at)
      assert first["user"]["updated_at"]             == formatting_time(business_tax_return.user.updated_at)
    end
  end

  describe "#show" do
    it "returns specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      context = %{current_user: user}

      query = """
      {
        showBusinessTaxReturn(id: \"#{business_tax_return.id}\") {
          id
          accounting_software
          capital_asset_sale
          church_hospital
          dispose_asset
          dispose_property
          educational_facility
          financial_situation
          foreign_account_interest
          foreign_account_value_more
          foreign_entity_interest
          foreign_partner_count
          foreign_shareholder
          foreign_value
          fundraising_over
          has_contribution
          has_loan
          income_over_thousand
          inserted_at
          invest_research
          k1_count
          lobbying
          make_distribution
          none_expat
          operate_facility
          property_sale
          public_charity
          rental_property_count
          reported_grant
          restricted_donation
          state
          tax_exemption
          tax_year
          total_asset_less
          total_asset_over
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

      {:ok, %{data: %{"showBusinessTaxReturn" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                             == business_tax_return.id
      assert found["accounting_software"]            == business_tax_return.accounting_software
      assert found["capital_asset_sale"]             == business_tax_return.capital_asset_sale
      assert found["church_hospital"]                == business_tax_return.church_hospital
      assert found["dispose_asset"]                  == business_tax_return.dispose_asset
      assert found["dispose_property"]               == business_tax_return.dispose_property
      assert found["educational_facility"]           == business_tax_return.educational_facility
      assert found["financial_situation"]            == business_tax_return.financial_situation
      assert found["foreign_account_interest"]       == business_tax_return.foreign_account_interest
      assert found["foreign_account_value_more"]     == business_tax_return.foreign_account_value_more
      assert found["foreign_entity_interest"]        == business_tax_return.foreign_entity_interest
      assert found["foreign_partner_count"]          == business_tax_return.foreign_partner_count
      assert found["foreign_shareholder"]            == business_tax_return.foreign_shareholder
      assert found["foreign_value"]                  == business_tax_return.foreign_value
      assert found["fundraising_over"]               == business_tax_return.fundraising_over
      assert found["has_contribution"]               == business_tax_return.has_contribution
      assert found["has_loan"]                       == business_tax_return.has_loan
      assert found["income_over_thousand"]           == business_tax_return.income_over_thousand
      assert found["inserted_at"]                    == formatting_time(business_tax_return.inserted_at)
      assert found["invest_research"]                == business_tax_return.invest_research
      assert found["k1_count"]                       == business_tax_return.k1_count
      assert found["lobbying"]                       == business_tax_return.lobbying
      assert found["make_distribution"]              == business_tax_return.make_distribution
      assert found["none_expat"]                     == business_tax_return.none_expat
      assert found["operate_facility"]               == business_tax_return.operate_facility
      assert found["property_sale"]                  == business_tax_return.property_sale
      assert found["public_charity"]                 == business_tax_return.public_charity
      assert found["rental_property_count"]          == business_tax_return.rental_property_count
      assert found["reported_grant"]                 == business_tax_return.reported_grant
      assert found["restricted_donation"]            == business_tax_return.restricted_donation
      assert found["state"]                          == business_tax_return.state
      assert found["tax_exemption"]                  == business_tax_return.tax_exemption
      assert found["tax_year"]                       == business_tax_return.tax_year
      assert found["total_asset_less"]               == business_tax_return.total_asset_less
      assert found["total_asset_over"]               == business_tax_return.total_asset_over
      assert found["updated_at"]                     == formatting_time(business_tax_return.updated_at)
      assert found["user"]["id"]                     == business_tax_return.user.id
      assert found["user"]["active"]                 == business_tax_return.user.active
      assert found["user"]["avatar"]                 == business_tax_return.user.avatar
      assert found["user"]["bio"]                    == business_tax_return.user.bio
      assert found["user"]["birthday"]               == to_string(business_tax_return.user.birthday)
      assert found["user"]["email"]                  == business_tax_return.user.email
      assert found["user"]["first_name"]             == business_tax_return.user.first_name
      assert found["user"]["init_setup"]             == business_tax_return.user.init_setup
      assert found["user"]["last_name"]              == business_tax_return.user.last_name
      assert found["user"]["middle_name"]            == business_tax_return.user.middle_name
      assert found["user"]["phone"]                  == business_tax_return.user.phone
      assert found["user"]["provider"]               == business_tax_return.user.provider
      assert found["user"]["role"]                   == business_tax_return.user.role
      assert found["user"]["sex"]                    == business_tax_return.user.sex
      assert found["user"]["ssn"]                    == business_tax_return.user.ssn
      assert found["user"]["street"]                 == business_tax_return.user.street
      assert found["user"]["zip"]                    == business_tax_return.user.zip
      assert found["user"]["inserted_at"]            == formatting_time(business_tax_return.user.inserted_at)
      assert found["user"]["updated_at"]             == formatting_time(business_tax_return.user.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessTaxReturn"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessTaxReturn"]

      assert found["id"]                             == business_tax_return.id
      assert found["accounting_software"]            == business_tax_return.accounting_software
      assert found["capital_asset_sale"]             == business_tax_return.capital_asset_sale
      assert found["church_hospital"]                == business_tax_return.church_hospital
      assert found["dispose_asset"]                  == business_tax_return.dispose_asset
      assert found["dispose_property"]               == business_tax_return.dispose_property
      assert found["educational_facility"]           == business_tax_return.educational_facility
      assert found["financial_situation"]            == business_tax_return.financial_situation
      assert found["foreign_account_interest"]       == business_tax_return.foreign_account_interest
      assert found["foreign_account_value_more"]     == business_tax_return.foreign_account_value_more
      assert found["foreign_entity_interest"]        == business_tax_return.foreign_entity_interest
      assert found["foreign_partner_count"]          == business_tax_return.foreign_partner_count
      assert found["foreign_shareholder"]            == business_tax_return.foreign_shareholder
      assert found["foreign_value"]                  == business_tax_return.foreign_value
      assert found["fundraising_over"]               == business_tax_return.fundraising_over
      assert found["has_contribution"]               == business_tax_return.has_contribution
      assert found["has_loan"]                       == business_tax_return.has_loan
      assert found["income_over_thousand"]           == business_tax_return.income_over_thousand
      assert found["inserted_at"]                    == formatting_time(business_tax_return.inserted_at)
      assert found["invest_research"]                == business_tax_return.invest_research
      assert found["k1_count"]                       == business_tax_return.k1_count
      assert found["lobbying"]                       == business_tax_return.lobbying
      assert found["make_distribution"]              == business_tax_return.make_distribution
      assert found["none_expat"]                     == business_tax_return.none_expat
      assert found["operate_facility"]               == business_tax_return.operate_facility
      assert found["property_sale"]                  == business_tax_return.property_sale
      assert found["public_charity"]                 == business_tax_return.public_charity
      assert found["rental_property_count"]          == business_tax_return.rental_property_count
      assert found["reported_grant"]                 == business_tax_return.reported_grant
      assert found["restricted_donation"]            == business_tax_return.restricted_donation
      assert found["state"]                          == business_tax_return.state
      assert found["tax_exemption"]                  == business_tax_return.tax_exemption
      assert found["tax_year"]                       == business_tax_return.tax_year
      assert found["total_asset_less"]               == business_tax_return.total_asset_less
      assert found["total_asset_over"]               == business_tax_return.total_asset_over
      assert found["updated_at"]                     == formatting_time(business_tax_return.updated_at)
      assert found["user"]["id"]                     == business_tax_return.user.id
      assert found["user"]["active"]                 == business_tax_return.user.active
      assert found["user"]["avatar"]                 == business_tax_return.user.avatar
      assert found["user"]["bio"]                    == business_tax_return.user.bio
      assert found["user"]["birthday"]               == to_string(business_tax_return.user.birthday)
      assert found["user"]["email"]                  == business_tax_return.user.email
      assert found["user"]["first_name"]             == business_tax_return.user.first_name
      assert found["user"]["init_setup"]             == business_tax_return.user.init_setup
      assert found["user"]["last_name"]              == business_tax_return.user.last_name
      assert found["user"]["middle_name"]            == business_tax_return.user.middle_name
      assert found["user"]["phone"]                  == business_tax_return.user.phone
      assert found["user"]["provider"]               == business_tax_return.user.provider
      assert found["user"]["role"]                   == business_tax_return.user.role
      assert found["user"]["sex"]                    == business_tax_return.user.sex
      assert found["user"]["ssn"]                    == business_tax_return.user.ssn
      assert found["user"]["street"]                 == business_tax_return.user.street
      assert found["user"]["zip"]                    == business_tax_return.user.zip
      assert found["user"]["inserted_at"]            == formatting_time(business_tax_return.user.inserted_at)
      assert found["user"]["updated_at"]             == formatting_time(business_tax_return.user.updated_at)
    end

    it "returns specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      context = %{current_user: user}

      query = """
      {
        showBusinessTaxReturn(id: \"#{business_tax_return.id}\") {
          id
          inserted_at
          none_expat
          price_state
          price_tax_year
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

      {:ok, %{data: %{"showBusinessTaxReturn" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                             == business_tax_return.id
      assert found["inserted_at"]                    == formatting_time(business_tax_return.inserted_at)
      assert found["none_expat"]                     == business_tax_return.none_expat
      assert found["price_state"]                    == business_tax_return.price_state
      assert found["price_tax_year"]                 == business_tax_return.price_tax_year
      assert found["updated_at"]                     == formatting_time(business_tax_return.updated_at)
      assert found["user"]["id"]                     == business_tax_return.user.id
      assert found["user"]["active"]                 == business_tax_return.user.active
      assert found["user"]["avatar"]                 == business_tax_return.user.avatar
      assert found["user"]["bio"]                    == business_tax_return.user.bio
      assert found["user"]["birthday"]               == to_string(business_tax_return.user.birthday)
      assert found["user"]["email"]                  == business_tax_return.user.email
      assert found["user"]["first_name"]             == business_tax_return.user.first_name
      assert found["user"]["init_setup"]             == business_tax_return.user.init_setup
      assert found["user"]["last_name"]              == business_tax_return.user.last_name
      assert found["user"]["middle_name"]            == business_tax_return.user.middle_name
      assert found["user"]["phone"]                  == business_tax_return.user.phone
      assert found["user"]["provider"]               == business_tax_return.user.provider
      assert found["user"]["role"]                   == business_tax_return.user.role
      assert found["user"]["sex"]                    == business_tax_return.user.sex
      assert found["user"]["ssn"]                    == business_tax_return.user.ssn
      assert found["user"]["street"]                 == business_tax_return.user.street
      assert found["user"]["zip"]                    == business_tax_return.user.zip
      assert found["user"]["inserted_at"]            == formatting_time(business_tax_return.user.inserted_at)
      assert found["user"]["updated_at"]             == formatting_time(business_tax_return.user.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessTaxReturn"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessTaxReturn"]

      assert found["id"]                             == business_tax_return.id
      assert found["inserted_at"]                    == formatting_time(business_tax_return.inserted_at)
      assert found["none_expat"]                     == business_tax_return.none_expat
      assert found["price_state"]                    == business_tax_return.price_state
      assert found["price_tax_year"]                 == business_tax_return.price_tax_year
      assert found["updated_at"]                     == formatting_time(business_tax_return.updated_at)
      assert found["user"]["id"]                     == business_tax_return.user.id
      assert found["user"]["active"]                 == business_tax_return.user.active
      assert found["user"]["avatar"]                 == business_tax_return.user.avatar
      assert found["user"]["bio"]                    == business_tax_return.user.bio
      assert found["user"]["birthday"]               == to_string(business_tax_return.user.birthday)
      assert found["user"]["email"]                  == business_tax_return.user.email
      assert found["user"]["first_name"]             == business_tax_return.user.first_name
      assert found["user"]["init_setup"]             == business_tax_return.user.init_setup
      assert found["user"]["last_name"]              == business_tax_return.user.last_name
      assert found["user"]["middle_name"]            == business_tax_return.user.middle_name
      assert found["user"]["phone"]                  == business_tax_return.user.phone
      assert found["user"]["provider"]               == business_tax_return.user.provider
      assert found["user"]["role"]                   == business_tax_return.user.role
      assert found["user"]["sex"]                    == business_tax_return.user.sex
      assert found["user"]["ssn"]                    == business_tax_return.user.ssn
      assert found["user"]["street"]                 == business_tax_return.user.street
      assert found["user"]["zip"]                    == business_tax_return.user.zip
      assert found["user"]["inserted_at"]            == formatting_time(business_tax_return.user.inserted_at)
      assert found["user"]["updated_at"]             == formatting_time(business_tax_return.user.updated_at)
    end
  end

  describe "#find" do
    it "find specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      context = %{current_user: user}

      query = """
      {
        findBusinessTaxReturn(id: \"#{business_tax_return.id}\") {
          id
          accounting_software
          capital_asset_sale
          church_hospital
          dispose_asset
          dispose_property
          educational_facility
          financial_situation
          foreign_account_interest
          foreign_account_value_more
          foreign_entity_interest
          foreign_partner_count
          foreign_shareholder
          foreign_value
          fundraising_over
          has_contribution
          has_loan
          income_over_thousand
          inserted_at
          invest_research
          k1_count
          lobbying
          make_distribution
          none_expat
          operate_facility
          property_sale
          public_charity
          rental_property_count
          reported_grant
          restricted_donation
          state
          tax_exemption
          tax_year
          total_asset_less
          total_asset_over
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

      {:ok, %{data: %{"findBusinessTaxReturn" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                             == business_tax_return.id
      assert found["accounting_software"]            == business_tax_return.accounting_software
      assert found["capital_asset_sale"]             == business_tax_return.capital_asset_sale
      assert found["church_hospital"]                == business_tax_return.church_hospital
      assert found["dispose_asset"]                  == business_tax_return.dispose_asset
      assert found["dispose_property"]               == business_tax_return.dispose_property
      assert found["educational_facility"]           == business_tax_return.educational_facility
      assert found["financial_situation"]            == business_tax_return.financial_situation
      assert found["foreign_account_interest"]       == business_tax_return.foreign_account_interest
      assert found["foreign_account_value_more"]     == business_tax_return.foreign_account_value_more
      assert found["foreign_entity_interest"]        == business_tax_return.foreign_entity_interest
      assert found["foreign_partner_count"]          == business_tax_return.foreign_partner_count
      assert found["foreign_shareholder"]            == business_tax_return.foreign_shareholder
      assert found["foreign_value"]                  == business_tax_return.foreign_value
      assert found["fundraising_over"]               == business_tax_return.fundraising_over
      assert found["has_contribution"]               == business_tax_return.has_contribution
      assert found["has_loan"]                       == business_tax_return.has_loan
      assert found["income_over_thousand"]           == business_tax_return.income_over_thousand
      assert found["inserted_at"]                    == formatting_time(business_tax_return.inserted_at)
      assert found["invest_research"]                == business_tax_return.invest_research
      assert found["k1_count"]                       == business_tax_return.k1_count
      assert found["lobbying"]                       == business_tax_return.lobbying
      assert found["make_distribution"]              == business_tax_return.make_distribution
      assert found["none_expat"]                     == business_tax_return.none_expat
      assert found["operate_facility"]               == business_tax_return.operate_facility
      assert found["property_sale"]                  == business_tax_return.property_sale
      assert found["public_charity"]                 == business_tax_return.public_charity
      assert found["rental_property_count"]          == business_tax_return.rental_property_count
      assert found["reported_grant"]                 == business_tax_return.reported_grant
      assert found["restricted_donation"]            == business_tax_return.restricted_donation
      assert found["state"]                          == business_tax_return.state
      assert found["tax_exemption"]                  == business_tax_return.tax_exemption
      assert found["tax_year"]                       == business_tax_return.tax_year
      assert found["total_asset_less"]               == business_tax_return.total_asset_less
      assert found["total_asset_over"]               == business_tax_return.total_asset_over
      assert found["updated_at"]                     == formatting_time(business_tax_return.updated_at)
      assert found["user"]["id"]                     == business_tax_return.user.id
      assert found["user"]["active"]                 == business_tax_return.user.active
      assert found["user"]["avatar"]                 == business_tax_return.user.avatar
      assert found["user"]["bio"]                    == business_tax_return.user.bio
      assert found["user"]["birthday"]               == to_string(business_tax_return.user.birthday)
      assert found["user"]["email"]                  == business_tax_return.user.email
      assert found["user"]["first_name"]             == business_tax_return.user.first_name
      assert found["user"]["init_setup"]             == business_tax_return.user.init_setup
      assert found["user"]["last_name"]              == business_tax_return.user.last_name
      assert found["user"]["middle_name"]            == business_tax_return.user.middle_name
      assert found["user"]["phone"]                  == business_tax_return.user.phone
      assert found["user"]["provider"]               == business_tax_return.user.provider
      assert found["user"]["role"]                   == business_tax_return.user.role
      assert found["user"]["sex"]                    == business_tax_return.user.sex
      assert found["user"]["ssn"]                    == business_tax_return.user.ssn
      assert found["user"]["street"]                 == business_tax_return.user.street
      assert found["user"]["zip"]                    == business_tax_return.user.zip
      assert found["user"]["inserted_at"]            == formatting_time(business_tax_return.user.inserted_at)
      assert found["user"]["updated_at"]             == formatting_time(business_tax_return.user.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessTaxReturn"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessTaxReturn"]

      assert found["id"]                             == business_tax_return.id
      assert found["accounting_software"]            == business_tax_return.accounting_software
      assert found["capital_asset_sale"]             == business_tax_return.capital_asset_sale
      assert found["church_hospital"]                == business_tax_return.church_hospital
      assert found["dispose_asset"]                  == business_tax_return.dispose_asset
      assert found["dispose_property"]               == business_tax_return.dispose_property
      assert found["educational_facility"]           == business_tax_return.educational_facility
      assert found["financial_situation"]            == business_tax_return.financial_situation
      assert found["foreign_account_interest"]       == business_tax_return.foreign_account_interest
      assert found["foreign_account_value_more"]     == business_tax_return.foreign_account_value_more
      assert found["foreign_entity_interest"]        == business_tax_return.foreign_entity_interest
      assert found["foreign_partner_count"]          == business_tax_return.foreign_partner_count
      assert found["foreign_shareholder"]            == business_tax_return.foreign_shareholder
      assert found["foreign_value"]                  == business_tax_return.foreign_value
      assert found["fundraising_over"]               == business_tax_return.fundraising_over
      assert found["has_contribution"]               == business_tax_return.has_contribution
      assert found["has_loan"]                       == business_tax_return.has_loan
      assert found["income_over_thousand"]           == business_tax_return.income_over_thousand
      assert found["inserted_at"]                    == formatting_time(business_tax_return.inserted_at)
      assert found["invest_research"]                == business_tax_return.invest_research
      assert found["k1_count"]                       == business_tax_return.k1_count
      assert found["lobbying"]                       == business_tax_return.lobbying
      assert found["make_distribution"]              == business_tax_return.make_distribution
      assert found["none_expat"]                     == business_tax_return.none_expat
      assert found["operate_facility"]               == business_tax_return.operate_facility
      assert found["property_sale"]                  == business_tax_return.property_sale
      assert found["public_charity"]                 == business_tax_return.public_charity
      assert found["rental_property_count"]          == business_tax_return.rental_property_count
      assert found["reported_grant"]                 == business_tax_return.reported_grant
      assert found["restricted_donation"]            == business_tax_return.restricted_donation
      assert found["state"]                          == business_tax_return.state
      assert found["tax_exemption"]                  == business_tax_return.tax_exemption
      assert found["tax_year"]                       == business_tax_return.tax_year
      assert found["total_asset_less"]               == business_tax_return.total_asset_less
      assert found["total_asset_over"]               == business_tax_return.total_asset_over
      assert found["updated_at"]                     == formatting_time(business_tax_return.updated_at)
      assert found["user"]["id"]                     == business_tax_return.user.id
      assert found["user"]["active"]                 == business_tax_return.user.active
      assert found["user"]["avatar"]                 == business_tax_return.user.avatar
      assert found["user"]["bio"]                    == business_tax_return.user.bio
      assert found["user"]["birthday"]               == to_string(business_tax_return.user.birthday)
      assert found["user"]["email"]                  == business_tax_return.user.email
      assert found["user"]["first_name"]             == business_tax_return.user.first_name
      assert found["user"]["init_setup"]             == business_tax_return.user.init_setup
      assert found["user"]["last_name"]              == business_tax_return.user.last_name
      assert found["user"]["middle_name"]            == business_tax_return.user.middle_name
      assert found["user"]["phone"]                  == business_tax_return.user.phone
      assert found["user"]["provider"]               == business_tax_return.user.provider
      assert found["user"]["role"]                   == business_tax_return.user.role
      assert found["user"]["sex"]                    == business_tax_return.user.sex
      assert found["user"]["ssn"]                    == business_tax_return.user.ssn
      assert found["user"]["street"]                 == business_tax_return.user.street
      assert found["user"]["zip"]                    == business_tax_return.user.zip
      assert found["user"]["inserted_at"]            == formatting_time(business_tax_return.user.inserted_at)
      assert found["user"]["updated_at"]             == formatting_time(business_tax_return.user.updated_at)
    end

    it "find specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      context = %{current_user: user}

      query = """
      {
        findBusinessTaxReturn(id: \"#{business_tax_return.id}\") {
          id
          inserted_at
          none_expat
          price_state
          price_tax_year
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

      {:ok, %{data: %{"findBusinessTaxReturn" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                             == business_tax_return.id
      assert found["inserted_at"]                    == formatting_time(business_tax_return.inserted_at)
      assert found["none_expat"]                     == business_tax_return.none_expat
      assert found["price_state"]                    == business_tax_return.price_state
      assert found["price_tax_year"]                 == business_tax_return.price_tax_year
      assert found["updated_at"]                     == formatting_time(business_tax_return.updated_at)
      assert found["user"]["id"]                     == business_tax_return.user.id
      assert found["user"]["active"]                 == business_tax_return.user.active
      assert found["user"]["avatar"]                 == business_tax_return.user.avatar
      assert found["user"]["bio"]                    == business_tax_return.user.bio
      assert found["user"]["birthday"]               == to_string(business_tax_return.user.birthday)
      assert found["user"]["email"]                  == business_tax_return.user.email
      assert found["user"]["first_name"]             == business_tax_return.user.first_name
      assert found["user"]["init_setup"]             == business_tax_return.user.init_setup
      assert found["user"]["last_name"]              == business_tax_return.user.last_name
      assert found["user"]["middle_name"]            == business_tax_return.user.middle_name
      assert found["user"]["phone"]                  == business_tax_return.user.phone
      assert found["user"]["provider"]               == business_tax_return.user.provider
      assert found["user"]["role"]                   == business_tax_return.user.role
      assert found["user"]["sex"]                    == business_tax_return.user.sex
      assert found["user"]["ssn"]                    == business_tax_return.user.ssn
      assert found["user"]["street"]                 == business_tax_return.user.street
      assert found["user"]["zip"]                    == business_tax_return.user.zip
      assert found["user"]["inserted_at"]            == formatting_time(business_tax_return.user.inserted_at)
      assert found["user"]["updated_at"]             == formatting_time(business_tax_return.user.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessTaxReturn"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessTaxReturn"]

      assert found["id"]                             == business_tax_return.id
      assert found["inserted_at"]                    == formatting_time(business_tax_return.inserted_at)
      assert found["none_expat"]                     == business_tax_return.none_expat
      assert found["price_state"]                    == business_tax_return.price_state
      assert found["price_tax_year"]                 == business_tax_return.price_tax_year
      assert found["updated_at"]                     == formatting_time(business_tax_return.updated_at)
      assert found["user"]["id"]                     == business_tax_return.user.id
      assert found["user"]["active"]                 == business_tax_return.user.active
      assert found["user"]["avatar"]                 == business_tax_return.user.avatar
      assert found["user"]["bio"]                    == business_tax_return.user.bio
      assert found["user"]["birthday"]               == to_string(business_tax_return.user.birthday)
      assert found["user"]["email"]                  == business_tax_return.user.email
      assert found["user"]["first_name"]             == business_tax_return.user.first_name
      assert found["user"]["init_setup"]             == business_tax_return.user.init_setup
      assert found["user"]["last_name"]              == business_tax_return.user.last_name
      assert found["user"]["middle_name"]            == business_tax_return.user.middle_name
      assert found["user"]["phone"]                  == business_tax_return.user.phone
      assert found["user"]["provider"]               == business_tax_return.user.provider
      assert found["user"]["role"]                   == business_tax_return.user.role
      assert found["user"]["sex"]                    == business_tax_return.user.sex
      assert found["user"]["ssn"]                    == business_tax_return.user.ssn
      assert found["user"]["street"]                 == business_tax_return.user.street
      assert found["user"]["zip"]                    == business_tax_return.user.zip
      assert found["user"]["inserted_at"]            == formatting_time(business_tax_return.user.inserted_at)
      assert found["user"]["updated_at"]             == formatting_time(business_tax_return.user.updated_at)
    end
  end

  describe "#create" do
    it "created BusinessTaxReturn by role's Tp" do
      insert(:match_value_relat)
      user = insert(:tp_user)

      mutation = """
      {
        createBusinessTaxReturn(
          accounting_software: true,
          capital_asset_sale: true,
          church_hospital: true,
          dispose_asset: true,
          dispose_property: true,
          educational_facility: true,
          financial_situation: "some financial situation",
          foreign_account_interest: true,
          foreign_account_value_more: true,
          foreign_entity_interest: true,
          foreign_partner_count: 12,
          foreign_shareholder: true,
          foreign_value: true,
          fundraising_over: true,
          has_contribution: true,
          has_loan: true,
          income_over_thousand: true,
          invest_research: true,
          k1_count: 12,
          lobbying: true,
          make_distribution: true,
          none_expat: true,
          operate_facility: true,
          property_sale: true,
          public_charity: true,
          rental_property_count: 12,
          reported_grant: true,
          restricted_donation: true,
          state: ["Alabama", "New York"],
          tax_exemption: true,
          tax_year: ["2017", "2018"],
          total_asset_less: true,
          total_asset_over: true,
          userId: \"#{user.id}\"
        ) {
          id
          accounting_software
          capital_asset_sale
          church_hospital
          dispose_asset
          dispose_property
          educational_facility
          financial_situation
          foreign_account_interest
          foreign_account_value_more
          foreign_entity_interest
          foreign_partner_count
          foreign_shareholder
          foreign_value
          fundraising_over
          has_contribution
          has_loan
          income_over_thousand
          inserted_at
          invest_research
          k1_count
          lobbying
          make_distribution
          none_expat
          operate_facility
          property_sale
          public_charity
          rental_property_count
          reported_grant
          restricted_donation
          state
          tax_exemption
          tax_year
          total_asset_less
          total_asset_over
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

      created = json_response(res, 200)["data"]["createBusinessTaxReturn"]

      assert created["accounting_software"]            == true
      assert created["capital_asset_sale"]             == true
      assert created["church_hospital"]                == true
      assert created["dispose_asset"]                  == true
      assert created["dispose_property"]               == true
      assert created["educational_facility"]           == true
      assert created["financial_situation"]            == "some financial situation"
      assert created["foreign_account_interest"]       == true
      assert created["foreign_account_value_more"]     == true
      assert created["foreign_entity_interest"]        == true
      assert created["foreign_partner_count"]          == 12
      assert created["foreign_shareholder"]            == true
      assert created["foreign_value"]                  == true
      assert created["fundraising_over"]               == true
      assert created["has_contribution"]               == true
      assert created["has_loan"]                       == true
      assert created["income_over_thousand"]           == true
      assert created["inserted_at"]                    == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["invest_research"]                == true
      assert created["k1_count"]                       == 12
      assert created["lobbying"]                       == true
      assert created["make_distribution"]              == true
      assert created["none_expat"]                     == true
      assert created["operate_facility"]               == true
      assert created["property_sale"]                  == true
      assert created["public_charity"]                 == true
      assert created["rental_property_count"]          == 12
      assert created["reported_grant"]                 == true
      assert created["restricted_donation"]            == true
      assert created["state"]                          == ["Alabama", "New York"]
      assert created["tax_exemption"]                  == true
      assert created["tax_year"]                       == ["2017", "2018"]
      assert created["total_asset_less"]               == true
      assert created["total_asset_over"]               == true
      assert created["updated_at"]                     == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["user"]["id"]                     == user.id
    end

    it "created BusinessTaxReturn by role's Pro" do
      insert(:match_value_relat)
      user = insert(:pro_user)

      mutation = """
      {
        createBusinessTaxReturn(
          none_expat: false,
          price_state: 12,
          price_tax_year: 12,
          userId: \"#{user.id}\"
        ) {
          id
          inserted_at
          none_expat
          price_state
          price_tax_year
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

      created = json_response(res, 200)["data"]["createBusinessTaxReturn"]

      assert created["inserted_at"]                    == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["none_expat"]                     == false
      assert created["price_state"]                    == 12
      assert created["price_tax_year"]                 == 12
      assert created["updated_at"]                     == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["user"]["id"]                     == user.id
    end
  end

  describe "#update" do
    it "updated specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})

      mutation = """
      {
        updateBusinessTaxReturn(
          id: \"#{business_tax_return.id}\",
          business_tax_return: {
            accounting_software: false,
            capital_asset_sale: false,
            church_hospital: false,
            dispose_asset: false,
            dispose_property: false,
            educational_facility: false,
            financial_situation: "updated some financial situation",
            foreign_account_interest: false,
            foreign_account_value_more: false,
            foreign_entity_interest: false,
            foreign_partner_count: 13,
            foreign_shareholder: false,
            foreign_value: false,
            fundraising_over: false,
            has_contribution: false,
            has_loan: false,
            income_over_thousand: false,
            invest_research: false,
            k1_count: 13,
            lobbying: false,
            make_distribution: false,
            none_expat: false,
            operate_facility: false,
            property_sale: false,
            public_charity: false,
            rental_property_count: 13,
            reported_grant: false,
            restricted_donation: false,
            state: ["Alabama"],
            tax_exemption: false,
            tax_year: ["2019"],
            total_asset_less: false,
            total_asset_over: false,
            userId: \"#{user.id}\"
          }
        )
        {
          id
          accounting_software
          capital_asset_sale
          church_hospital
          dispose_asset
          dispose_property
          educational_facility
          financial_situation
          foreign_account_interest
          foreign_account_value_more
          foreign_entity_interest
          foreign_partner_count
          foreign_shareholder
          foreign_value
          fundraising_over
          has_contribution
          has_loan
          income_over_thousand
          inserted_at
          invest_research
          k1_count
          lobbying
          make_distribution
          none_expat
          operate_facility
          property_sale
          public_charity
          rental_property_count
          reported_grant
          restricted_donation
          state
          tax_exemption
          tax_year
          total_asset_less
          total_asset_over
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

      updated = json_response(res, 200)["data"]["updateBusinessTaxReturn"]

      assert updated["id"]                             == business_tax_return.id
      assert updated["accounting_software"]            == false
      assert updated["capital_asset_sale"]             == false
      assert updated["church_hospital"]                == false
      assert updated["dispose_asset"]                  == false
      assert updated["dispose_property"]               == false
      assert updated["educational_facility"]           == false
      assert updated["financial_situation"]            == "updated some financial situation"
      assert updated["foreign_account_interest"]       == false
      assert updated["foreign_account_value_more"]     == false
      assert updated["foreign_entity_interest"]        == false
      assert updated["foreign_partner_count"]          == 13
      assert updated["foreign_shareholder"]            == false
      assert updated["foreign_value"]                  == false
      assert updated["fundraising_over"]               == false
      assert updated["has_contribution"]               == false
      assert updated["has_loan"]                       == false
      assert updated["income_over_thousand"]           == false
      assert updated["invest_research"]                == false
      assert updated["k1_count"]                       == 13
      assert updated["lobbying"]                       == false
      assert updated["make_distribution"]              == false
      assert updated["none_expat"]                     == false
      assert updated["operate_facility"]               == false
      assert updated["property_sale"]                  == false
      assert updated["public_charity"]                 == false
      assert updated["rental_property_count"]          == 13
      assert updated["reported_grant"]                 == false
      assert updated["restricted_donation"]            == false
      assert updated["state"]                          == ["Alabama"]
      assert updated["tax_exemption"]                  == false
      assert updated["tax_year"]                       == ["2019"]
      assert updated["total_asset_less"]               == false
      assert updated["total_asset_over"]               == false
      assert updated["inserted_at"]                    == formatting_time(business_tax_return.inserted_at)
      assert updated["updated_at"]                     == formatting_time(business_tax_return.updated_at)
      assert updated["user"]["id"]                     == user.id
      assert updated["user"]["active"]                 == business_tax_return.user.active
      assert updated["user"]["avatar"]                 == business_tax_return.user.avatar
      assert updated["user"]["bio"]                    == business_tax_return.user.bio
      assert updated["user"]["birthday"]               == to_string(business_tax_return.user.birthday)
      assert updated["user"]["email"]                  == business_tax_return.user.email
      assert updated["user"]["first_name"]             == business_tax_return.user.first_name
      assert updated["user"]["init_setup"]             == business_tax_return.user.init_setup
      assert updated["user"]["last_name"]              == business_tax_return.user.last_name
      assert updated["user"]["middle_name"]            == business_tax_return.user.middle_name
      assert updated["user"]["phone"]                  == business_tax_return.user.phone
      assert updated["user"]["provider"]               == business_tax_return.user.provider
      assert updated["user"]["role"]                   == business_tax_return.user.role
      assert updated["user"]["sex"]                    == business_tax_return.user.sex
      assert updated["user"]["ssn"]                    == business_tax_return.user.ssn
      assert updated["user"]["street"]                 == business_tax_return.user.street
      assert updated["user"]["zip"]                    == business_tax_return.user.zip
      assert updated["user"]["inserted_at"]            == formatting_time(business_tax_return.user.inserted_at)
      assert updated["user"]["updated_at"]             == formatting_time(business_tax_return.user.updated_at)
    end

    it "updated specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})

      mutation = """
      {
        updateBusinessTaxReturn(
          id: \"#{business_tax_return.id}\",
          business_tax_return: {
            none_expat: true,
            price_state: 13,
            price_tax_year: 13,
            userId: \"#{user.id}\"
          }
        )
        {
          id
          inserted_at
          none_expat
          price_state
          price_tax_year
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

      updated = json_response(res, 200)["data"]["updateBusinessTaxReturn"]

      assert updated["id"]                             == business_tax_return.id
      assert updated["inserted_at"]                    == formatting_time(business_tax_return.inserted_at)
      assert updated["none_expat"]                     == true
      assert updated["price_state"]                    == 13
      assert updated["price_tax_year"]                 == 13
      assert updated["updated_at"]                     == formatting_time(business_tax_return.updated_at)
      assert updated["user"]["id"]                     == user.id
      assert updated["user"]["active"]                 == business_tax_return.user.active
      assert updated["user"]["avatar"]                 == business_tax_return.user.avatar
      assert updated["user"]["bio"]                    == business_tax_return.user.bio
      assert updated["user"]["birthday"]               == to_string(business_tax_return.user.birthday)
      assert updated["user"]["email"]                  == business_tax_return.user.email
      assert updated["user"]["first_name"]             == business_tax_return.user.first_name
      assert updated["user"]["init_setup"]             == business_tax_return.user.init_setup
      assert updated["user"]["last_name"]              == business_tax_return.user.last_name
      assert updated["user"]["middle_name"]            == business_tax_return.user.middle_name
      assert updated["user"]["phone"]                  == business_tax_return.user.phone
      assert updated["user"]["provider"]               == business_tax_return.user.provider
      assert updated["user"]["role"]                   == business_tax_return.user.role
      assert updated["user"]["sex"]                    == business_tax_return.user.sex
      assert updated["user"]["ssn"]                    == business_tax_return.user.ssn
      assert updated["user"]["street"]                 == business_tax_return.user.street
      assert updated["user"]["zip"]                    == business_tax_return.user.zip
      assert updated["user"]["inserted_at"]            == formatting_time(business_tax_return.user.inserted_at)
      assert updated["user"]["updated_at"]             == formatting_time(business_tax_return.user.updated_at)
    end
  end

  describe "#delete" do
    it "delete specific BusinessTaxReturn" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)

      mutation = """
      {
        deleteBusinessTaxReturn(id: \"#{business_tax_return.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteBusinessTaxReturn"]
      assert deleted["id"] == business_tax_return.id
    end
  end


  describe "#dataloads" do
    it "created BusinessTaxReturn by role's Tp" do
       %{id: user_id} = insert(:tp_user)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:business_tax_returns, source)
        |> Dataloader.load(:business_tax_returns, Core.Accounts.User, user_id)
        |> Dataloader.run

      data = Dataloader.get(loader, :business_tax_returns, Core.Accounts.User, user_id)

      assert data.id == user_id
    end
  end

  defp formatting_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

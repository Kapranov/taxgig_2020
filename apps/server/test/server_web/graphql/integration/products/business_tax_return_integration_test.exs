defmodule ServerWeb.GraphQL.Integration.Products.BusinessTaxReturnIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_business_tax_return, %{user: user})
      insert(:tp_business_entity_type, business_tax_returns: struct)
      insert(:tp_business_foreign_account_count, business_tax_returns: struct)
      insert(:tp_business_foreign_ownership_count, business_tax_returns: struct)
      insert(:tp_business_llc_type, business_tax_returns: struct)
      insert(:tp_business_industry, business_tax_returns: struct)
      insert(:tp_business_number_employee, business_tax_returns: struct)
      insert(:tp_business_total_revenue, business_tax_returns: struct)
      insert(:tp_business_transaction_count, business_tax_returns: struct)
      context = %{current_user: user}

      query = """
      {
        allBusinessTaxReturns {
          id
          accounting_software
          capital_asset_sale
          church_hospital
          deadline
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
          businessEntityTypes { id name }
          businessForeignAccountCounts { id name }
          businessForeignOwnershipCounts { id name }
          businessLlcTypes { id name }
          businessIndustries { id name }
          businessNumberEmployees { id name }
          businessTotalRevenues { id name }
          businessTransactionCounts { id name }
          user { id email role}
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessTaxReturns"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessTaxReturns"]

      assert List.first(data)["id"]                         == struct.id
      assert List.first(data)["accounting_software"]        == struct.accounting_software
      assert List.first(data)["capital_asset_sale"]         == struct.capital_asset_sale
      assert List.first(data)["church_hospital"]            == struct.church_hospital
      assert List.first(data)["deadline"]                   == format_deadline(struct.deadline)
      assert List.first(data)["dispose_asset"]              == struct.dispose_asset
      assert List.first(data)["dispose_property"]           == struct.dispose_property
      assert List.first(data)["educational_facility"]       == struct.educational_facility
      assert List.first(data)["financial_situation"]        == struct.financial_situation
      assert List.first(data)["foreign_account_interest"]   == struct.foreign_account_interest
      assert List.first(data)["foreign_account_value_more"] == struct.foreign_account_value_more
      assert List.first(data)["foreign_entity_interest"]    == struct.foreign_entity_interest
      assert List.first(data)["foreign_partner_count"]      == struct.foreign_partner_count
      assert List.first(data)["foreign_shareholder"]        == struct.foreign_shareholder
      assert List.first(data)["foreign_value"]              == struct.foreign_value
      assert List.first(data)["fundraising_over"]           == struct.fundraising_over
      assert List.first(data)["has_contribution"]           == struct.has_contribution
      assert List.first(data)["has_loan"]                   == struct.has_loan
      assert List.first(data)["income_over_thousand"]       == struct.income_over_thousand
      assert List.first(data)["invest_research"]            == struct.invest_research
      assert List.first(data)["k1_count"]                   == struct.k1_count
      assert List.first(data)["lobbying"]                   == struct.lobbying
      assert List.first(data)["make_distribution"]          == struct.make_distribution
      assert List.first(data)["none_expat"]                 == struct.none_expat
      assert List.first(data)["operate_facility"]           == struct.operate_facility
      assert List.first(data)["property_sale"]              == struct.property_sale
      assert List.first(data)["public_charity"]             == struct.public_charity
      assert List.first(data)["rental_property_count"]      == struct.rental_property_count
      assert List.first(data)["reported_grant"]             == struct.reported_grant
      assert List.first(data)["restricted_donation"]        == struct.restricted_donation
      assert List.first(data)["state"]                      == struct.state
      assert List.first(data)["tax_exemption"]              == struct.tax_exemption
      assert List.first(data)["tax_year"]                   == struct.tax_year
      assert List.first(data)["total_asset_less"]           == struct.total_asset_less
      assert List.first(data)["total_asset_over"]           == struct.total_asset_over
      assert List.first(data)["user"]["id"]                 == user.id
      assert List.first(data)["user"]["email"]              == user.email
      assert List.first(data)["user"]["role"]               == user.role

      {:ok, %{data: %{"allBusinessTaxReturns" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                         == struct.id
      assert first["accounting_software"]        == struct.accounting_software
      assert first["capital_asset_sale"]         == struct.capital_asset_sale
      assert first["church_hospital"]            == struct.church_hospital
      assert first["deadline"]                   == format_deadline(struct.deadline)
      assert first["dispose_asset"]              == struct.dispose_asset
      assert first["dispose_property"]           == struct.dispose_property
      assert first["educational_facility"]       == struct.educational_facility
      assert first["financial_situation"]        == struct.financial_situation
      assert first["foreign_account_interest"]   == struct.foreign_account_interest
      assert first["foreign_account_value_more"] == struct.foreign_account_value_more
      assert first["foreign_entity_interest"]    == struct.foreign_entity_interest
      assert first["foreign_partner_count"]      == struct.foreign_partner_count
      assert first["foreign_shareholder"]        == struct.foreign_shareholder
      assert first["foreign_value"]              == struct.foreign_value
      assert first["fundraising_over"]           == struct.fundraising_over
      assert first["has_contribution"]           == struct.has_contribution
      assert first["has_loan"]                   == struct.has_loan
      assert first["income_over_thousand"]       == struct.income_over_thousand
      assert first["invest_research"]            == struct.invest_research
      assert first["k1_count"]                   == struct.k1_count
      assert first["lobbying"]                   == struct.lobbying
      assert first["make_distribution"]          == struct.make_distribution
      assert first["none_expat"]                 == struct.none_expat
      assert first["operate_facility"]           == struct.operate_facility
      assert first["property_sale"]              == struct.property_sale
      assert first["public_charity"]             == struct.public_charity
      assert first["rental_property_count"]      == struct.rental_property_count
      assert first["reported_grant"]             == struct.reported_grant
      assert first["restricted_donation"]        == struct.restricted_donation
      assert first["state"]                      == struct.state
      assert first["tax_exemption"]              == struct.tax_exemption
      assert first["tax_year"]                   == struct.tax_year
      assert first["total_asset_less"]           == struct.total_asset_less
      assert first["total_asset_over"]           == struct.total_asset_over
      assert first["user"]["id"]                 == user.id
      assert first["user"]["email"]              == user.email
      assert first["user"]["role"]               == user.role
    end

    it "returns BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_business_tax_return, %{user: user})
      insert(:tp_business_entity_type, business_tax_returns: struct)
      insert(:tp_business_number_employee, business_tax_returns: struct)
      insert(:tp_business_total_revenue, business_tax_returns: struct)
      context = %{current_user: user}

      query = """
      {
        allBusinessTaxReturns {
          id
          none_expat
          price_state
          price_tax_year
          businessEntityTypes { id name price }
          businessNumberEmployees { id name price }
          businessTotalRevenues { id name price }
          user { id email role}
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessTaxReturns"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessTaxReturns"]

      assert List.first(data)["id"]             == struct.id
      assert List.first(data)["none_expat"]     == struct.none_expat
      assert List.first(data)["price_state"]    == struct.price_state
      assert List.first(data)["price_tax_year"] == struct.price_tax_year
      assert List.first(data)["user"]["id"]     == user.id
      assert List.first(data)["user"]["email"]  == user.email
      assert List.first(data)["user"]["role"]   == user.role

      {:ok, %{data: %{"allBusinessTaxReturns" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]             == struct.id
      assert first["none_expat"]     == struct.none_expat
      assert first["price_state"]    == struct.price_state
      assert first["price_tax_year"] == struct.price_tax_year
      assert first["user"]["id"]     == user.id
      assert first["user"]["email"]  == user.email
      assert first["user"]["role"]   == user.role
    end
  end

  describe "#show" do
    it "returns specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_business_tax_return, %{user: user})
      insert(:tp_business_entity_type, business_tax_returns: struct)
      insert(:tp_business_foreign_account_count, business_tax_returns: struct)
      insert(:tp_business_foreign_ownership_count, business_tax_returns: struct)
      insert(:tp_business_llc_type, business_tax_returns: struct)
      insert(:tp_business_industry, business_tax_returns: struct)
      insert(:tp_business_number_employee, business_tax_returns: struct)
      insert(:tp_business_total_revenue, business_tax_returns: struct)
      insert(:tp_business_transaction_count, business_tax_returns: struct)
      context = %{current_user: user}

      query = """
      {
        showBusinessTaxReturn(id: \"#{struct.id}\") {
          id
          accounting_software
          capital_asset_sale
          church_hospital
          deadline
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
          businessEntityTypes { id name }
          businessForeignAccountCounts { id name }
          businessForeignOwnershipCounts { id name }
          businessLlcTypes { id name }
          businessIndustries { id name }
          businessNumberEmployees { id name }
          businessTotalRevenues { id name }
          businessTransactionCounts { id name }
          user { id email role}
        }
      }
      """

      {:ok, %{data: %{"showBusinessTaxReturn" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                         == struct.id
      assert found["accounting_software"]        == struct.accounting_software
      assert found["capital_asset_sale"]         == struct.capital_asset_sale
      assert found["church_hospital"]            == struct.church_hospital
      assert found["deadline"]                   == format_deadline(struct.deadline)
      assert found["dispose_asset"]              == struct.dispose_asset
      assert found["dispose_property"]           == struct.dispose_property
      assert found["educational_facility"]       == struct.educational_facility
      assert found["financial_situation"]        == struct.financial_situation
      assert found["foreign_account_interest"]   == struct.foreign_account_interest
      assert found["foreign_account_value_more"] == struct.foreign_account_value_more
      assert found["foreign_entity_interest"]    == struct.foreign_entity_interest
      assert found["foreign_partner_count"]      == struct.foreign_partner_count
      assert found["foreign_shareholder"]        == struct.foreign_shareholder
      assert found["foreign_value"]              == struct.foreign_value
      assert found["fundraising_over"]           == struct.fundraising_over
      assert found["has_contribution"]           == struct.has_contribution
      assert found["has_loan"]                   == struct.has_loan
      assert found["income_over_thousand"]       == struct.income_over_thousand
      assert found["invest_research"]            == struct.invest_research
      assert found["k1_count"]                   == struct.k1_count
      assert found["lobbying"]                   == struct.lobbying
      assert found["make_distribution"]          == struct.make_distribution
      assert found["none_expat"]                 == struct.none_expat
      assert found["operate_facility"]           == struct.operate_facility
      assert found["property_sale"]              == struct.property_sale
      assert found["public_charity"]             == struct.public_charity
      assert found["rental_property_count"]      == struct.rental_property_count
      assert found["reported_grant"]             == struct.reported_grant
      assert found["restricted_donation"]        == struct.restricted_donation
      assert found["state"]                      == struct.state
      assert found["tax_exemption"]              == struct.tax_exemption
      assert found["tax_year"]                   == struct.tax_year
      assert found["total_asset_less"]           == struct.total_asset_less
      assert found["total_asset_over"]           == struct.total_asset_over
      assert found["user"]["id"]                 == user.id
      assert found["user"]["email"]              == user.email
      assert found["user"]["role"]               == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessTaxReturn"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessTaxReturn"]

      assert found["id"]                         == struct.id
      assert found["accounting_software"]        == struct.accounting_software
      assert found["capital_asset_sale"]         == struct.capital_asset_sale
      assert found["church_hospital"]            == struct.church_hospital
      assert found["deadline"]                   == format_deadline(struct.deadline)
      assert found["dispose_asset"]              == struct.dispose_asset
      assert found["dispose_property"]           == struct.dispose_property
      assert found["educational_facility"]       == struct.educational_facility
      assert found["financial_situation"]        == struct.financial_situation
      assert found["foreign_account_interest"]   == struct.foreign_account_interest
      assert found["foreign_account_value_more"] == struct.foreign_account_value_more
      assert found["foreign_entity_interest"]    == struct.foreign_entity_interest
      assert found["foreign_partner_count"]      == struct.foreign_partner_count
      assert found["foreign_shareholder"]        == struct.foreign_shareholder
      assert found["foreign_value"]              == struct.foreign_value
      assert found["fundraising_over"]           == struct.fundraising_over
      assert found["has_contribution"]           == struct.has_contribution
      assert found["has_loan"]                   == struct.has_loan
      assert found["income_over_thousand"]       == struct.income_over_thousand
      assert found["invest_research"]            == struct.invest_research
      assert found["k1_count"]                   == struct.k1_count
      assert found["lobbying"]                   == struct.lobbying
      assert found["make_distribution"]          == struct.make_distribution
      assert found["none_expat"]                 == struct.none_expat
      assert found["operate_facility"]           == struct.operate_facility
      assert found["property_sale"]              == struct.property_sale
      assert found["public_charity"]             == struct.public_charity
      assert found["rental_property_count"]      == struct.rental_property_count
      assert found["reported_grant"]             == struct.reported_grant
      assert found["restricted_donation"]        == struct.restricted_donation
      assert found["state"]                      == struct.state
      assert found["tax_exemption"]              == struct.tax_exemption
      assert found["tax_year"]                   == struct.tax_year
      assert found["total_asset_less"]           == struct.total_asset_less
      assert found["total_asset_over"]           == struct.total_asset_over
      assert found["user"]["id"]                 == user.id
      assert found["user"]["email"]              == user.email
      assert found["user"]["role"]               == user.role
    end

    it "returns specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_business_tax_return, %{user: user})
      insert(:tp_business_entity_type, business_tax_returns: struct)
      insert(:tp_business_number_employee, business_tax_returns: struct)
      insert(:tp_business_total_revenue, business_tax_returns: struct)
      context = %{current_user: user}

      query = """
      {
        showBusinessTaxReturn(id: \"#{struct.id}\") {
          id
          none_expat
          price_state
          price_tax_year
          businessEntityTypes { id name price }
          businessNumberEmployees { id name price }
          businessTotalRevenues { id name price }
          user { id email role}
        }
      }
      """

      {:ok, %{data: %{"showBusinessTaxReturn" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]             == struct.id
      assert found["none_expat"]     == struct.none_expat
      assert found["price_state"]    == struct.price_state
      assert found["price_tax_year"] == struct.price_tax_year
      assert found["user"]["id"]     == user.id
      assert found["user"]["email"]  == user.email
      assert found["user"]["role"]   == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessTaxReturn"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessTaxReturn"]

      assert found["id"]             == struct.id
      assert found["none_expat"]     == struct.none_expat
      assert found["price_state"]    == struct.price_state
      assert found["price_tax_year"] == struct.price_tax_year
      assert found["user"]["id"]     == user.id
      assert found["user"]["email"]  == user.email
      assert found["user"]["role"]   == user.role
    end
  end

  describe "#find" do
    it "returns specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_business_tax_return, %{user: user})
      insert(:tp_business_entity_type, business_tax_returns: struct)
      insert(:tp_business_foreign_account_count, business_tax_returns: struct)
      insert(:tp_business_foreign_ownership_count, business_tax_returns: struct)
      insert(:tp_business_llc_type, business_tax_returns: struct)
      insert(:tp_business_industry, business_tax_returns: struct)
      insert(:tp_business_number_employee, business_tax_returns: struct)
      insert(:tp_business_total_revenue, business_tax_returns: struct)
      insert(:tp_business_transaction_count, business_tax_returns: struct)
      context = %{current_user: user}

      query = """
      {
        findBusinessTaxReturn(id: \"#{struct.id}\") {
          id
          accounting_software
          capital_asset_sale
          church_hospital
          deadline
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
          businessEntityTypes { id name }
          businessForeignAccountCounts { id name }
          businessForeignOwnershipCounts { id name }
          businessLlcTypes { id name }
          businessIndustries { id name }
          businessNumberEmployees { id name }
          businessTotalRevenues { id name }
          businessTransactionCounts { id name }
          user { id email role}
        }
      }
      """

      {:ok, %{data: %{"findBusinessTaxReturn" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                         == struct.id
      assert found["accounting_software"]        == struct.accounting_software
      assert found["capital_asset_sale"]         == struct.capital_asset_sale
      assert found["church_hospital"]            == struct.church_hospital
      assert found["deadline"]                   == format_deadline(struct.deadline)
      assert found["dispose_asset"]              == struct.dispose_asset
      assert found["dispose_property"]           == struct.dispose_property
      assert found["educational_facility"]       == struct.educational_facility
      assert found["financial_situation"]        == struct.financial_situation
      assert found["foreign_account_interest"]   == struct.foreign_account_interest
      assert found["foreign_account_value_more"] == struct.foreign_account_value_more
      assert found["foreign_entity_interest"]    == struct.foreign_entity_interest
      assert found["foreign_partner_count"]      == struct.foreign_partner_count
      assert found["foreign_shareholder"]        == struct.foreign_shareholder
      assert found["foreign_value"]              == struct.foreign_value
      assert found["fundraising_over"]           == struct.fundraising_over
      assert found["has_contribution"]           == struct.has_contribution
      assert found["has_loan"]                   == struct.has_loan
      assert found["income_over_thousand"]       == struct.income_over_thousand
      assert found["invest_research"]            == struct.invest_research
      assert found["k1_count"]                   == struct.k1_count
      assert found["lobbying"]                   == struct.lobbying
      assert found["make_distribution"]          == struct.make_distribution
      assert found["none_expat"]                 == struct.none_expat
      assert found["operate_facility"]           == struct.operate_facility
      assert found["property_sale"]              == struct.property_sale
      assert found["public_charity"]             == struct.public_charity
      assert found["rental_property_count"]      == struct.rental_property_count
      assert found["reported_grant"]             == struct.reported_grant
      assert found["restricted_donation"]        == struct.restricted_donation
      assert found["state"]                      == struct.state
      assert found["tax_exemption"]              == struct.tax_exemption
      assert found["tax_year"]                   == struct.tax_year
      assert found["total_asset_less"]           == struct.total_asset_less
      assert found["total_asset_over"]           == struct.total_asset_over
      assert found["user"]["id"]                 == user.id
      assert found["user"]["email"]              == user.email
      assert found["user"]["role"]               == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessTaxReturn"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessTaxReturn"]

      assert found["id"]                         == struct.id
      assert found["accounting_software"]        == struct.accounting_software
      assert found["capital_asset_sale"]         == struct.capital_asset_sale
      assert found["church_hospital"]            == struct.church_hospital
      assert found["deadline"]                   == format_deadline(struct.deadline)
      assert found["dispose_asset"]              == struct.dispose_asset
      assert found["dispose_property"]           == struct.dispose_property
      assert found["educational_facility"]       == struct.educational_facility
      assert found["financial_situation"]        == struct.financial_situation
      assert found["foreign_account_interest"]   == struct.foreign_account_interest
      assert found["foreign_account_value_more"] == struct.foreign_account_value_more
      assert found["foreign_entity_interest"]    == struct.foreign_entity_interest
      assert found["foreign_partner_count"]      == struct.foreign_partner_count
      assert found["foreign_shareholder"]        == struct.foreign_shareholder
      assert found["foreign_value"]              == struct.foreign_value
      assert found["fundraising_over"]           == struct.fundraising_over
      assert found["has_contribution"]           == struct.has_contribution
      assert found["has_loan"]                   == struct.has_loan
      assert found["income_over_thousand"]       == struct.income_over_thousand
      assert found["invest_research"]            == struct.invest_research
      assert found["k1_count"]                   == struct.k1_count
      assert found["lobbying"]                   == struct.lobbying
      assert found["make_distribution"]          == struct.make_distribution
      assert found["none_expat"]                 == struct.none_expat
      assert found["operate_facility"]           == struct.operate_facility
      assert found["property_sale"]              == struct.property_sale
      assert found["public_charity"]             == struct.public_charity
      assert found["rental_property_count"]      == struct.rental_property_count
      assert found["reported_grant"]             == struct.reported_grant
      assert found["restricted_donation"]        == struct.restricted_donation
      assert found["state"]                      == struct.state
      assert found["tax_exemption"]              == struct.tax_exemption
      assert found["tax_year"]                   == struct.tax_year
      assert found["total_asset_less"]           == struct.total_asset_less
      assert found["total_asset_over"]           == struct.total_asset_over
      assert found["user"]["id"]                 == user.id
      assert found["user"]["email"]              == user.email
      assert found["user"]["role"]               == user.role
    end

    it "returns specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_business_tax_return, %{user: user})
      insert(:tp_business_entity_type, business_tax_returns: struct)
      insert(:tp_business_number_employee, business_tax_returns: struct)
      insert(:tp_business_total_revenue, business_tax_returns: struct)
      context = %{current_user: user}

      query = """
      {
        findBusinessTaxReturn(id: \"#{struct.id}\") {
          id
          none_expat
          price_state
          price_tax_year
          businessEntityTypes { id name price }
          businessNumberEmployees { id name price }
          businessTotalRevenues { id name price }
          user { id email role}
        }
      }
      """

      {:ok, %{data: %{"findBusinessTaxReturn" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]             == struct.id
      assert found["none_expat"]     == struct.none_expat
      assert found["price_state"]    == struct.price_state
      assert found["price_tax_year"] == struct.price_tax_year
      assert found["user"]["id"]     == user.id
      assert found["user"]["email"]  == user.email
      assert found["user"]["role"]   == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessTaxReturn"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessTaxReturn"]

      assert found["id"]             == struct.id
      assert found["none_expat"]     == struct.none_expat
      assert found["price_state"]    == struct.price_state
      assert found["price_tax_year"] == struct.price_tax_year
      assert found["user"]["id"]     == user.id
      assert found["user"]["email"]  == user.email
      assert found["user"]["role"]   == user.role
    end
  end

  describe "#create" do
    it "created BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)

      mutation = """
      {
        createBusinessTaxReturn(
          accounting_software: true,
          capital_asset_sale: true,
          church_hospital: true,
          deadline: \"#{Date.utc_today()}\",
          dispose_asset: true,
          dispose_property: true,
          educational_facility: true,
          financial_situation: "some text",
          foreign_account_interest: true,
          foreign_account_value_more: true,
          foreign_entity_interest: true,
          foreign_partner_count: 22,
          foreign_shareholder: true,
          foreign_value: true,
          fundraising_over: true,
          has_contribution: true,
          has_loan: true,
          income_over_thousand: true,
          invest_research: true,
          k1_count: 22,
          lobbying: true,
          make_distribution: true,
          none_expat: true,
          operate_facility: true,
          property_sale: true,
          public_charity: true,
          rental_property_count: 22,
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
          deadline
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
          businessEntityTypes { id name }
          businessForeignAccountCounts { id name }
          businessForeignOwnershipCounts { id name }
          businessLlcTypes { id name }
          businessIndustries { id name }
          businessNumberEmployees { id name }
          businessTotalRevenues { id name }
          businessTransactionCounts { id name }
          user { id email role}
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createBusinessTaxReturn"]

      assert created["accounting_software"]        == true
      assert created["capital_asset_sale"]         == true
      assert created["church_hospital"]            == true
      assert created["deadline"]                   == format_deadline(Date.utc_today())
      assert created["dispose_asset"]              == true
      assert created["dispose_property"]           == true
      assert created["educational_facility"]       == true
      assert created["financial_situation"]        == "some text"
      assert created["foreign_account_interest"]   == true
      assert created["foreign_account_value_more"] == true
      assert created["foreign_entity_interest"]    == true
      assert created["foreign_partner_count"]      == 22
      assert created["foreign_shareholder"]        == true
      assert created["foreign_value"]              == true
      assert created["fundraising_over"]           == true
      assert created["has_contribution"]           == true
      assert created["has_loan"]                   == true
      assert created["income_over_thousand"]       == true
      assert created["invest_research"]            == true
      assert created["k1_count"]                   == 22
      assert created["lobbying"]                   == true
      assert created["make_distribution"]          == true
      assert created["none_expat"]                 == true
      assert created["operate_facility"]           == true
      assert created["property_sale"]              == true
      assert created["public_charity"]             == true
      assert created["rental_property_count"]      == 22
      assert created["reported_grant"]             == true
      assert created["restricted_donation"]        == true
      assert created["state"]                      == ["Alabama", "New York"]
      assert created["tax_exemption"]              == true
      assert created["tax_year"]                   == ["2017", "2018"]
      assert created["total_asset_less"]           == true
      assert created["total_asset_over"]           == true
      assert created["user"]["id"]                 == user.id
      assert created["user"]["email"]              == user.email
      assert created["user"]["role"]               == user.role
    end

    it "created BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)

      mutation = """
      {
        createBusinessTaxReturn(
          none_expat: true,
          price_state: 22,
          price_tax_year: 22,
          userId: \"#{user.id}\"
        ) {
          id
          none_expat
          price_state
          price_tax_year
          businessEntityTypes { id name price }
          businessNumberEmployees { id name price }
          businessTotalRevenues { id name price }
          user { id email role}
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createBusinessTaxReturn"]

      assert created["none_expat"]     == true
      assert created["price_state"]    == 22
      assert created["price_tax_year"] == 22
      assert created["user"]["id"]     == user.id
      assert created["user"]["email"]  == user.email
      assert created["user"]["role"]   == user.role
    end
  end

  describe "#update" do
    it "updated specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_business_tax_return, %{user: user})
      insert(:tp_business_entity_type, business_tax_returns: struct)
      insert(:tp_business_foreign_account_count, business_tax_returns: struct)
      insert(:tp_business_foreign_ownership_count, business_tax_returns: struct)
      insert(:tp_business_llc_type, business_tax_returns: struct)
      insert(:tp_business_industry, business_tax_returns: struct)
      insert(:tp_business_number_employee, business_tax_returns: struct)
      insert(:tp_business_total_revenue, business_tax_returns: struct)
      insert(:tp_business_transaction_count, business_tax_returns: struct)

      mutation = """
      {
        updateBusinessTaxReturn(
          id: \"#{struct.id}\",
          businessTaxReturn: {
            accounting_software: false,
            capital_asset_sale: false,
            church_hospital: false,
            deadline: \"#{Date.utc_today |> Date.add(-3)}\",
            dispose_asset: false,
            dispose_property: false,
            educational_facility: false,
            financial_situation: "updated text",
            foreign_account_interest: false,
            foreign_account_value_more: false,
            foreign_entity_interest: false,
            foreign_partner_count: 33,
            foreign_shareholder: false,
            foreign_value: false,
            fundraising_over: false,
            has_contribution: false,
            has_loan: false,
            income_over_thousand: false,
            invest_research: false,
            k1_count: 33,
            lobbying: false,
            make_distribution: false,
            none_expat: false,
            operate_facility: false,
            property_sale: false,
            public_charity: false,
            rental_property_count: 33,
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
          deadline
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
          businessEntityTypes { id name }
          businessForeignAccountCounts { id name }
          businessForeignOwnershipCounts { id name }
          businessLlcTypes { id name }
          businessIndustries { id name }
          businessNumberEmployees { id name }
          businessTotalRevenues { id name }
          businessTransactionCounts { id name }
          user { id email role}
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateBusinessTaxReturn"]

      assert updated["id"]                         == struct.id
      assert updated["accounting_software"]        == false
      assert updated["capital_asset_sale"]         == false
      assert updated["church_hospital"]            == false
      assert updated["deadline"]                   == format_deadline(Date.utc_today |> Date.add(-3))
      assert updated["dispose_asset"]              == false
      assert updated["dispose_property"]           == false
      assert updated["educational_facility"]       == false
      assert updated["financial_situation"]        == "updated text"
      assert updated["foreign_account_interest"]   == false
      assert updated["foreign_account_value_more"] == false
      assert updated["foreign_entity_interest"]    == false
      assert updated["foreign_partner_count"]      == 33
      assert updated["foreign_shareholder"]        == false
      assert updated["foreign_value"]              == false
      assert updated["fundraising_over"]           == false
      assert updated["has_contribution"]           == false
      assert updated["has_loan"]                   == false
      assert updated["income_over_thousand"]       == false
      assert updated["invest_research"]            == false
      assert updated["k1_count"]                   == 33
      assert updated["lobbying"]                   == false
      assert updated["make_distribution"]          == false
      assert updated["none_expat"]                 == false
      assert updated["operate_facility"]           == false
      assert updated["property_sale"]              == false
      assert updated["public_charity"]             == false
      assert updated["rental_property_count"]      == 33
      assert updated["reported_grant"]             == false
      assert updated["restricted_donation"]        == false
      assert updated["state"]                      == ["Alabama"]
      assert updated["tax_exemption"]              == false
      assert updated["tax_year"]                   == ["2019"]
      assert updated["total_asset_less"]           == false
      assert updated["total_asset_over"]           == false
      assert updated["user"]["id"]                 == user.id
      assert updated["user"]["email"]              == user.email
      assert updated["user"]["role"]               == user.role
    end

    it "updated specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_business_tax_return, %{user: user})
      insert(:tp_business_entity_type, business_tax_returns: struct)
      insert(:tp_business_number_employee, business_tax_returns: struct)
      insert(:tp_business_total_revenue, business_tax_returns: struct)

      mutation = """
      {
        updateBusinessTaxReturn(
          id: \"#{struct.id}\",
          businessTaxReturn: {
            none_expat: false,
            price_state: 33,
            price_tax_year: 33,
            userId: \"#{user.id}\"
          }
        )
        {
          id
          none_expat
          price_state
          price_tax_year
          businessEntityTypes { id name price }
          businessNumberEmployees { id name price }
          businessTotalRevenues { id name price }
          user { id email role}
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateBusinessTaxReturn"]

      assert updated["id"]             == struct.id
      assert updated["none_expat"]     == false
      assert updated["price_state"]    == 33
      assert updated["price_tax_year"] == 33
      assert updated["user"]["id"]     == user.id
      assert updated["user"]["email"]  == user.email
      assert updated["user"]["role"]   == user.role
    end
  end

  describe "#delete" do
    it "delete specific BusinessTaxReturn" do
      user = insert(:user)
      struct = insert(:business_tax_return, %{user: user})
      insert(:tp_business_entity_type, business_tax_returns: struct)
      insert(:tp_business_number_employee, business_tax_returns: struct)
      insert(:tp_business_total_revenue, business_tax_returns: struct)

      mutation = """
      {
        deleteBusinessTaxReturn(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteBusinessTaxReturn"]
      assert deleted["id"] == struct.id
    end
  end

  describe "#dataloads" do
    it "created BusinessTaxReturn" do
      user = insert(:user)
      struct = %{id: id} = insert(:business_tax_return, %{user: user})
      insert(:tp_business_entity_type, business_tax_returns: struct)
      insert(:tp_business_foreign_account_count, business_tax_returns: struct)
      insert(:tp_business_foreign_ownership_count, business_tax_returns: struct)
      insert(:tp_business_llc_type, business_tax_returns: struct)
      insert(:tp_business_industry, business_tax_returns: struct)
      insert(:tp_business_number_employee, business_tax_returns: struct)
      insert(:tp_business_total_revenue, business_tax_returns: struct)
      insert(:tp_business_transaction_count, business_tax_returns: struct)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:business_tax_returns, source)
        |> Dataloader.load(:business_tax_returns, Core.Services.BusinessTaxReturn, id)
        |> Dataloader.run

      data = Dataloader.get(loader, :business_tax_returns, Core.Services.BusinessTaxReturn, id)

      assert data.id == id
    end
  end

  @spec format_deadline(Date.t()) :: String.t()
  defp format_deadline(data), do: to_string(data)
end

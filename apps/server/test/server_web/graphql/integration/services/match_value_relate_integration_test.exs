defmodule ServerWeb.GraphQL.Integration.Services.MatchValueRelateIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns MatchValueRelate" do
      match_value_relate = insert(:match_value_relat)

      context = %{}

      query = """
      {
        allMatchValueRelates {
          id
          match_for_book_keeping_additional_need
          match_for_book_keeping_annual_revenue
          match_for_book_keeping_industry
          match_for_book_keeping_number_employee
          match_for_book_keeping_payroll
          match_for_book_keeping_type_client
          match_for_business_enity_type
          match_for_business_number_of_employee
          match_for_business_total_revenue
          match_for_individual_employment_status
          match_for_individual_filing_status
          match_for_individual_foreign_account
          match_for_individual_home_owner
          match_for_individual_itemized_deduction
          match_for_individual_living_abroad
          match_for_individual_non_resident_earning
          match_for_individual_own_stock_crypto
          match_for_individual_rental_prop_income
          match_for_individual_stock_divident
          match_for_sale_tax_count
          match_for_sale_tax_frequency
          match_for_sale_tax_industry
          value_for_book_keeping_payroll
          value_for_book_keeping_tax_year
          value_for_business_accounting_software
          value_for_business_dispose_property
          value_for_business_foreign_shareholder
          value_for_business_income_over_thousand
          value_for_business_invest_research
          value_for_business_k1_count
          value_for_business_make_distribution
          value_for_business_state
          value_for_business_tax_exemption
          value_for_business_total_asset_over
          value_for_individual_employment_status
          value_for_individual_foreign_account_limit
          value_for_individual_foreign_financial_interest
          value_for_individual_home_owner
          value_for_individual_k1_count
          value_for_individual_rental_prop_income
          value_for_individual_sole_prop_count
          value_for_individual_state
          value_for_individual_tax_year
          value_for_sale_tax_count
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{data: %{"allMatchValueRelates" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                              == match_value_relate.id
      assert first["match_for_book_keeping_additional_need"]          == match_value_relate.match_for_book_keeping_additional_need
      assert first["match_for_book_keeping_annual_revenue"]           == match_value_relate.match_for_book_keeping_annual_revenue
      assert first["match_for_book_keeping_industry"]                 == match_value_relate.match_for_book_keeping_industry
      assert first["match_for_book_keeping_number_employee"]          == match_value_relate.match_for_book_keeping_number_employee
      assert first["match_for_book_keeping_payroll"]                  == match_value_relate.match_for_book_keeping_payroll
      assert first["match_for_book_keeping_type_client"]              == match_value_relate.match_for_book_keeping_type_client
      assert first["match_for_business_enity_type"]                   == match_value_relate.match_for_business_enity_type
      assert first["match_for_business_number_of_employee"]           == match_value_relate.match_for_business_number_of_employee
      assert first["match_for_business_total_revenue"]                == match_value_relate.match_for_business_total_revenue
      assert first["match_for_individual_employment_status"]          == match_value_relate.match_for_individual_employment_status
      assert first["match_for_individual_filing_status"]              == match_value_relate.match_for_individual_filing_status
      assert first["match_for_individual_foreign_account"]            == match_value_relate.match_for_individual_foreign_account
      assert first["match_for_individual_home_owner"]                 == match_value_relate.match_for_individual_home_owner
      assert first["match_for_individual_itemized_deduction"]         == match_value_relate.match_for_individual_itemized_deduction
      assert first["match_for_individual_living_abroad"]              == match_value_relate.match_for_individual_living_abroad
      assert first["match_for_individual_non_resident_earning"]       == match_value_relate.match_for_individual_non_resident_earning
      assert first["match_for_individual_own_stock_crypto"]           == match_value_relate.match_for_individual_own_stock_crypto
      assert first["match_for_individual_rental_prop_income"]         == match_value_relate.match_for_individual_rental_prop_income
      assert first["match_for_individual_stock_divident"]             == match_value_relate.match_for_individual_stock_divident
      assert first["match_for_sale_tax_count"]                        == match_value_relate.match_for_sale_tax_count
      assert first["match_for_sale_tax_frequency"]                    == match_value_relate.match_for_sale_tax_frequency
      assert first["match_for_sale_tax_industry"]                     == match_value_relate.match_for_sale_tax_industry
      assert first["value_for_book_keeping_payroll"]                  == decimal_to_string(match_value_relate.value_for_book_keeping_payroll)
      assert first["value_for_book_keeping_tax_year"]                 == decimal_to_string(match_value_relate.value_for_book_keeping_tax_year)
      assert first["value_for_business_accounting_software"]          == decimal_to_string(match_value_relate.value_for_business_accounting_software)
      assert first["value_for_business_dispose_property"]             == decimal_to_string(match_value_relate.value_for_business_dispose_property)
      assert first["value_for_business_foreign_shareholder"]          == decimal_to_string(match_value_relate.value_for_business_foreign_shareholder)
      assert first["value_for_business_income_over_thousand"]         == decimal_to_string(match_value_relate.value_for_business_income_over_thousand)
      assert first["value_for_business_invest_research"]              == decimal_to_string(match_value_relate.value_for_business_invest_research)
      assert first["value_for_business_k1_count"]                     == decimal_to_string(match_value_relate.value_for_business_k1_count)
      assert first["value_for_business_make_distribution"]            == decimal_to_string(match_value_relate.value_for_business_make_distribution)
      assert first["value_for_business_state"]                        == decimal_to_string(match_value_relate.value_for_business_state)
      assert first["value_for_business_tax_exemption"]                == decimal_to_string(match_value_relate.value_for_business_tax_exemption)
      assert first["value_for_business_total_asset_over"]             == decimal_to_string(match_value_relate.value_for_business_total_asset_over)
      assert first["value_for_individual_employment_status"]          == decimal_to_string(match_value_relate.value_for_individual_employment_status)
      assert first["value_for_individual_foreign_account_limit"]      == decimal_to_string(match_value_relate.value_for_individual_foreign_account_limit)
      assert first["value_for_individual_foreign_financial_interest"] == decimal_to_string(match_value_relate.value_for_individual_foreign_financial_interest)
      assert first["value_for_individual_home_owner"]                 == decimal_to_string(match_value_relate.value_for_individual_home_owner)
      assert first["value_for_individual_k1_count"]                   == decimal_to_string(match_value_relate.value_for_individual_k1_count)
      assert first["value_for_individual_rental_prop_income"]         == decimal_to_string(match_value_relate.value_for_individual_rental_prop_income)
      assert first["value_for_individual_sole_prop_count"]            == decimal_to_string(match_value_relate.value_for_individual_sole_prop_count)
      assert first["value_for_individual_state"]                      == decimal_to_string(match_value_relate.value_for_individual_state)
      assert first["value_for_individual_tax_year"]                   == decimal_to_string(match_value_relate.value_for_individual_tax_year)
      assert first["value_for_sale_tax_count"]                        == decimal_to_string(match_value_relate.value_for_sale_tax_count)
      assert first["inserted_at"]                                     == formatting_time(match_value_relate.inserted_at)
      assert first["updated_at"]                                      == formatting_time(match_value_relate.updated_at)

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allMatchValueRelates"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allMatchValueRelates"]

      assert List.first(data)["id"]                                              == match_value_relate.id
      assert List.first(data)["match_for_book_keeping_additional_need"]          == match_value_relate.match_for_book_keeping_additional_need
      assert List.first(data)["match_for_book_keeping_annual_revenue"]           == match_value_relate.match_for_book_keeping_annual_revenue
      assert List.first(data)["match_for_book_keeping_industry"]                 == match_value_relate.match_for_book_keeping_industry
      assert List.first(data)["match_for_book_keeping_number_employee"]          == match_value_relate.match_for_book_keeping_number_employee
      assert List.first(data)["match_for_book_keeping_payroll"]                  == match_value_relate.match_for_book_keeping_payroll
      assert List.first(data)["match_for_book_keeping_type_client"]              == match_value_relate.match_for_book_keeping_type_client
      assert List.first(data)["match_for_business_enity_type"]                   == match_value_relate.match_for_business_enity_type
      assert List.first(data)["match_for_business_number_of_employee"]           == match_value_relate.match_for_business_number_of_employee
      assert List.first(data)["match_for_business_total_revenue"]                == match_value_relate.match_for_business_total_revenue
      assert List.first(data)["match_for_individual_employment_status"]          == match_value_relate.match_for_individual_employment_status
      assert List.first(data)["match_for_individual_filing_status"]              == match_value_relate.match_for_individual_filing_status
      assert List.first(data)["match_for_individual_foreign_account"]            == match_value_relate.match_for_individual_foreign_account
      assert List.first(data)["match_for_individual_home_owner"]                 == match_value_relate.match_for_individual_home_owner
      assert List.first(data)["match_for_individual_itemized_deduction"]         == match_value_relate.match_for_individual_itemized_deduction
      assert List.first(data)["match_for_individual_living_abroad"]              == match_value_relate.match_for_individual_living_abroad
      assert List.first(data)["match_for_individual_non_resident_earning"]       == match_value_relate.match_for_individual_non_resident_earning
      assert List.first(data)["match_for_individual_own_stock_crypto"]           == match_value_relate.match_for_individual_own_stock_crypto
      assert List.first(data)["match_for_individual_rental_prop_income"]         == match_value_relate.match_for_individual_rental_prop_income
      assert List.first(data)["match_for_individual_stock_divident"]             == match_value_relate.match_for_individual_stock_divident
      assert List.first(data)["match_for_sale_tax_count"]                        == match_value_relate.match_for_sale_tax_count
      assert List.first(data)["match_for_sale_tax_frequency"]                    == match_value_relate.match_for_sale_tax_frequency
      assert List.first(data)["match_for_sale_tax_industry"]                     == match_value_relate.match_for_sale_tax_industry
      assert List.first(data)["value_for_book_keeping_payroll"]                  == decimal_to_string(match_value_relate.value_for_book_keeping_payroll)
      assert List.first(data)["value_for_book_keeping_tax_year"]                 == decimal_to_string(match_value_relate.value_for_book_keeping_tax_year)
      assert List.first(data)["value_for_business_accounting_software"]          == decimal_to_string(match_value_relate.value_for_business_accounting_software)
      assert List.first(data)["value_for_business_dispose_property"]             == decimal_to_string(match_value_relate.value_for_business_dispose_property)
      assert List.first(data)["value_for_business_foreign_shareholder"]          == decimal_to_string(match_value_relate.value_for_business_foreign_shareholder)
      assert List.first(data)["value_for_business_income_over_thousand"]         == decimal_to_string(match_value_relate.value_for_business_income_over_thousand)
      assert List.first(data)["value_for_business_invest_research"]              == decimal_to_string(match_value_relate.value_for_business_invest_research)
      assert List.first(data)["value_for_business_k1_count"]                     == decimal_to_string(match_value_relate.value_for_business_k1_count)
      assert List.first(data)["value_for_business_make_distribution"]            == decimal_to_string(match_value_relate.value_for_business_make_distribution)
      assert List.first(data)["value_for_business_state"]                        == decimal_to_string(match_value_relate.value_for_business_state)
      assert List.first(data)["value_for_business_tax_exemption"]                == decimal_to_string(match_value_relate.value_for_business_tax_exemption)
      assert List.first(data)["value_for_business_total_asset_over"]             == decimal_to_string(match_value_relate.value_for_business_total_asset_over)
      assert List.first(data)["value_for_individual_employment_status"]          == decimal_to_string(match_value_relate.value_for_individual_employment_status)
      assert List.first(data)["value_for_individual_foreign_account_limit"]      == decimal_to_string(match_value_relate.value_for_individual_foreign_account_limit)
      assert List.first(data)["value_for_individual_foreign_financial_interest"] == decimal_to_string(match_value_relate.value_for_individual_foreign_financial_interest)
      assert List.first(data)["value_for_individual_home_owner"]                 == decimal_to_string(match_value_relate.value_for_individual_home_owner)
      assert List.first(data)["value_for_individual_k1_count"]                   == decimal_to_string(match_value_relate.value_for_individual_k1_count)
      assert List.first(data)["value_for_individual_rental_prop_income"]         == decimal_to_string(match_value_relate.value_for_individual_rental_prop_income)
      assert List.first(data)["value_for_individual_sole_prop_count"]            == decimal_to_string(match_value_relate.value_for_individual_sole_prop_count)
      assert List.first(data)["value_for_individual_state"]                      == decimal_to_string(match_value_relate.value_for_individual_state)
      assert List.first(data)["value_for_individual_tax_year"]                   == decimal_to_string(match_value_relate.value_for_individual_tax_year)
      assert List.first(data)["value_for_sale_tax_count"]                        == decimal_to_string(match_value_relate.value_for_sale_tax_count)
      assert List.first(data)["inserted_at"]                                     == formatting_time(match_value_relate.inserted_at)
      assert List.first(data)["updated_at"]                                      == formatting_time(match_value_relate.updated_at)
    end
  end

  describe "#show" do
    it "returns specific MatchValueRelate" do
      match_value_relate = insert(:match_value_relat)

      context = %{}

      query = """
      {
        showMatchValueRelate(id: \"#{match_value_relate.id}\") {
          id
          match_for_book_keeping_additional_need
          match_for_book_keeping_annual_revenue
          match_for_book_keeping_industry
          match_for_book_keeping_number_employee
          match_for_book_keeping_payroll
          match_for_book_keeping_type_client
          match_for_business_enity_type
          match_for_business_number_of_employee
          match_for_business_total_revenue
          match_for_individual_employment_status
          match_for_individual_filing_status
          match_for_individual_foreign_account
          match_for_individual_home_owner
          match_for_individual_itemized_deduction
          match_for_individual_living_abroad
          match_for_individual_non_resident_earning
          match_for_individual_own_stock_crypto
          match_for_individual_rental_prop_income
          match_for_individual_stock_divident
          match_for_sale_tax_count
          match_for_sale_tax_frequency
          match_for_sale_tax_industry
          value_for_book_keeping_payroll
          value_for_book_keeping_tax_year
          value_for_business_accounting_software
          value_for_business_dispose_property
          value_for_business_foreign_shareholder
          value_for_business_income_over_thousand
          value_for_business_invest_research
          value_for_business_k1_count
          value_for_business_make_distribution
          value_for_business_state
          value_for_business_tax_exemption
          value_for_business_total_asset_over
          value_for_individual_employment_status
          value_for_individual_foreign_account_limit
          value_for_individual_foreign_financial_interest
          value_for_individual_home_owner
          value_for_individual_k1_count
          value_for_individual_rental_prop_income
          value_for_individual_sole_prop_count
          value_for_individual_state
          value_for_individual_tax_year
          value_for_sale_tax_count
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{data: %{"showMatchValueRelate" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"] == match_value_relate.id

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showMatchValueRelate"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showMatchValueRelate"]

      assert found["id"]                                              == match_value_relate.id
      assert found["match_for_book_keeping_additional_need"]          == match_value_relate.match_for_book_keeping_additional_need
      assert found["match_for_book_keeping_annual_revenue"]           == match_value_relate.match_for_book_keeping_annual_revenue
      assert found["match_for_book_keeping_industry"]                 == match_value_relate.match_for_book_keeping_industry
      assert found["match_for_book_keeping_number_employee"]          == match_value_relate.match_for_book_keeping_number_employee
      assert found["match_for_book_keeping_payroll"]                  == match_value_relate.match_for_book_keeping_payroll
      assert found["match_for_book_keeping_type_client"]              == match_value_relate.match_for_book_keeping_type_client
      assert found["match_for_business_enity_type"]                   == match_value_relate.match_for_business_enity_type
      assert found["match_for_business_number_of_employee"]           == match_value_relate.match_for_business_number_of_employee
      assert found["match_for_business_total_revenue"]                == match_value_relate.match_for_business_total_revenue
      assert found["match_for_individual_employment_status"]          == match_value_relate.match_for_individual_employment_status
      assert found["match_for_individual_filing_status"]              == match_value_relate.match_for_individual_filing_status
      assert found["match_for_individual_foreign_account"]            == match_value_relate.match_for_individual_foreign_account
      assert found["match_for_individual_home_owner"]                 == match_value_relate.match_for_individual_home_owner
      assert found["match_for_individual_itemized_deduction"]         == match_value_relate.match_for_individual_itemized_deduction
      assert found["match_for_individual_living_abroad"]              == match_value_relate.match_for_individual_living_abroad
      assert found["match_for_individual_non_resident_earning"]       == match_value_relate.match_for_individual_non_resident_earning
      assert found["match_for_individual_own_stock_crypto"]           == match_value_relate.match_for_individual_own_stock_crypto
      assert found["match_for_individual_rental_prop_income"]         == match_value_relate.match_for_individual_rental_prop_income
      assert found["match_for_individual_stock_divident"]             == match_value_relate.match_for_individual_stock_divident
      assert found["match_for_sale_tax_count"]                        == match_value_relate.match_for_sale_tax_count
      assert found["match_for_sale_tax_frequency"]                    == match_value_relate.match_for_sale_tax_frequency
      assert found["match_for_sale_tax_industry"]                     == match_value_relate.match_for_sale_tax_industry
      assert found["value_for_book_keeping_payroll"]                  == decimal_to_string(match_value_relate.value_for_book_keeping_payroll)
      assert found["value_for_book_keeping_tax_year"]                 == decimal_to_string(match_value_relate.value_for_book_keeping_tax_year)
      assert found["value_for_business_accounting_software"]          == decimal_to_string(match_value_relate.value_for_business_accounting_software)
      assert found["value_for_business_dispose_property"]             == decimal_to_string(match_value_relate.value_for_business_dispose_property)
      assert found["value_for_business_foreign_shareholder"]          == decimal_to_string(match_value_relate.value_for_business_foreign_shareholder)
      assert found["value_for_business_income_over_thousand"]         == decimal_to_string(match_value_relate.value_for_business_income_over_thousand)
      assert found["value_for_business_invest_research"]              == decimal_to_string(match_value_relate.value_for_business_invest_research)
      assert found["value_for_business_k1_count"]                     == decimal_to_string(match_value_relate.value_for_business_k1_count)
      assert found["value_for_business_make_distribution"]            == decimal_to_string(match_value_relate.value_for_business_make_distribution)
      assert found["value_for_business_state"]                        == decimal_to_string(match_value_relate.value_for_business_state)
      assert found["value_for_business_tax_exemption"]                == decimal_to_string(match_value_relate.value_for_business_tax_exemption)
      assert found["value_for_business_total_asset_over"]             == decimal_to_string(match_value_relate.value_for_business_total_asset_over)
      assert found["value_for_individual_employment_status"]          == decimal_to_string(match_value_relate.value_for_individual_employment_status)
      assert found["value_for_individual_foreign_account_limit"]      == decimal_to_string(match_value_relate.value_for_individual_foreign_account_limit)
      assert found["value_for_individual_foreign_financial_interest"] == decimal_to_string(match_value_relate.value_for_individual_foreign_financial_interest)
      assert found["value_for_individual_home_owner"]                 == decimal_to_string(match_value_relate.value_for_individual_home_owner)
      assert found["value_for_individual_k1_count"]                   == decimal_to_string(match_value_relate.value_for_individual_k1_count)
      assert found["value_for_individual_rental_prop_income"]         == decimal_to_string(match_value_relate.value_for_individual_rental_prop_income)
      assert found["value_for_individual_sole_prop_count"]            == decimal_to_string(match_value_relate.value_for_individual_sole_prop_count)
      assert found["value_for_individual_state"]                      == decimal_to_string(match_value_relate.value_for_individual_state)
      assert found["value_for_individual_tax_year"]                   == decimal_to_string(match_value_relate.value_for_individual_tax_year)
      assert found["value_for_sale_tax_count"]                        == decimal_to_string(match_value_relate.value_for_sale_tax_count)
      assert found["inserted_at"]                                     == formatting_time(match_value_relate.inserted_at)
      assert found["updated_at"]                                      == formatting_time(match_value_relate.updated_at)
    end
  end

  describe "#find" do
    it "find specific MatchValueRelate" do
      match_value_relate = insert(:match_value_relat)

      context = %{}

      query = """
      {
        findMatchValueRelate(id: \"#{match_value_relate.id}\") {
          id
          match_for_book_keeping_additional_need
          match_for_book_keeping_annual_revenue
          match_for_book_keeping_industry
          match_for_book_keeping_number_employee
          match_for_book_keeping_payroll
          match_for_book_keeping_type_client
          match_for_business_enity_type
          match_for_business_number_of_employee
          match_for_business_total_revenue
          match_for_individual_employment_status
          match_for_individual_filing_status
          match_for_individual_foreign_account
          match_for_individual_home_owner
          match_for_individual_itemized_deduction
          match_for_individual_living_abroad
          match_for_individual_non_resident_earning
          match_for_individual_own_stock_crypto
          match_for_individual_rental_prop_income
          match_for_individual_stock_divident
          match_for_sale_tax_count
          match_for_sale_tax_frequency
          match_for_sale_tax_industry
          value_for_book_keeping_payroll
          value_for_book_keeping_tax_year
          value_for_business_accounting_software
          value_for_business_dispose_property
          value_for_business_foreign_shareholder
          value_for_business_income_over_thousand
          value_for_business_invest_research
          value_for_business_k1_count
          value_for_business_make_distribution
          value_for_business_state
          value_for_business_tax_exemption
          value_for_business_total_asset_over
          value_for_individual_employment_status
          value_for_individual_foreign_account_limit
          value_for_individual_foreign_financial_interest
          value_for_individual_home_owner
          value_for_individual_k1_count
          value_for_individual_rental_prop_income
          value_for_individual_sole_prop_count
          value_for_individual_state
          value_for_individual_tax_year
          value_for_sale_tax_count
          inserted_at
          updated_at
        }
      }
      """

      {:ok, %{data: %{"findMatchValueRelate" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                              == match_value_relate.id
      assert found["match_for_book_keeping_additional_need"]          == match_value_relate.match_for_book_keeping_additional_need
      assert found["match_for_book_keeping_annual_revenue"]           == match_value_relate.match_for_book_keeping_annual_revenue
      assert found["match_for_book_keeping_industry"]                 == match_value_relate.match_for_book_keeping_industry
      assert found["match_for_book_keeping_number_employee"]          == match_value_relate.match_for_book_keeping_number_employee
      assert found["match_for_book_keeping_payroll"]                  == match_value_relate.match_for_book_keeping_payroll
      assert found["match_for_book_keeping_type_client"]              == match_value_relate.match_for_book_keeping_type_client
      assert found["match_for_business_enity_type"]                   == match_value_relate.match_for_business_enity_type
      assert found["match_for_business_number_of_employee"]           == match_value_relate.match_for_business_number_of_employee
      assert found["match_for_business_total_revenue"]                == match_value_relate.match_for_business_total_revenue
      assert found["match_for_individual_employment_status"]          == match_value_relate.match_for_individual_employment_status
      assert found["match_for_individual_filing_status"]              == match_value_relate.match_for_individual_filing_status
      assert found["match_for_individual_foreign_account"]            == match_value_relate.match_for_individual_foreign_account
      assert found["match_for_individual_home_owner"]                 == match_value_relate.match_for_individual_home_owner
      assert found["match_for_individual_itemized_deduction"]         == match_value_relate.match_for_individual_itemized_deduction
      assert found["match_for_individual_living_abroad"]              == match_value_relate.match_for_individual_living_abroad
      assert found["match_for_individual_non_resident_earning"]       == match_value_relate.match_for_individual_non_resident_earning
      assert found["match_for_individual_own_stock_crypto"]           == match_value_relate.match_for_individual_own_stock_crypto
      assert found["match_for_individual_rental_prop_income"]         == match_value_relate.match_for_individual_rental_prop_income
      assert found["match_for_individual_stock_divident"]             == match_value_relate.match_for_individual_stock_divident
      assert found["match_for_sale_tax_count"]                        == match_value_relate.match_for_sale_tax_count
      assert found["match_for_sale_tax_frequency"]                    == match_value_relate.match_for_sale_tax_frequency
      assert found["match_for_sale_tax_industry"]                     == match_value_relate.match_for_sale_tax_industry
      assert found["value_for_book_keeping_payroll"]                  == decimal_to_string(match_value_relate.value_for_book_keeping_payroll)
      assert found["value_for_book_keeping_tax_year"]                 == decimal_to_string(match_value_relate.value_for_book_keeping_tax_year)
      assert found["value_for_business_accounting_software"]          == decimal_to_string(match_value_relate.value_for_business_accounting_software)
      assert found["value_for_business_dispose_property"]             == decimal_to_string(match_value_relate.value_for_business_dispose_property)
      assert found["value_for_business_foreign_shareholder"]          == decimal_to_string(match_value_relate.value_for_business_foreign_shareholder)
      assert found["value_for_business_income_over_thousand"]         == decimal_to_string(match_value_relate.value_for_business_income_over_thousand)
      assert found["value_for_business_invest_research"]              == decimal_to_string(match_value_relate.value_for_business_invest_research)
      assert found["value_for_business_k1_count"]                     == decimal_to_string(match_value_relate.value_for_business_k1_count)
      assert found["value_for_business_make_distribution"]            == decimal_to_string(match_value_relate.value_for_business_make_distribution)
      assert found["value_for_business_state"]                        == decimal_to_string(match_value_relate.value_for_business_state)
      assert found["value_for_business_tax_exemption"]                == decimal_to_string(match_value_relate.value_for_business_tax_exemption)
      assert found["value_for_business_total_asset_over"]             == decimal_to_string(match_value_relate.value_for_business_total_asset_over)
      assert found["value_for_individual_employment_status"]          == decimal_to_string(match_value_relate.value_for_individual_employment_status)
      assert found["value_for_individual_foreign_account_limit"]      == decimal_to_string(match_value_relate.value_for_individual_foreign_account_limit)
      assert found["value_for_individual_foreign_financial_interest"] == decimal_to_string(match_value_relate.value_for_individual_foreign_financial_interest)
      assert found["value_for_individual_home_owner"]                 == decimal_to_string(match_value_relate.value_for_individual_home_owner)
      assert found["value_for_individual_k1_count"]                   == decimal_to_string(match_value_relate.value_for_individual_k1_count)
      assert found["value_for_individual_rental_prop_income"]         == decimal_to_string(match_value_relate.value_for_individual_rental_prop_income)
      assert found["value_for_individual_sole_prop_count"]            == decimal_to_string(match_value_relate.value_for_individual_sole_prop_count)
      assert found["value_for_individual_state"]                      == decimal_to_string(match_value_relate.value_for_individual_state)
      assert found["value_for_individual_tax_year"]                   == decimal_to_string(match_value_relate.value_for_individual_tax_year)
      assert found["value_for_sale_tax_count"]                        == decimal_to_string(match_value_relate.value_for_sale_tax_count)
      assert found["inserted_at"]                                     == formatting_time(match_value_relate.inserted_at)
      assert found["updated_at"]                                      == formatting_time(match_value_relate.updated_at)

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findMatchValueRelate"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findMatchValueRelate"]

      assert found["id"]                                              == match_value_relate.id
      assert found["match_for_book_keeping_additional_need"]          == match_value_relate.match_for_book_keeping_additional_need
      assert found["match_for_book_keeping_annual_revenue"]           == match_value_relate.match_for_book_keeping_annual_revenue
      assert found["match_for_book_keeping_industry"]                 == match_value_relate.match_for_book_keeping_industry
      assert found["match_for_book_keeping_number_employee"]          == match_value_relate.match_for_book_keeping_number_employee
      assert found["match_for_book_keeping_payroll"]                  == match_value_relate.match_for_book_keeping_payroll
      assert found["match_for_book_keeping_type_client"]              == match_value_relate.match_for_book_keeping_type_client
      assert found["match_for_business_enity_type"]                   == match_value_relate.match_for_business_enity_type
      assert found["match_for_business_number_of_employee"]           == match_value_relate.match_for_business_number_of_employee
      assert found["match_for_business_total_revenue"]                == match_value_relate.match_for_business_total_revenue
      assert found["match_for_individual_employment_status"]          == match_value_relate.match_for_individual_employment_status
      assert found["match_for_individual_filing_status"]              == match_value_relate.match_for_individual_filing_status
      assert found["match_for_individual_foreign_account"]            == match_value_relate.match_for_individual_foreign_account
      assert found["match_for_individual_home_owner"]                 == match_value_relate.match_for_individual_home_owner
      assert found["match_for_individual_itemized_deduction"]         == match_value_relate.match_for_individual_itemized_deduction
      assert found["match_for_individual_living_abroad"]              == match_value_relate.match_for_individual_living_abroad
      assert found["match_for_individual_non_resident_earning"]       == match_value_relate.match_for_individual_non_resident_earning
      assert found["match_for_individual_own_stock_crypto"]           == match_value_relate.match_for_individual_own_stock_crypto
      assert found["match_for_individual_rental_prop_income"]         == match_value_relate.match_for_individual_rental_prop_income
      assert found["match_for_individual_stock_divident"]             == match_value_relate.match_for_individual_stock_divident
      assert found["match_for_sale_tax_count"]                        == match_value_relate.match_for_sale_tax_count
      assert found["match_for_sale_tax_frequency"]                    == match_value_relate.match_for_sale_tax_frequency
      assert found["match_for_sale_tax_industry"]                     == match_value_relate.match_for_sale_tax_industry
      assert found["value_for_book_keeping_payroll"]                  == decimal_to_string(match_value_relate.value_for_book_keeping_payroll)
      assert found["value_for_book_keeping_tax_year"]                 == decimal_to_string(match_value_relate.value_for_book_keeping_tax_year)
      assert found["value_for_business_accounting_software"]          == decimal_to_string(match_value_relate.value_for_business_accounting_software)
      assert found["value_for_business_dispose_property"]             == decimal_to_string(match_value_relate.value_for_business_dispose_property)
      assert found["value_for_business_foreign_shareholder"]          == decimal_to_string(match_value_relate.value_for_business_foreign_shareholder)
      assert found["value_for_business_income_over_thousand"]         == decimal_to_string(match_value_relate.value_for_business_income_over_thousand)
      assert found["value_for_business_invest_research"]              == decimal_to_string(match_value_relate.value_for_business_invest_research)
      assert found["value_for_business_k1_count"]                     == decimal_to_string(match_value_relate.value_for_business_k1_count)
      assert found["value_for_business_make_distribution"]            == decimal_to_string(match_value_relate.value_for_business_make_distribution)
      assert found["value_for_business_state"]                        == decimal_to_string(match_value_relate.value_for_business_state)
      assert found["value_for_business_tax_exemption"]                == decimal_to_string(match_value_relate.value_for_business_tax_exemption)
      assert found["value_for_business_total_asset_over"]             == decimal_to_string(match_value_relate.value_for_business_total_asset_over)
      assert found["value_for_individual_employment_status"]          == decimal_to_string(match_value_relate.value_for_individual_employment_status)
      assert found["value_for_individual_foreign_account_limit"]      == decimal_to_string(match_value_relate.value_for_individual_foreign_account_limit)
      assert found["value_for_individual_foreign_financial_interest"] == decimal_to_string(match_value_relate.value_for_individual_foreign_financial_interest)
      assert found["value_for_individual_home_owner"]                 == decimal_to_string(match_value_relate.value_for_individual_home_owner)
      assert found["value_for_individual_k1_count"]                   == decimal_to_string(match_value_relate.value_for_individual_k1_count)
      assert found["value_for_individual_rental_prop_income"]         == decimal_to_string(match_value_relate.value_for_individual_rental_prop_income)
      assert found["value_for_individual_sole_prop_count"]            == decimal_to_string(match_value_relate.value_for_individual_sole_prop_count)
      assert found["value_for_individual_state"]                      == decimal_to_string(match_value_relate.value_for_individual_state)
      assert found["value_for_individual_tax_year"]                   == decimal_to_string(match_value_relate.value_for_individual_tax_year)
      assert found["value_for_sale_tax_count"]                        == decimal_to_string(match_value_relate.value_for_sale_tax_count)
      assert found["inserted_at"]                                     == formatting_time(match_value_relate.inserted_at)
      assert found["updated_at"]                                      == formatting_time(match_value_relate.updated_at)
    end
  end

  describe "#create" do
    it "created MatchValueRelate" do
      mutation = """
      {
        createMatchValueRelate(
          match_for_book_keeping_additional_need:              12,
          match_for_book_keeping_annual_revenue:               12,
          match_for_book_keeping_industry:                     12,
          match_for_book_keeping_number_employee:              12,
          match_for_book_keeping_payroll:                      12,
          match_for_book_keeping_type_client:                  12,
          match_for_business_enity_type:                       12,
          match_for_business_number_of_employee:               12,
          match_for_business_total_revenue:                    12,
          match_for_individual_employment_status:              12,
          match_for_individual_filing_status:                  12,
          match_for_individual_foreign_account:                12,
          match_for_individual_home_owner:                     12,
          match_for_individual_itemized_deduction:             12,
          match_for_individual_living_abroad:                  12,
          match_for_individual_non_resident_earning:           12,
          match_for_individual_own_stock_crypto:               12,
          match_for_individual_rental_prop_income:             12,
          match_for_individual_stock_divident:                 12,
          match_for_sale_tax_count:                            12,
          match_for_sale_tax_frequency:                        12,
          match_for_sale_tax_industry:                         12,
          value_for_book_keeping_payroll:                  "9.99",
          value_for_book_keeping_tax_year:                 "9.99",
          value_for_business_accounting_software:          "9.99",
          value_for_business_dispose_property:             "9.99",
          value_for_business_foreign_shareholder:          "9.99",
          value_for_business_income_over_thousand:         "9.99",
          value_for_business_invest_research:              "9.99",
          value_for_business_k1_count:                     "9.99",
          value_for_business_make_distribution:            "9.99",
          value_for_business_state:                        "9.99",
          value_for_business_tax_exemption:                "9.99",
          value_for_business_total_asset_over:             "9.99",
          value_for_individual_employment_status:          "9.99",
          value_for_individual_foreign_account_limit:      "9.99",
          value_for_individual_foreign_financial_interest: "9.99",
          value_for_individual_home_owner:                 "9.99",
          value_for_individual_k1_count:                   "9.99",
          value_for_individual_rental_prop_income:         "9.99",
          value_for_individual_sole_prop_count:            "9.99",
          value_for_individual_state:                      "9.99",
          value_for_individual_tax_year:                   "9.99",
          value_for_sale_tax_count:                        "9.99"
        ) {
            id
            match_for_book_keeping_additional_need
            match_for_book_keeping_annual_revenue
            match_for_book_keeping_industry
            match_for_book_keeping_number_employee
            match_for_book_keeping_payroll
            match_for_book_keeping_type_client
            match_for_business_enity_type
            match_for_business_number_of_employee
            match_for_business_total_revenue
            match_for_individual_employment_status
            match_for_individual_filing_status
            match_for_individual_foreign_account
            match_for_individual_home_owner
            match_for_individual_itemized_deduction
            match_for_individual_living_abroad
            match_for_individual_non_resident_earning
            match_for_individual_own_stock_crypto
            match_for_individual_rental_prop_income
            match_for_individual_stock_divident
            match_for_sale_tax_count
            match_for_sale_tax_frequency
            match_for_sale_tax_industry
            value_for_book_keeping_payroll
            value_for_book_keeping_tax_year
            value_for_business_accounting_software
            value_for_business_dispose_property
            value_for_business_foreign_shareholder
            value_for_business_income_over_thousand
            value_for_business_invest_research
            value_for_business_k1_count
            value_for_business_make_distribution
            value_for_business_state
            value_for_business_tax_exemption
            value_for_business_total_asset_over
            value_for_individual_employment_status
            value_for_individual_foreign_account_limit
            value_for_individual_foreign_financial_interest
            value_for_individual_home_owner
            value_for_individual_k1_count
            value_for_individual_rental_prop_income
            value_for_individual_sole_prop_count
            value_for_individual_state
            value_for_individual_tax_year
            value_for_sale_tax_count
            inserted_at
            updated_at
          }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createMatchValueRelate"]

      assert created["match_for_book_keeping_additional_need"]          == 12
      assert created["match_for_book_keeping_additional_need"]          == 12
      assert created["match_for_book_keeping_annual_revenue"]           == 12
      assert created["match_for_book_keeping_industry"]                 == 12
      assert created["match_for_book_keeping_number_employee"]          == 12
      assert created["match_for_book_keeping_payroll"]                  == 12
      assert created["match_for_book_keeping_type_client"]              == 12
      assert created["match_for_business_enity_type"]                   == 12
      assert created["match_for_business_number_of_employee"]           == 12
      assert created["match_for_business_total_revenue"]                == 12
      assert created["match_for_individual_employment_status"]          == 12
      assert created["match_for_individual_filing_status"]              == 12
      assert created["match_for_individual_foreign_account"]            == 12
      assert created["match_for_individual_home_owner"]                 == 12
      assert created["match_for_individual_itemized_deduction"]         == 12
      assert created["match_for_individual_living_abroad"]              == 12
      assert created["match_for_individual_non_resident_earning"]       == 12
      assert created["match_for_individual_own_stock_crypto"]           == 12
      assert created["match_for_individual_rental_prop_income"]         == 12
      assert created["match_for_individual_stock_divident"]             == 12
      assert created["match_for_sale_tax_count"]                        == 12
      assert created["match_for_sale_tax_frequency"]                    == 12
      assert created["match_for_sale_tax_industry"]                     == 12
      assert created["value_for_book_keeping_payroll"]                  == "9.99"
      assert created["value_for_book_keeping_tax_year"]                 == "9.99"
      assert created["value_for_business_accounting_software"]          == "9.99"
      assert created["value_for_business_dispose_property"]             == "9.99"
      assert created["value_for_business_foreign_shareholder"]          == "9.99"
      assert created["value_for_business_income_over_thousand"]         == "9.99"
      assert created["value_for_business_invest_research"]              == "9.99"
      assert created["value_for_business_k1_count"]                     == "9.99"
      assert created["value_for_business_make_distribution"]            == "9.99"
      assert created["value_for_business_state"]                        == "9.99"
      assert created["value_for_business_tax_exemption"]                == "9.99"
      assert created["value_for_business_total_asset_over"]             == "9.99"
      assert created["value_for_individual_employment_status"]          == "9.99"
      assert created["value_for_individual_foreign_account_limit"]      == "9.99"
      assert created["value_for_individual_foreign_financial_interest"] == "9.99"
      assert created["value_for_individual_home_owner"]                 == "9.99"
      assert created["value_for_individual_k1_count"]                   == "9.99"
      assert created["value_for_individual_rental_prop_income"]         == "9.99"
      assert created["value_for_individual_sole_prop_count"]            == "9.99"
      assert created["value_for_individual_state"]                      == "9.99"
      assert created["value_for_individual_tax_year"]                   == "9.99"
      assert created["value_for_sale_tax_count"]                        == "9.99"
    end
  end

  describe "#update" do
    it "updated specific MatchValueRelate" do
      match_value_relate = insert(:match_value_relat)

      mutation = """
      {
        updateMatchValueRelate(
          id: \"#{match_value_relate.id}\",
          match_value_relate: {
            match_for_book_keeping_additional_need:              13,
            match_for_book_keeping_annual_revenue:               13,
            match_for_book_keeping_industry:                     13,
            match_for_book_keeping_number_employee:              13,
            match_for_book_keeping_payroll:                      13,
            match_for_book_keeping_type_client:                  13,
            match_for_business_enity_type:                       13,
            match_for_business_number_of_employee:               13,
            match_for_business_total_revenue:                    13,
            match_for_individual_employment_status:              13,
            match_for_individual_filing_status:                  13,
            match_for_individual_foreign_account:                13,
            match_for_individual_home_owner:                     13,
            match_for_individual_itemized_deduction:             13,
            match_for_individual_living_abroad:                  13,
            match_for_individual_non_resident_earning:           13,
            match_for_individual_own_stock_crypto:               13,
            match_for_individual_rental_prop_income:             13,
            match_for_individual_stock_divident:                 13,
            match_for_sale_tax_count:                            13,
            match_for_sale_tax_frequency:                        13,
            match_for_sale_tax_industry:                         13,
            value_for_book_keeping_payroll:                  "0.99",
            value_for_book_keeping_tax_year:                 "0.99",
            value_for_business_accounting_software:          "0.99",
            value_for_business_dispose_property:             "0.99",
            value_for_business_foreign_shareholder:          "0.99",
            value_for_business_income_over_thousand:         "0.99",
            value_for_business_invest_research:              "0.99",
            value_for_business_k1_count:                     "0.99",
            value_for_business_make_distribution:            "0.99",
            value_for_business_state:                        "0.99",
            value_for_business_tax_exemption:                "0.99",
            value_for_business_total_asset_over:             "0.99",
            value_for_individual_employment_status:          "0.99",
            value_for_individual_foreign_account_limit:      "0.99",
            value_for_individual_foreign_financial_interest: "0.99",
            value_for_individual_home_owner:                 "0.99",
            value_for_individual_k1_count:                   "0.99",
            value_for_individual_rental_prop_income:         "0.99",
            value_for_individual_sole_prop_count:            "0.99",
            value_for_individual_state:                      "0.99",
            value_for_individual_tax_year:                   "0.99",
            value_for_sale_tax_count:                        "0.99"
          }
        ) {
            id
            match_for_book_keeping_additional_need
            match_for_book_keeping_annual_revenue
            match_for_book_keeping_industry
            match_for_book_keeping_number_employee
            match_for_book_keeping_payroll
            match_for_book_keeping_type_client
            match_for_business_enity_type
            match_for_business_number_of_employee
            match_for_business_total_revenue
            match_for_individual_employment_status
            match_for_individual_filing_status
            match_for_individual_foreign_account
            match_for_individual_home_owner
            match_for_individual_itemized_deduction
            match_for_individual_living_abroad
            match_for_individual_non_resident_earning
            match_for_individual_own_stock_crypto
            match_for_individual_rental_prop_income
            match_for_individual_stock_divident
            match_for_sale_tax_count
            match_for_sale_tax_frequency
            match_for_sale_tax_industry
            value_for_book_keeping_payroll
            value_for_book_keeping_tax_year
            value_for_business_accounting_software
            value_for_business_dispose_property
            value_for_business_foreign_shareholder
            value_for_business_income_over_thousand
            value_for_business_invest_research
            value_for_business_k1_count
            value_for_business_make_distribution
            value_for_business_state
            value_for_business_tax_exemption
            value_for_business_total_asset_over
            value_for_individual_employment_status
            value_for_individual_foreign_account_limit
            value_for_individual_foreign_financial_interest
            value_for_individual_home_owner
            value_for_individual_k1_count
            value_for_individual_rental_prop_income
            value_for_individual_sole_prop_count
            value_for_individual_state
            value_for_individual_tax_year
            value_for_sale_tax_count
            inserted_at
            updated_at
          }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateMatchValueRelate"]

      assert updated["id"]                                              == match_value_relate.id
      assert updated["match_for_book_keeping_additional_need"]          == 13
      assert updated["match_for_book_keeping_additional_need"]          == 13
      assert updated["match_for_book_keeping_annual_revenue"]           == 13
      assert updated["match_for_book_keeping_industry"]                 == 13
      assert updated["match_for_book_keeping_number_employee"]          == 13
      assert updated["match_for_book_keeping_payroll"]                  == 13
      assert updated["match_for_book_keeping_type_client"]              == 13
      assert updated["match_for_business_enity_type"]                   == 13
      assert updated["match_for_business_number_of_employee"]           == 13
      assert updated["match_for_business_total_revenue"]                == 13
      assert updated["match_for_individual_employment_status"]          == 13
      assert updated["match_for_individual_filing_status"]              == 13
      assert updated["match_for_individual_foreign_account"]            == 13
      assert updated["match_for_individual_home_owner"]                 == 13
      assert updated["match_for_individual_itemized_deduction"]         == 13
      assert updated["match_for_individual_living_abroad"]              == 13
      assert updated["match_for_individual_non_resident_earning"]       == 13
      assert updated["match_for_individual_own_stock_crypto"]           == 13
      assert updated["match_for_individual_rental_prop_income"]         == 13
      assert updated["match_for_individual_stock_divident"]             == 13
      assert updated["match_for_sale_tax_count"]                        == 13
      assert updated["match_for_sale_tax_frequency"]                    == 13
      assert updated["match_for_sale_tax_industry"]                     == 13
      assert updated["value_for_book_keeping_payroll"]                  == "0.99"
      assert updated["value_for_book_keeping_tax_year"]                 == "0.99"
      assert updated["value_for_business_accounting_software"]          == "0.99"
      assert updated["value_for_business_dispose_property"]             == "0.99"
      assert updated["value_for_business_foreign_shareholder"]          == "0.99"
      assert updated["value_for_business_income_over_thousand"]         == "0.99"
      assert updated["value_for_business_invest_research"]              == "0.99"
      assert updated["value_for_business_k1_count"]                     == "0.99"
      assert updated["value_for_business_make_distribution"]            == "0.99"
      assert updated["value_for_business_state"]                        == "0.99"
      assert updated["value_for_business_tax_exemption"]                == "0.99"
      assert updated["value_for_business_total_asset_over"]             == "0.99"
      assert updated["value_for_individual_employment_status"]          == "0.99"
      assert updated["value_for_individual_foreign_account_limit"]      == "0.99"
      assert updated["value_for_individual_foreign_financial_interest"] == "0.99"
      assert updated["value_for_individual_home_owner"]                 == "0.99"
      assert updated["value_for_individual_k1_count"]                   == "0.99"
      assert updated["value_for_individual_rental_prop_income"]         == "0.99"
      assert updated["value_for_individual_sole_prop_count"]            == "0.99"
      assert updated["value_for_individual_state"]                      == "0.99"
      assert updated["value_for_individual_tax_year"]                   == "0.99"
      assert updated["value_for_sale_tax_count"]                        == "0.99"
      assert updated["inserted_at"]                                     == formatting_time(match_value_relate.inserted_at)
      assert updated["updated_at"]                                      == formatting_time(match_value_relate.updated_at)
    end
  end

  describe "#delete" do
    it "delete specific MatchValueRelate" do
      match_value_relate = insert(:match_value_relat)

      mutation = """
      {
        deleteMatchValueRelate(id: \"#{match_value_relate.id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteMatchValueRelate"]
      assert deleted["id"] == match_value_relate.id
    end
  end

  defp decimal_to_string(val) do
    Decimal.to_string(val)
  end

  defp formatting_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end

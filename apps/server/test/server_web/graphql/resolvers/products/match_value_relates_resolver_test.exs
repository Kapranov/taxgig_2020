defmodule ServerWeb.GraphQL.Resolvers.Products.MatchValueRelatesResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.MatchValueRelatesResolver

  describe "#index" do
    it "returns MatchValueRelates" do
      match_value_relate = insert(:match_value_relat)

      {:ok, data} = MatchValueRelatesResolver.list(nil, nil, nil)

      assert length(data) == 1

      assert List.first(data).id                                              == match_value_relate.id
      assert List.first(data).inserted_at                                     == match_value_relate.inserted_at
      assert List.first(data).match_for_book_keeping_additional_need          == match_value_relate.match_for_book_keeping_additional_need
      assert List.first(data).match_for_book_keeping_annual_revenue           == match_value_relate.match_for_book_keeping_annual_revenue
      assert List.first(data).match_for_book_keeping_industry                 == match_value_relate.match_for_book_keeping_industry
      assert List.first(data).match_for_book_keeping_number_employee          == match_value_relate.match_for_book_keeping_number_employee
      assert List.first(data).match_for_book_keeping_payroll                  == match_value_relate.match_for_book_keeping_payroll
      assert List.first(data).match_for_book_keeping_type_client              == match_value_relate.match_for_book_keeping_type_client
      assert List.first(data).match_for_business_enity_type                   == match_value_relate.match_for_business_enity_type
      assert List.first(data).match_for_business_industry                     == match_value_relate.match_for_business_industry
      assert List.first(data).match_for_business_number_of_employee           == match_value_relate.match_for_business_number_of_employee
      assert List.first(data).match_for_business_total_revenue                == match_value_relate.match_for_business_total_revenue
      assert List.first(data).match_for_individual_employment_status          == match_value_relate.match_for_individual_employment_status
      assert List.first(data).match_for_individual_filing_status              == match_value_relate.match_for_individual_filing_status
      assert List.first(data).match_for_individual_foreign_account            == match_value_relate.match_for_individual_foreign_account
      assert List.first(data).match_for_individual_home_owner                 == match_value_relate.match_for_individual_home_owner
      assert List.first(data).match_for_individual_industry                   == match_value_relate.match_for_individual_industry
      assert List.first(data).match_for_individual_itemized_deduction         == match_value_relate.match_for_individual_itemized_deduction
      assert List.first(data).match_for_individual_living_abroad              == match_value_relate.match_for_individual_living_abroad
      assert List.first(data).match_for_individual_non_resident_earning       == match_value_relate.match_for_individual_non_resident_earning
      assert List.first(data).match_for_individual_own_stock_crypto           == match_value_relate.match_for_individual_own_stock_crypto
      assert List.first(data).match_for_individual_rental_prop_income         == match_value_relate.match_for_individual_rental_prop_income
      assert List.first(data).match_for_individual_stock_divident             == match_value_relate.match_for_individual_stock_divident
      assert List.first(data).match_for_sale_tax_count                        == match_value_relate.match_for_sale_tax_count
      assert List.first(data).match_for_sale_tax_frequency                    == match_value_relate.match_for_sale_tax_frequency
      assert List.first(data).match_for_sale_tax_industry                     == match_value_relate.match_for_sale_tax_industry
      assert List.first(data).updated_at                                      == match_value_relate.updated_at
      assert List.first(data).value_for_book_keeping_payroll                  == match_value_relate.value_for_book_keeping_payroll
      assert List.first(data).value_for_book_keeping_tax_year                 == match_value_relate.value_for_book_keeping_tax_year
      assert List.first(data).value_for_business_accounting_software          == match_value_relate.value_for_business_accounting_software
      assert List.first(data).value_for_business_dispose_property             == match_value_relate.value_for_business_dispose_property
      assert List.first(data).value_for_business_foreign_shareholder          == match_value_relate.value_for_business_foreign_shareholder
      assert List.first(data).value_for_business_income_over_thousand         == match_value_relate.value_for_business_income_over_thousand
      assert List.first(data).value_for_business_invest_research              == match_value_relate.value_for_business_invest_research
      assert List.first(data).value_for_business_k1_count                     == match_value_relate.value_for_business_k1_count
      assert List.first(data).value_for_business_make_distribution            == match_value_relate.value_for_business_make_distribution
      assert List.first(data).value_for_business_state                        == match_value_relate.value_for_business_state
      assert List.first(data).value_for_business_tax_exemption                == match_value_relate.value_for_business_tax_exemption
      assert List.first(data).value_for_business_total_asset_over             == match_value_relate.value_for_business_total_asset_over
      assert List.first(data).value_for_individual_employment_status          == match_value_relate.value_for_individual_employment_status
      assert List.first(data).value_for_individual_foreign_account_limit      == match_value_relate.value_for_individual_foreign_account_limit
      assert List.first(data).value_for_individual_foreign_financial_interest == match_value_relate.value_for_individual_foreign_financial_interest
      assert List.first(data).value_for_individual_home_owner                 == match_value_relate.value_for_individual_home_owner
      assert List.first(data).value_for_individual_k1_count                   == match_value_relate.value_for_individual_k1_count
      assert List.first(data).value_for_individual_rental_prop_income         == match_value_relate.value_for_individual_rental_prop_income
      assert List.first(data).value_for_individual_sole_prop_count            == match_value_relate.value_for_individual_sole_prop_count
      assert List.first(data).value_for_individual_state                      == match_value_relate.value_for_individual_state
      assert List.first(data).value_for_individual_tax_year                   == match_value_relate.value_for_individual_tax_year
      assert List.first(data).value_for_sale_tax_count                        == match_value_relate.value_for_sale_tax_count
    end
  end

  describe "#show" do
    it "returns specific MatchValueRelate by id" do
      current_user = insert(:user, admin: true)
      context = %{context: %{current_user: current_user}}
      match_value_relate = insert(:match_value_relat)

      {:ok, found} = MatchValueRelatesResolver.show(nil, %{id: match_value_relate.id}, context)

      assert found.id                                              == match_value_relate.id
      assert found.inserted_at                                     == match_value_relate.inserted_at
      assert found.match_for_book_keeping_additional_need          == match_value_relate.match_for_book_keeping_additional_need
      assert found.match_for_book_keeping_annual_revenue           == match_value_relate.match_for_book_keeping_annual_revenue
      assert found.match_for_book_keeping_industry                 == match_value_relate.match_for_book_keeping_industry
      assert found.match_for_book_keeping_number_employee          == match_value_relate.match_for_book_keeping_number_employee
      assert found.match_for_book_keeping_payroll                  == match_value_relate.match_for_book_keeping_payroll
      assert found.match_for_book_keeping_type_client              == match_value_relate.match_for_book_keeping_type_client
      assert found.match_for_business_enity_type                   == match_value_relate.match_for_business_enity_type
      assert found.match_for_business_industry                     == match_value_relate.match_for_business_industry
      assert found.match_for_business_number_of_employee           == match_value_relate.match_for_business_number_of_employee
      assert found.match_for_business_total_revenue                == match_value_relate.match_for_business_total_revenue
      assert found.match_for_individual_employment_status          == match_value_relate.match_for_individual_employment_status
      assert found.match_for_individual_filing_status              == match_value_relate.match_for_individual_filing_status
      assert found.match_for_individual_foreign_account            == match_value_relate.match_for_individual_foreign_account
      assert found.match_for_individual_home_owner                 == match_value_relate.match_for_individual_home_owner
      assert found.match_for_individual_industry                   == match_value_relate.match_for_individual_industry
      assert found.match_for_individual_itemized_deduction         == match_value_relate.match_for_individual_itemized_deduction
      assert found.match_for_individual_living_abroad              == match_value_relate.match_for_individual_living_abroad
      assert found.match_for_individual_non_resident_earning       == match_value_relate.match_for_individual_non_resident_earning
      assert found.match_for_individual_own_stock_crypto           == match_value_relate.match_for_individual_own_stock_crypto
      assert found.match_for_individual_rental_prop_income         == match_value_relate.match_for_individual_rental_prop_income
      assert found.match_for_individual_stock_divident             == match_value_relate.match_for_individual_stock_divident
      assert found.match_for_sale_tax_count                        == match_value_relate.match_for_sale_tax_count
      assert found.match_for_sale_tax_frequency                    == match_value_relate.match_for_sale_tax_frequency
      assert found.match_for_sale_tax_industry                     == match_value_relate.match_for_sale_tax_industry
      assert found.updated_at                                      == match_value_relate.updated_at
      assert found.value_for_book_keeping_payroll                  == match_value_relate.value_for_book_keeping_payroll
      assert found.value_for_book_keeping_tax_year                 == match_value_relate.value_for_book_keeping_tax_year
      assert found.value_for_business_accounting_software          == match_value_relate.value_for_business_accounting_software
      assert found.value_for_business_dispose_property             == match_value_relate.value_for_business_dispose_property
      assert found.value_for_business_foreign_shareholder          == match_value_relate.value_for_business_foreign_shareholder
      assert found.value_for_business_income_over_thousand         == match_value_relate.value_for_business_income_over_thousand
      assert found.value_for_business_invest_research              == match_value_relate.value_for_business_invest_research
      assert found.value_for_business_k1_count                     == match_value_relate.value_for_business_k1_count
      assert found.value_for_business_make_distribution            == match_value_relate.value_for_business_make_distribution
      assert found.value_for_business_state                        == match_value_relate.value_for_business_state
      assert found.value_for_business_tax_exemption                == match_value_relate.value_for_business_tax_exemption
      assert found.value_for_business_total_asset_over             == match_value_relate.value_for_business_total_asset_over
      assert found.value_for_individual_employment_status          == match_value_relate.value_for_individual_employment_status
      assert found.value_for_individual_foreign_account_limit      == match_value_relate.value_for_individual_foreign_account_limit
      assert found.value_for_individual_foreign_financial_interest == match_value_relate.value_for_individual_foreign_financial_interest
      assert found.value_for_individual_home_owner                 == match_value_relate.value_for_individual_home_owner
      assert found.value_for_individual_k1_count                   == match_value_relate.value_for_individual_k1_count
      assert found.value_for_individual_rental_prop_income         == match_value_relate.value_for_individual_rental_prop_income
      assert found.value_for_individual_sole_prop_count            == match_value_relate.value_for_individual_sole_prop_count
      assert found.value_for_individual_state                      == match_value_relate.value_for_individual_state
      assert found.value_for_individual_tax_year                   == match_value_relate.value_for_individual_tax_year
      assert found.value_for_sale_tax_count                        == match_value_relate.value_for_sale_tax_count
    end

    it "returns not found when MatchValueRelate does not exist" do
      current_user = insert(:user, admin: true)
      context = %{context: %{current_user: current_user}}
      id = FlakeId.get()
      {:error, error} = MatchValueRelatesResolver.show(nil, %{id: id}, context)

      assert error == "The MatchValueRelate #{id} not found!"
    end

    it "returns error for missing params" do
      current_user = insert(:user, admin: true)
      context = %{context: %{current_user: current_user}}
      insert(:match_value_relat)
      args = %{id: nil}
      {:error, error} = MatchValueRelatesResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for user admin to perform action Show"]]
    end
  end

  describe "#find" do
    it "find specific MatchValueRelate by id" do
      current_user = insert(:user, admin: true)
      context = %{context: %{current_user: current_user}}
      match_value_relate = insert(:match_value_relat)

      {:ok, found} = MatchValueRelatesResolver.find(nil, %{id: match_value_relate.id}, context)

      assert found.id                                              == match_value_relate.id
      assert found.inserted_at                                     == match_value_relate.inserted_at
      assert found.match_for_book_keeping_additional_need          == match_value_relate.match_for_book_keeping_additional_need
      assert found.match_for_book_keeping_annual_revenue           == match_value_relate.match_for_book_keeping_annual_revenue
      assert found.match_for_book_keeping_industry                 == match_value_relate.match_for_book_keeping_industry
      assert found.match_for_book_keeping_number_employee          == match_value_relate.match_for_book_keeping_number_employee
      assert found.match_for_book_keeping_payroll                  == match_value_relate.match_for_book_keeping_payroll
      assert found.match_for_book_keeping_type_client              == match_value_relate.match_for_book_keeping_type_client
      assert found.match_for_business_enity_type                   == match_value_relate.match_for_business_enity_type
      assert found.match_for_business_industry                     == match_value_relate.match_for_business_industry
      assert found.match_for_business_number_of_employee           == match_value_relate.match_for_business_number_of_employee
      assert found.match_for_business_total_revenue                == match_value_relate.match_for_business_total_revenue
      assert found.match_for_individual_employment_status          == match_value_relate.match_for_individual_employment_status
      assert found.match_for_individual_filing_status              == match_value_relate.match_for_individual_filing_status
      assert found.match_for_individual_foreign_account            == match_value_relate.match_for_individual_foreign_account
      assert found.match_for_individual_home_owner                 == match_value_relate.match_for_individual_home_owner
      assert found.match_for_individual_industry                   == match_value_relate.match_for_individual_industry
      assert found.match_for_individual_itemized_deduction         == match_value_relate.match_for_individual_itemized_deduction
      assert found.match_for_individual_living_abroad              == match_value_relate.match_for_individual_living_abroad
      assert found.match_for_individual_non_resident_earning       == match_value_relate.match_for_individual_non_resident_earning
      assert found.match_for_individual_own_stock_crypto           == match_value_relate.match_for_individual_own_stock_crypto
      assert found.match_for_individual_rental_prop_income         == match_value_relate.match_for_individual_rental_prop_income
      assert found.match_for_individual_stock_divident             == match_value_relate.match_for_individual_stock_divident
      assert found.match_for_sale_tax_count                        == match_value_relate.match_for_sale_tax_count
      assert found.match_for_sale_tax_frequency                    == match_value_relate.match_for_sale_tax_frequency
      assert found.match_for_sale_tax_industry                     == match_value_relate.match_for_sale_tax_industry
      assert found.updated_at                                      == match_value_relate.updated_at
      assert found.value_for_book_keeping_payroll                  == match_value_relate.value_for_book_keeping_payroll
      assert found.value_for_book_keeping_tax_year                 == match_value_relate.value_for_book_keeping_tax_year
      assert found.value_for_business_accounting_software          == match_value_relate.value_for_business_accounting_software
      assert found.value_for_business_dispose_property             == match_value_relate.value_for_business_dispose_property
      assert found.value_for_business_foreign_shareholder          == match_value_relate.value_for_business_foreign_shareholder
      assert found.value_for_business_income_over_thousand         == match_value_relate.value_for_business_income_over_thousand
      assert found.value_for_business_invest_research              == match_value_relate.value_for_business_invest_research
      assert found.value_for_business_k1_count                     == match_value_relate.value_for_business_k1_count
      assert found.value_for_business_make_distribution            == match_value_relate.value_for_business_make_distribution
      assert found.value_for_business_state                        == match_value_relate.value_for_business_state
      assert found.value_for_business_tax_exemption                == match_value_relate.value_for_business_tax_exemption
      assert found.value_for_business_total_asset_over             == match_value_relate.value_for_business_total_asset_over
      assert found.value_for_individual_employment_status          == match_value_relate.value_for_individual_employment_status
      assert found.value_for_individual_foreign_account_limit      == match_value_relate.value_for_individual_foreign_account_limit
      assert found.value_for_individual_foreign_financial_interest == match_value_relate.value_for_individual_foreign_financial_interest
      assert found.value_for_individual_home_owner                 == match_value_relate.value_for_individual_home_owner
      assert found.value_for_individual_k1_count                   == match_value_relate.value_for_individual_k1_count
      assert found.value_for_individual_rental_prop_income         == match_value_relate.value_for_individual_rental_prop_income
      assert found.value_for_individual_sole_prop_count            == match_value_relate.value_for_individual_sole_prop_count
      assert found.value_for_individual_state                      == match_value_relate.value_for_individual_state
      assert found.value_for_individual_tax_year                   == match_value_relate.value_for_individual_tax_year
      assert found.value_for_sale_tax_count                        == match_value_relate.value_for_sale_tax_count
    end

    it "returns not found when MatchValueRelate does not exist" do
      current_user = insert(:user, admin: true)
      context = %{context: %{current_user: current_user}}
      id = FlakeId.get()
      {:error, error} = MatchValueRelatesResolver.find(nil, %{id: id}, context)
      assert error == "The MatchValueRelate #{id} not found!"
    end

    it "returns error for missing params" do
      current_user = insert(:user, admin: true)
      context = %{context: %{current_user: current_user}}
      insert(:match_value_relat)
      args = %{id: nil, match_value_relate: nil}
      {:error, error} =
        MatchValueRelatesResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for user admin to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates MatchValueRelate" do
      current_user = insert(:user, admin: true)
      context = %{context: %{current_user: current_user}}
      args = %{
        match_for_book_keeping_additional_need:             12,
        match_for_book_keeping_annual_revenue:              12,
        match_for_book_keeping_industry:                    12,
        match_for_book_keeping_number_employee:             12,
        match_for_book_keeping_payroll:                     12,
        match_for_book_keeping_type_client:                 12,
        match_for_business_enity_type:                      12,
        match_for_business_industry:                        12,
        match_for_business_number_of_employee:              12,
        match_for_business_total_revenue:                   12,
        match_for_individual_employment_status:             12,
        match_for_individual_filing_status:                 12,
        match_for_individual_foreign_account:               12,
        match_for_individual_home_owner:                    12,
        match_for_individual_industry:                      12,
        match_for_individual_itemized_deduction:            12,
        match_for_individual_living_abroad:                 12,
        match_for_individual_non_resident_earning:          12,
        match_for_individual_own_stock_crypto:              12,
        match_for_individual_rental_prop_income:            12,
        match_for_individual_stock_divident:                12,
        match_for_sale_tax_count:                           12,
        match_for_sale_tax_frequency:                       12,
        match_for_sale_tax_industry:                        12,
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
      }

      {:ok, created} = MatchValueRelatesResolver.create(nil, args, context)

      assert created.match_for_book_keeping_additional_need          == 12
      assert created.match_for_book_keeping_additional_need          == 12
      assert created.match_for_book_keeping_additional_need          == 12
      assert created.match_for_book_keeping_annual_revenue           == 12
      assert created.match_for_book_keeping_industry                 == 12
      assert created.match_for_book_keeping_number_employee          == 12
      assert created.match_for_book_keeping_payroll                  == 12
      assert created.match_for_book_keeping_type_client              == 12
      assert created.match_for_business_enity_type                   == 12
      assert created.match_for_business_industry                     == 12
      assert created.match_for_business_number_of_employee           == 12
      assert created.match_for_business_total_revenue                == 12
      assert created.match_for_individual_employment_status          == 12
      assert created.match_for_individual_filing_status              == 12
      assert created.match_for_individual_foreign_account            == 12
      assert created.match_for_individual_home_owner                 == 12
      assert created.match_for_individual_industry                   == 12
      assert created.match_for_individual_itemized_deduction         == 12
      assert created.match_for_individual_living_abroad              == 12
      assert created.match_for_individual_non_resident_earning       == 12
      assert created.match_for_individual_own_stock_crypto           == 12
      assert created.match_for_individual_rental_prop_income         == 12
      assert created.match_for_individual_stock_divident             == 12
      assert created.match_for_sale_tax_count                        == 12
      assert created.match_for_sale_tax_frequency                    == 12
      assert created.match_for_sale_tax_industry                     == 12
      assert created.value_for_book_keeping_payroll                  == Decimal.from_float(9.99)
      assert created.value_for_book_keeping_tax_year                 == Decimal.from_float(9.99)
      assert created.value_for_business_accounting_software          == Decimal.from_float(9.99)
      assert created.value_for_business_dispose_property             == Decimal.from_float(9.99)
      assert created.value_for_business_foreign_shareholder          == Decimal.from_float(9.99)
      assert created.value_for_business_income_over_thousand         == Decimal.from_float(9.99)
      assert created.value_for_business_invest_research              == Decimal.from_float(9.99)
      assert created.value_for_business_k1_count                     == Decimal.from_float(9.99)
      assert created.value_for_business_make_distribution            == Decimal.from_float(9.99)
      assert created.value_for_business_state                        == Decimal.from_float(9.99)
      assert created.value_for_business_tax_exemption                == Decimal.from_float(9.99)
      assert created.value_for_business_total_asset_over             == Decimal.from_float(9.99)
      assert created.value_for_individual_employment_status          == Decimal.from_float(9.99)
      assert created.value_for_individual_foreign_account_limit      == Decimal.from_float(9.99)
      assert created.value_for_individual_foreign_financial_interest == Decimal.from_float(9.99)
      assert created.value_for_individual_home_owner                 == Decimal.from_float(9.99)
      assert created.value_for_individual_k1_count                   == Decimal.from_float(9.99)
      assert created.value_for_individual_rental_prop_income         == Decimal.from_float(9.99)
      assert created.value_for_individual_sole_prop_count            == Decimal.from_float(9.99)
      assert created.value_for_individual_state                      == Decimal.from_float(9.99)
      assert created.value_for_individual_tax_year                   == Decimal.from_float(9.99)
      assert created.value_for_sale_tax_count                        == Decimal.from_float(9.99)
    end

    it "returns error for missing params" do
      current_user = insert(:user, admin: true)
      context = %{context: %{current_user: current_user}}
      args = %{}
      {:error, error} =
        MatchValueRelatesResolver.create(nil, args, context)

      assert error ==
        [
          [field: :match_for_book_keeping_additional_need, message: "Can't be blank"],
          [field: :match_for_book_keeping_annual_revenue, message: "Can't be blank"],
          [field: :match_for_book_keeping_industry, message: "Can't be blank"],
          [field: :match_for_book_keeping_number_employee, message: "Can't be blank"],
          [field: :match_for_book_keeping_payroll, message: "Can't be blank"],
          [field: :match_for_book_keeping_type_client, message: "Can't be blank"],
          [field: :match_for_business_enity_type, message: "Can't be blank"],
          [field: :match_for_business_industry, message: "Can't be blank"],
          [field: :match_for_business_number_of_employee, message: "Can't be blank"],
          [field: :match_for_business_total_revenue, message: "Can't be blank"],
          [field: :match_for_individual_employment_status, message: "Can't be blank"],
          [field: :match_for_individual_filing_status, message: "Can't be blank"],
          [field: :match_for_individual_foreign_account, message: "Can't be blank"],
          [field: :match_for_individual_home_owner, message: "Can't be blank"],
          [field: :match_for_individual_industry, message: "Can't be blank"],
          [field: :match_for_individual_itemized_deduction, message: "Can't be blank"],
          [field: :match_for_individual_living_abroad, message: "Can't be blank"],
          [field: :match_for_individual_non_resident_earning, message: "Can't be blank"],
          [field: :match_for_individual_own_stock_crypto, message: "Can't be blank"],
          [field: :match_for_individual_rental_prop_income, message: "Can't be blank"],
          [field: :match_for_individual_stock_divident, message: "Can't be blank"],
          [field: :match_for_sale_tax_count, message: "Can't be blank"],
          [field: :match_for_sale_tax_frequency, message: "Can't be blank"],
          [field: :match_for_sale_tax_industry, message: "Can't be blank"],
          [field: :value_for_book_keeping_payroll, message: "Can't be blank"],
          [field: :value_for_book_keeping_tax_year, message: "Can't be blank"],
          [field: :value_for_business_accounting_software, message: "Can't be blank"],
          [field: :value_for_business_dispose_property, message: "Can't be blank"],
          [field: :value_for_business_foreign_shareholder, message: "Can't be blank"],
          [field: :value_for_business_income_over_thousand, message: "Can't be blank"],
          [field: :value_for_business_invest_research, message: "Can't be blank"],
          [field: :value_for_business_k1_count, message: "Can't be blank"],
          [field: :value_for_business_make_distribution, message: "Can't be blank"],
          [field: :value_for_business_state, message: "Can't be blank"],
          [field: :value_for_business_tax_exemption, message: "Can't be blank"],
          [field: :value_for_business_total_asset_over, message: "Can't be blank"],
          [field: :value_for_individual_employment_status, message: "Can't be blank"],
          [field: :value_for_individual_foreign_account_limit, message: "Can't be blank"],
          [field: :value_for_individual_foreign_financial_interest, message: "Can't be blank"],
          [field: :value_for_individual_home_owner, message: "Can't be blank"],
          [field: :value_for_individual_k1_count, message: "Can't be blank"],
          [field: :value_for_individual_rental_prop_income, message: "Can't be blank"],
          [field: :value_for_individual_sole_prop_count, message: "Can't be blank"],
          [field: :value_for_individual_state, message: "Can't be blank"],
          [field: :value_for_individual_tax_year, message: "Can't be blank"],
          [field: :value_for_sale_tax_count, message: "Can't be blank"]
        ]
    end
  end

  describe "#update" do
    it "update specific MatchValueRelate by id" do
      current_user = insert(:user, admin: true)
      context = %{context: %{current_user: current_user}}
      match_value_relate = insert(:match_value_relat)
      params = %{
        match_for_book_keeping_additional_need:             13,
        match_for_book_keeping_annual_revenue:              13,
        match_for_book_keeping_industry:                    13,
        match_for_book_keeping_number_employee:             13,
        match_for_book_keeping_payroll:                     13,
        match_for_book_keeping_type_client:                 13,
        match_for_business_enity_type:                      13,
        match_for_business_industry:                        13,
        match_for_business_number_of_employee:              13,
        match_for_business_total_revenue:                   13,
        match_for_individual_employment_status:             13,
        match_for_individual_filing_status:                 13,
        match_for_individual_foreign_account:               13,
        match_for_individual_home_owner:                    13,
        match_for_individual_industry:                      13,
        match_for_individual_itemized_deduction:            13,
        match_for_individual_living_abroad:                 13,
        match_for_individual_non_resident_earning:          13,
        match_for_individual_own_stock_crypto:              13,
        match_for_individual_rental_prop_income:            13,
        match_for_individual_stock_divident:                13,
        match_for_sale_tax_count:                           13,
        match_for_sale_tax_frequency:                       13,
        match_for_sale_tax_industry:                        13,
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

      args = %{id: match_value_relate.id, match_value_relate: params}
      {:ok, updated} = MatchValueRelatesResolver.update(nil, args, context)

      assert updated.id                                              == match_value_relate.id
      assert updated.match_for_book_keeping_additional_need          == 13
      assert updated.match_for_book_keeping_additional_need          == 13
      assert updated.match_for_book_keeping_additional_need          == 13
      assert updated.match_for_book_keeping_annual_revenue           == 13
      assert updated.match_for_book_keeping_industry                 == 13
      assert updated.match_for_book_keeping_number_employee          == 13
      assert updated.match_for_book_keeping_payroll                  == 13
      assert updated.match_for_book_keeping_type_client              == 13
      assert updated.match_for_business_enity_type                   == 13
      assert updated.match_for_business_industry                     == 13
      assert updated.match_for_business_number_of_employee           == 13
      assert updated.match_for_business_total_revenue                == 13
      assert updated.match_for_individual_employment_status          == 13
      assert updated.match_for_individual_filing_status              == 13
      assert updated.match_for_individual_foreign_account            == 13
      assert updated.match_for_individual_home_owner                 == 13
      assert updated.match_for_individual_industry                   == 13
      assert updated.match_for_individual_itemized_deduction         == 13
      assert updated.match_for_individual_living_abroad              == 13
      assert updated.match_for_individual_non_resident_earning       == 13
      assert updated.match_for_individual_own_stock_crypto           == 13
      assert updated.match_for_individual_rental_prop_income         == 13
      assert updated.match_for_individual_stock_divident             == 13
      assert updated.match_for_sale_tax_count                        == 13
      assert updated.match_for_sale_tax_frequency                    == 13
      assert updated.match_for_sale_tax_industry                     == 13
      assert updated.value_for_book_keeping_payroll                  == Decimal.from_float(0.99)
      assert updated.value_for_book_keeping_tax_year                 == Decimal.from_float(0.99)
      assert updated.value_for_business_accounting_software          == Decimal.from_float(0.99)
      assert updated.value_for_business_dispose_property             == Decimal.from_float(0.99)
      assert updated.value_for_business_foreign_shareholder          == Decimal.from_float(0.99)
      assert updated.value_for_business_income_over_thousand         == Decimal.from_float(0.99)
      assert updated.value_for_business_invest_research              == Decimal.from_float(0.99)
      assert updated.value_for_business_k1_count                     == Decimal.from_float(0.99)
      assert updated.value_for_business_make_distribution            == Decimal.from_float(0.99)
      assert updated.value_for_business_state                        == Decimal.from_float(0.99)
      assert updated.value_for_business_tax_exemption                == Decimal.from_float(0.99)
      assert updated.value_for_business_total_asset_over             == Decimal.from_float(0.99)
      assert updated.value_for_individual_employment_status          == Decimal.from_float(0.99)
      assert updated.value_for_individual_foreign_account_limit      == Decimal.from_float(0.99)
      assert updated.value_for_individual_foreign_financial_interest == Decimal.from_float(0.99)
      assert updated.value_for_individual_home_owner                 == Decimal.from_float(0.99)
      assert updated.value_for_individual_k1_count                   == Decimal.from_float(0.99)
      assert updated.value_for_individual_rental_prop_income         == Decimal.from_float(0.99)
      assert updated.value_for_individual_sole_prop_count            == Decimal.from_float(0.99)
      assert updated.value_for_individual_state                      == Decimal.from_float(0.99)
      assert updated.value_for_individual_tax_year                   == Decimal.from_float(0.99)
      assert updated.value_for_sale_tax_count                        == Decimal.from_float(0.99)
      assert updated.inserted_at                                     == match_value_relate.inserted_at
      assert updated.updated_at                                      == match_value_relate.updated_at
    end

    it "nothing change for missing params" do
      current_user = insert(:user, admin: true)
      context = %{context: %{current_user: current_user}}
      match_value_relate = insert(:match_value_relat)
      params = %{
        match_for_business_enity_type: 12
      }
      args = %{id: match_value_relate.id, match_value_relate: params}
      {:ok, updated} = MatchValueRelatesResolver.update(nil, args, context)
      assert updated.id                                              == match_value_relate.id
      assert updated.inserted_at                                     == match_value_relate.inserted_at
      assert updated.updated_at                                      == match_value_relate.updated_at
    end

    it "returns error for missing params" do
      current_user = insert(:user, admin: true)
      context = %{context: %{current_user: current_user}}
      insert(:match_value_relat)
      args = %{id: nil, match_value_relate: nil}
      {:error, error} =
        MatchValueRelatesResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for user admin to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific MatchValueRelate by id" do
      current_user = insert(:user, admin: true)
      context = %{context: %{current_user: current_user}}
      match_value_relate = insert(:match_value_relat)
      {:ok, delete} = MatchValueRelatesResolver.delete(nil, %{id: match_value_relate.id}, context)
      assert delete.id == match_value_relate.id
    end

    it "returns not found when MatchValueRelate does not exist" do
      current_user = insert(:user, admin: true)
      context = %{context: %{current_user: current_user}}
      id = FlakeId.get()
      {:error, error} = MatchValueRelatesResolver.delete(nil, %{id: id}, context)
      assert error == "The MatchValueRelate #{id} not found!"
    end

    it "returns error for missing params" do
      current_user = insert(:user, admin: true)
      context = %{context: %{current_user: current_user}}
      insert(:match_value_relat)
      args = %{id: nil}
      {:error, error} =
        MatchValueRelatesResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for user admin to perform action Delete"]]
    end
  end
end

defmodule Core.Services.MatchValueRelateTest do
  use Core.DataCase

  alias Core.{
    Services,
    Services.MatchValueRelate
  }

  alias Decimal, as: D

  describe "match_value_relates" do
    test "list_match_value_relate/0 returns all match_value_relate" do
      match_value_relate = insert(:match_value_relat)
      assert Services.list_match_value_relate() == [match_value_relate]
    end

    test "get_match_value_relate!/1 returns the match_value_relate with given id" do
      match_value_relate = insert(:match_value_relat)
      assert Services.get_match_value_relate!(match_value_relate.id) ==
        match_value_relate
    end

    test "create_match_value_relate/1 with valid data creates a match_value_relate" do
      params = %{
        match_for_book_keeping_additional_need:            42,
        match_for_book_keeping_annual_revenue:             42,
        match_for_book_keeping_industry:                   42,
        match_for_book_keeping_number_employee:            42,
        match_for_book_keeping_payroll:                    42,
        match_for_book_keeping_type_client:                42,
        match_for_business_enity_type:                     42,
        match_for_business_industry:                       42,
        match_for_business_number_of_employee:             42,
        match_for_business_total_revenue:                  42,
        match_for_individual_employment_status:            42,
        match_for_individual_filing_status:                42,
        match_for_individual_foreign_account:              42,
        match_for_individual_home_owner:                   42,
        match_for_individual_industry:                     42,
        match_for_individual_itemized_deduction:           42,
        match_for_individual_living_abroad:                42,
        match_for_individual_non_resident_earning:         42,
        match_for_individual_own_stock_crypto:             42,
        match_for_individual_rental_prop_income:           42,
        match_for_individual_stock_divident:               42,
        match_for_sale_tax_count:                          42,
        match_for_sale_tax_frequency:                      42,
        match_for_sale_tax_industry:                       42,
        value_for_book_keeping_payroll:                  12.5,
        value_for_book_keeping_tax_year:                 12.5,
        value_for_business_accounting_software:          12.5,
        value_for_business_dispose_property:             12.5,
        value_for_business_foreign_shareholder:          12.5,
        value_for_business_income_over_thousand:         12.5,
        value_for_business_invest_research:              12.5,
        value_for_business_k1_count:                     12.5,
        value_for_business_make_distribution:            12.5,
        value_for_business_state:                        12.5,
        value_for_business_tax_exemption:                12.5,
        value_for_business_total_asset_over:             12.5,
        value_for_individual_employment_status:          12.5,
        value_for_individual_foreign_account_limit:      12.5,
        value_for_individual_foreign_financial_interest: 12.5,
        value_for_individual_home_owner:                 12.5,
        value_for_individual_k1_count:                   12.5,
        value_for_individual_rental_prop_income:         12.5,
        value_for_individual_sole_prop_count:            12.5,
        value_for_individual_state:                      12.5,
        value_for_individual_tax_year:                   12.5,
        value_for_sale_tax_count:                        12.5
      }

      assert {:ok, %MatchValueRelate{} = match_value_relate} =
        Services.create_match_value_relate(params)

      assert match_value_relate.match_for_book_keeping_additional_need          == 42
      assert match_value_relate.match_for_book_keeping_annual_revenue           == 42
      assert match_value_relate.match_for_book_keeping_industry                 == 42
      assert match_value_relate.match_for_book_keeping_number_employee          == 42
      assert match_value_relate.match_for_book_keeping_payroll                  == 42
      assert match_value_relate.match_for_book_keeping_type_client              == 42
      assert match_value_relate.match_for_business_enity_type                   == 42
      assert match_value_relate.match_for_business_industry                     == 42
      assert match_value_relate.match_for_business_number_of_employee           == 42
      assert match_value_relate.match_for_business_total_revenue                == 42
      assert match_value_relate.match_for_individual_employment_status          == 42
      assert match_value_relate.match_for_individual_filing_status              == 42
      assert match_value_relate.match_for_individual_foreign_account            == 42
      assert match_value_relate.match_for_individual_home_owner                 == 42
      assert match_value_relate.match_for_individual_industry                   == 42
      assert match_value_relate.match_for_individual_itemized_deduction         == 42
      assert match_value_relate.match_for_individual_living_abroad              == 42
      assert match_value_relate.match_for_individual_non_resident_earning       == 42
      assert match_value_relate.match_for_individual_own_stock_crypto           == 42
      assert match_value_relate.match_for_individual_rental_prop_income         == 42
      assert match_value_relate.match_for_individual_stock_divident             == 42
      assert match_value_relate.match_for_sale_tax_count                        == 42
      assert match_value_relate.match_for_sale_tax_frequency                    == 42
      assert match_value_relate.match_for_sale_tax_industry                     == 42
      assert match_value_relate.value_for_book_keeping_payroll                  == D.new("12.5")
      assert match_value_relate.value_for_book_keeping_tax_year                 == D.new("12.5")
      assert match_value_relate.value_for_business_accounting_software          == D.new("12.5")
      assert match_value_relate.value_for_business_dispose_property             == D.new("12.5")
      assert match_value_relate.value_for_business_foreign_shareholder          == D.new("12.5")
      assert match_value_relate.value_for_business_income_over_thousand         == D.new("12.5")
      assert match_value_relate.value_for_business_invest_research              == D.new("12.5")
      assert match_value_relate.value_for_business_k1_count                     == D.new("12.5")
      assert match_value_relate.value_for_business_make_distribution            == D.new("12.5")
      assert match_value_relate.value_for_business_state                        == D.new("12.5")
      assert match_value_relate.value_for_business_tax_exemption                == D.new("12.5")
      assert match_value_relate.value_for_business_total_asset_over             == D.new("12.5")
      assert match_value_relate.value_for_individual_employment_status          == D.new("12.5")
      assert match_value_relate.value_for_individual_foreign_account_limit      == D.new("12.5")
      assert match_value_relate.value_for_individual_foreign_financial_interest == D.new("12.5")
      assert match_value_relate.value_for_individual_home_owner                 == D.new("12.5")
      assert match_value_relate.value_for_individual_k1_count                   == D.new("12.5")
      assert match_value_relate.value_for_individual_rental_prop_income         == D.new("12.5")
      assert match_value_relate.value_for_individual_sole_prop_count            == D.new("12.5")
      assert match_value_relate.value_for_individual_state                      == D.new("12.5")
      assert match_value_relate.value_for_individual_tax_year                   == D.new("12.5")
      assert match_value_relate.value_for_sale_tax_count                        == D.new("12.5")
      assert match_value_relate.inserted_at                                     == match_value_relate.inserted_at
      assert match_value_relate.updated_at                                      == match_value_relate.updated_at
    end

    test "create_match_value_relate/1 with valid data if the record none exist" do
      params = %{
        match_for_book_keeping_additional_need:            42,
        match_for_book_keeping_annual_revenue:             42,
        match_for_book_keeping_industry:                   42,
        match_for_book_keeping_number_employee:            42,
        match_for_book_keeping_payroll:                    42,
        match_for_book_keeping_type_client:                42,
        match_for_business_enity_type:                     42,
        match_for_business_industry:                       42,
        match_for_business_number_of_employee:             42,
        match_for_business_total_revenue:                  42,
        match_for_individual_employment_status:            42,
        match_for_individual_filing_status:                42,
        match_for_individual_foreign_account:              42,
        match_for_individual_home_owner:                   42,
        match_for_individual_industry:                     42,
        match_for_individual_itemized_deduction:           42,
        match_for_individual_living_abroad:                42,
        match_for_individual_non_resident_earning:         42,
        match_for_individual_own_stock_crypto:             42,
        match_for_individual_rental_prop_income:           42,
        match_for_individual_stock_divident:               42,
        match_for_sale_tax_count:                          42,
        match_for_sale_tax_frequency:                      42,
        match_for_sale_tax_industry:                       42,
        value_for_book_keeping_payroll:                  12.5,
        value_for_book_keeping_tax_year:                 12.5,
        value_for_business_accounting_software:          12.5,
        value_for_business_dispose_property:             12.5,
        value_for_business_foreign_shareholder:          12.5,
        value_for_business_income_over_thousand:         12.5,
        value_for_business_invest_research:              12.5,
        value_for_business_k1_count:                     12.5,
        value_for_business_make_distribution:            12.5,
        value_for_business_state:                        12.5,
        value_for_business_tax_exemption:                12.5,
        value_for_business_total_asset_over:             12.5,
        value_for_individual_employment_status:          12.5,
        value_for_individual_foreign_account_limit:      12.5,
        value_for_individual_foreign_financial_interest: 12.5,
        value_for_individual_home_owner:                 12.5,
        value_for_individual_k1_count:                   12.5,
        value_for_individual_rental_prop_income:         12.5,
        value_for_individual_sole_prop_count:            12.5,
        value_for_individual_state:                      12.5,
        value_for_individual_tax_year:                   12.5,
        value_for_sale_tax_count:                        12.5
      }

      assert {:ok, %MatchValueRelate{}} =
        Services.create_match_value_relate(params)
      assert {:error, %Ecto.Changeset{}} =
        Services.create_match_value_relate(params)
    end

    test "create_match_value_relate/1 with invalid data returns error changeset" do
      params = %{
        match_for_book_keeping_additional_need:          nil,
        match_for_book_keeping_annual_revenue:           nil,
        match_for_book_keeping_industry:                 nil,
        match_for_book_keeping_number_employee:          nil,
        match_for_book_keeping_payroll:                  nil,
        match_for_book_keeping_type_client:              nil,
        match_for_business_enity_type:                   nil,
        match_for_business_industry:                     nil,
        match_for_business_number_of_employee:           nil,
        match_for_business_total_revenue:                nil,
        match_for_individual_employment_status:          nil,
        match_for_individual_filing_status:              nil,
        match_for_individual_foreign_account:            nil,
        match_for_individual_home_owner:                 nil,
        match_for_individual_industry:                   nil,
        match_for_individual_itemized_deduction:         nil,
        match_for_individual_living_abroad:              nil,
        match_for_individual_non_resident_earning:       nil,
        match_for_individual_own_stock_crypto:           nil,
        match_for_individual_rental_prop_income:         nil,
        match_for_individual_stock_divident:             nil,
        match_for_sale_tax_count:                        nil,
        match_for_sale_tax_frequency:                    nil,
        match_for_sale_tax_industry:                     nil,
        value_for_book_keeping_payroll:                  nil,
        value_for_book_keeping_tax_year:                 nil,
        value_for_business_accounting_software:          nil,
        value_for_business_dispose_property:             nil,
        value_for_business_foreign_shareholder:          nil,
        value_for_business_income_over_thousand:         nil,
        value_for_business_invest_research:              nil,
        value_for_business_k1_count:                     nil,
        value_for_business_make_distribution:            nil,
        value_for_business_state:                        nil,
        value_for_business_tax_exemption:                nil,
        value_for_business_total_asset_over:             nil,
        value_for_individual_employment_status:          nil,
        value_for_individual_foreign_account_limit:      nil,
        value_for_individual_foreign_financial_interest: nil,
        value_for_individual_home_owner:                 nil,
        value_for_individual_k1_count:                   nil,
        value_for_individual_rental_prop_income:         nil,
        value_for_individual_sole_prop_count:            nil,
        value_for_individual_state:                      nil,
        value_for_individual_tax_year:                   nil,
        value_for_sale_tax_count:                        nil
      }

      assert {:error, %Ecto.Changeset{}} =
        Services.create_match_value_relate(params)
    end

    test "update_match_value_relate/2 with valid data updates the match_value_relate" do
      match_value_relate = insert(:match_value_relat)

      params = %{
        match_for_book_keeping_additional_need:            43,
        match_for_book_keeping_annual_revenue:             43,
        match_for_book_keeping_industry:                   43,
        match_for_book_keeping_number_employee:            43,
        match_for_book_keeping_payroll:                    43,
        match_for_book_keeping_type_client:                43,
        match_for_business_enity_type:                     43,
        match_for_business_industry:                       43,
        match_for_business_number_of_employee:             43,
        match_for_business_total_revenue:                  43,
        match_for_individual_employment_status:            43,
        match_for_individual_filing_status:                43,
        match_for_individual_foreign_account:              43,
        match_for_individual_home_owner:                   43,
        match_for_individual_industry:                     43,
        match_for_individual_itemized_deduction:           43,
        match_for_individual_living_abroad:                43,
        match_for_individual_non_resident_earning:         43,
        match_for_individual_own_stock_crypto:             43,
        match_for_individual_rental_prop_income:           43,
        match_for_individual_stock_divident:               43,
        match_for_sale_tax_count:                          43,
        match_for_sale_tax_frequency:                      43,
        match_for_sale_tax_industry:                       43,
        value_for_book_keeping_payroll:                  13.5,
        value_for_book_keeping_tax_year:                 13.5,
        value_for_business_accounting_software:          13.5,
        value_for_business_dispose_property:             13.5,
        value_for_business_foreign_shareholder:          13.5,
        value_for_business_income_over_thousand:         13.5,
        value_for_business_invest_research:              13.5,
        value_for_business_k1_count:                     13.5,
        value_for_business_make_distribution:            13.5,
        value_for_business_state:                        13.5,
        value_for_business_tax_exemption:                13.5,
        value_for_business_total_asset_over:             13.5,
        value_for_individual_employment_status:          13.5,
        value_for_individual_foreign_account_limit:      13.5,
        value_for_individual_foreign_financial_interest: 13.5,
        value_for_individual_home_owner:                 13.5,
        value_for_individual_k1_count:                   13.5,
        value_for_individual_rental_prop_income:         13.5,
        value_for_individual_sole_prop_count:            13.5,
        value_for_individual_state:                      13.5,
        value_for_individual_tax_year:                   13.5,
        value_for_sale_tax_count:                        13.5
      }

      assert {:ok, %MatchValueRelate{} = updated_match_value_relate} =
        Services.update_match_value_relate(match_value_relate, params)

      assert updated_match_value_relate.match_for_business_enity_type                   == 43
      assert updated_match_value_relate.match_for_book_keeping_additional_need          == 43
      assert updated_match_value_relate.match_for_book_keeping_annual_revenue           == 43
      assert updated_match_value_relate.match_for_book_keeping_industry                 == 43
      assert updated_match_value_relate.match_for_book_keeping_number_employee          == 43
      assert updated_match_value_relate.match_for_book_keeping_payroll                  == 43
      assert updated_match_value_relate.match_for_book_keeping_type_client              == 43
      assert updated_match_value_relate.match_for_business_enity_type                   == 43
      assert updated_match_value_relate.match_for_business_industry                     == 43
      assert updated_match_value_relate.match_for_business_number_of_employee           == 43
      assert updated_match_value_relate.match_for_business_total_revenue                == 43
      assert updated_match_value_relate.match_for_individual_employment_status          == 43
      assert updated_match_value_relate.match_for_individual_filing_status              == 43
      assert updated_match_value_relate.match_for_individual_foreign_account            == 43
      assert updated_match_value_relate.match_for_individual_home_owner                 == 43
      assert updated_match_value_relate.match_for_individual_industry                   == 43
      assert updated_match_value_relate.match_for_individual_itemized_deduction         == 43
      assert updated_match_value_relate.match_for_individual_living_abroad              == 43
      assert updated_match_value_relate.match_for_individual_non_resident_earning       == 43
      assert updated_match_value_relate.match_for_individual_own_stock_crypto           == 43
      assert updated_match_value_relate.match_for_individual_rental_prop_income         == 43
      assert updated_match_value_relate.match_for_individual_stock_divident             == 43
      assert updated_match_value_relate.match_for_sale_tax_count                        == 43
      assert updated_match_value_relate.match_for_sale_tax_frequency                    == 43
      assert updated_match_value_relate.match_for_sale_tax_industry                     == 43
      assert updated_match_value_relate.value_for_book_keeping_payroll                  == D.new("13.5")
      assert updated_match_value_relate.value_for_book_keeping_tax_year                 == D.new("13.5")
      assert updated_match_value_relate.value_for_business_accounting_software          == D.new("13.5")
      assert updated_match_value_relate.value_for_business_dispose_property             == D.new("13.5")
      assert updated_match_value_relate.value_for_business_foreign_shareholder          == D.new("13.5")
      assert updated_match_value_relate.value_for_business_income_over_thousand         == D.new("13.5")
      assert updated_match_value_relate.value_for_business_invest_research              == D.new("13.5")
      assert updated_match_value_relate.value_for_business_k1_count                     == D.new("13.5")
      assert updated_match_value_relate.value_for_business_make_distribution            == D.new("13.5")
      assert updated_match_value_relate.value_for_business_state                        == D.new("13.5")
      assert updated_match_value_relate.value_for_business_tax_exemption                == D.new("13.5")
      assert updated_match_value_relate.value_for_business_total_asset_over             == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_employment_status          == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_foreign_account_limit      == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_foreign_financial_interest == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_home_owner                 == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_k1_count                   == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_rental_prop_income         == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_sole_prop_count            == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_state                      == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_tax_year                   == D.new("13.5")
      assert updated_match_value_relate.value_for_sale_tax_count                        == D.new("13.5")
      assert updated_match_value_relate.inserted_at                                     == match_value_relate.inserted_at
      assert updated_match_value_relate.updated_at                                      == match_value_relate.updated_at
    end

    test "update_match_value_relate/2 with invalid data returns error changeset" do
      match_value_relate = insert(:match_value_relat)
      params = %{
        match_for_book_keeping_additional_need:          nil,
        match_for_book_keeping_annual_revenue:           nil,
        match_for_book_keeping_industry:                 nil,
        match_for_book_keeping_number_employee:          nil,
        match_for_book_keeping_payroll:                  nil,
        match_for_book_keeping_type_client:              nil,
        match_for_business_enity_type:                   nil,
        match_for_business_industry:                     nil,
        match_for_business_number_of_employee:           nil,
        match_for_business_total_revenue:                nil,
        match_for_individual_employment_status:          nil,
        match_for_individual_filing_status:              nil,
        match_for_individual_foreign_account:            nil,
        match_for_individual_home_owner:                 nil,
        match_for_individual_industry:                   nil,
        match_for_individual_itemized_deduction:         nil,
        match_for_individual_living_abroad:              nil,
        match_for_individual_non_resident_earning:       nil,
        match_for_individual_own_stock_crypto:           nil,
        match_for_individual_rental_prop_income:         nil,
        match_for_individual_stock_divident:             nil,
        match_for_sale_tax_count:                        nil,
        match_for_sale_tax_frequency:                    nil,
        match_for_sale_tax_industry:                     nil,
        value_for_book_keeping_payroll:                  nil,
        value_for_book_keeping_tax_year:                 nil,
        value_for_business_accounting_software:          nil,
        value_for_business_dispose_property:             nil,
        value_for_business_foreign_shareholder:          nil,
        value_for_business_income_over_thousand:         nil,
        value_for_business_invest_research:              nil,
        value_for_business_k1_count:                     nil,
        value_for_business_make_distribution:            nil,
        value_for_business_state:                        nil,
        value_for_business_tax_exemption:                nil,
        value_for_business_total_asset_over:             nil,
        value_for_individual_employment_status:          nil,
        value_for_individual_foreign_account_limit:      nil,
        value_for_individual_foreign_financial_interest: nil,
        value_for_individual_home_owner:                 nil,
        value_for_individual_k1_count:                   nil,
        value_for_individual_rental_prop_income:         nil,
        value_for_individual_sole_prop_count:            nil,
        value_for_individual_state:                      nil,
        value_for_individual_tax_year:                   nil,
        value_for_sale_tax_count:                        nil
      }

      assert {:error, %Ecto.Changeset{}} =
        Services.update_match_value_relate(match_value_relate, params)
      assert match_value_relate ==
        Services.get_match_value_relate!(match_value_relate.id)
    end

    test "delete_match_value_relate/1 deletes the match_value_relate" do
      match_value_relate = insert(:match_value_relat)
      assert {:ok, %MatchValueRelate{}} =
        Services.delete_match_value_relate(match_value_relate)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_match_value_relate!(match_value_relate.id)
      end
    end

    test "change_match_value_relate/1 returns a match_value_relate changeset" do
      match_value_relate = insert(:match_value_relat)
      assert %Ecto.Changeset{} =
        Services.change_match_value_relate(match_value_relate)
    end
  end
end

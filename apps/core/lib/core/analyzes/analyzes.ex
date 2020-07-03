defmodule Core.Analyzes do
  @moduledoc """
  Analyze's Services.
  """

  @type word() :: String.t()

  @spec total_all(word) :: [%{atom => word, atom => integer | float}]
  def total_all(id) do
    id
  end

  @spec total_match(word) :: [%{atom => word, atom => integer}]
  def total_match(id) do
    # BookKeeping.check_match_payroll(id)
    # BookKeeping.check_match_book_keeping_additional_need(id)
    # BookKeeping.check_match_book_keeping_annual_revenue(id)
    # BookKeeping.check_match_book_keeping_industry(id)
    # BookKeeping.check_match_book_keeping_number_employee(id)
    # BookKeeping.check_match_book_keeping_type_client(id)
    #
    # BusinessTaxReturn.check_match_business_entity_type(id)
    # BusinessTaxReturn.check_match_business_industry(id)
    # BusinessTaxReturn.check_match_business_number_of_employee(id)
    # BusinessTaxReturn.check_match_business_total_revenue(id)
    #
    # IndividualTaxReturn.check_match_foreign_account(id)
    # IndividualTaxReturn.check_match_home_owner(id)
    # IndividualTaxReturn.check_match_individual_employment_status(id)
    # IndividualTaxReturn.check_match_individual_filing_status(id)
    # IndividualTaxReturn.check_match_individual_industry(id)
    # IndividualTaxReturn.check_match_individual_itemized_deduction(id)
    # IndividualTaxReturn.check_match_living_abroad(id)
    # IndividualTaxReturn.check_match_non_resident_earning(id)
    # IndividualTaxReturn.check_match_own_stock_crypto(id)
    # IndividualTaxReturn.check_match_rental_property_income(id)
    # IndividualTaxReturn.check_match_stock_divident(id)
    #
    # SaleTax.check_match_sale_tax_count(id)
    # SaleTax.check_match_sale_tax_frequency(id)
    # SaleTax.check_match_sale_tax_industry(id)
    id
  end

  @spec total_price(word) :: [%{atom => word, atom => integer}]
  def total_price(id) do
    # BookKeeping.check_price_payroll(id)
    # BookKeeping.check_price_book_keeping_additional_need(id)
    # BookKeeping.check_price_book_keeping_annual_revenue(id)
    # BookKeeping.check_price_book_keeping_number_employee(id)
    # BookKeeping.check_price_book_keeping_transaction_volume(id)
    # BookKeeping.check_price_book_keeping_type_client(id)
    #
    # BusinessTaxReturn.check_price_business_entity_type(id)
    # BusinessTaxReturn.check_price_business_number_of_employee(id)
    # BusinessTaxReturn.check_price_business_total_revenue(id)
    # BusinessTaxReturn.check_price_state(id)
    # BusinessTaxReturn.check_price_tax_year(id)
    #
    # IndividualTaxReturn.check_price_foreign_account(id)
    # IndividualTaxReturn.check_price_home_owner(id)
    # IndividualTaxReturn.check_price_individual_employment_status(id)
    # IndividualTaxReturn.check_price_individual_filing_status(id)
    # IndividualTaxReturn.check_price_individual_itemized_deduction(id)
    # IndividualTaxReturn.check_price_living_abroad(id)
    # IndividualTaxReturn.check_price_non_resident_earning(id)
    # IndividualTaxReturn.check_price_own_stock_crypto(id)
    # IndividualTaxReturn.check_price_rental_property_income(id)
    # IndividualTaxReturn.check_price_sole_proprietorship_count(id)
    # IndividualTaxReturn.check_price_state(id)
    # IndividualTaxReturn.check_price_stock_divident(id)
    # IndividualTaxReturn.check_price_tax_year(id)
    #
    # SaleTax.check_price_sale_tax_count(id)
    # SaleTax.check_price_sale_tax_frequency(id)
    id
  end

  @spec total_value(word) :: [%{atom => word, atom => float}]
  def total_value(id) do
    # BookKeeping.check_value_payroll(id)
    # BookKeeping.check_value_tax_year(id)
    # BookKeeping.check_value_book_keeping_additional_need(id)
    # BookKeeping.check_value_book_keeping_annual_revenue(id)
    # BookKeeping.check_value_book_keeping_number_employee(id)
    # BookKeeping.check_value_book_keeping_transaction_volume(id)
    # BookKeeping.check_value_book_keeping_type_client(id)
    #
    # BusinessTaxReturn.check_value_accounting_software(id)
    # BusinessTaxReturn.check_value_business_entity_type(id)
    # BusinessTaxReturn.check_value_business_foreign_ownership_count(id)
    # BusinessTaxReturn.check_value_business_total_revenue(id)
    # BusinessTaxReturn.check_value_business_transaction_count(id)
    # BusinessTaxReturn.check_value_dispose_property(id)
    # BusinessTaxReturn.check_value_foreign_shareholder(id)
    # BusinessTaxReturn.check_value_income_over_thousand(id)
    # BusinessTaxReturn.check_value_invest_research(id)
    # BusinessTaxReturn.check_value_k1_count(id)
    # BusinessTaxReturn.check_value_make_distribution(id)
    # BusinessTaxReturn.check_value_state(id)
    # BusinessTaxReturn.check_value_tax_exemption(id)
    # BusinessTaxReturn.check_value_tax_year
    # BusinessTaxReturn.check_value_total_asset_over(id)
    #
    # IndividualTaxReturn.check_value_foreign_account_limit(id)
    # IndividualTaxReturn.check_value_foreign_financial_interest(id)
    # IndividualTaxReturn.check_value_home_owner(id)
    # IndividualTaxReturn.check_value_individual_employment_status(id)
    # IndividualTaxReturn.check_value_individual_filing_status(id)
    # IndividualTaxReturn.check_value_individual_stock_transaction_count(id)
    # IndividualTaxReturn.check_value_k1_count(id)
    # IndividualTaxReturn.check_value_rental_property_income(id)
    # IndividualTaxReturn.check_value_sole_proprietorship_count(id)
    # IndividualTaxReturn.check_value_state(id)
    # IndividualTaxReturn.check_value_tax_year(id)
    #
    # SaleTax.check_value_sale_tax_count(id)
    id
  end
end

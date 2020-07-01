defmodule Core.Analyzes do
  @moduledoc """
  Analyze's Services.
  """

  # alias Core.Analyzes.{BookKeeping, BusinessTaxReturn, IndividualTaxReturn, SaleTax}

  @type word() :: String.t()

  @spec total_all(word) :: [%{atom => word, atom => integer | float}]
  def total_all(id) do
    id
  end

  @spec total_match(word) :: [%{atom => word, atom => integer}]
  def total_match(id) do
    # check_match_foreign_account(id)
    # check_match_home_owner(id)
    # check_match_individual_employment_status(id)
    # check_match_individual_filing_status(id)
    # check_match_individual_industry(id)
    # check_match_individual_itemized_deduction(id)
    # check_match_living_abroad(id)
    # check_match_non_resident_earning(id)
    # check_match_own_stock_crypto(id)
    # check_match_rental_property_income(id)
    # check_match_stock_divident(id)
    id
  end

  @spec total_price(word) :: [%{atom => word, atom => integer}]
  def total_price(id) do
    # check_price_foreign_account(id)
    # check_price_home_owner(id)
    # check_price_individual_employment_status(id)
    # check_price_individual_filing_status(id)
    # check_price_individual_itemized_deduction(id)
    # check_price_living_abroad(id)
    # check_price_non_resident_earning(id)
    # check_price_own_stock_crypto(id)
    # check_price_rental_property_income(id)
    # check_price_sole_proprietorship_count(id)
    # check_price_state(id)
    # check_price_stock_divident(id)
    # check_price_tax_year(id)
    id
  end

  @spec total_value(word) :: [%{atom => word, atom => float}]
  def total_value(id) do
    # check_value_foreign_account_limit(id)
    # check_value_foreign_financial_interest(id)
    # check_value_home_owner(id)
    # check_value_individual_employment_status(id)
    # check_value_individual_filing_status(id)
    # check_value_individual_stock_transaction_count(id)
    # check_value_k1_count(id)
    # check_value_rental_property_income(id)
    # check_value_sole_proprietorship_count(id)
    # check_value_state(id)
    # check_value_tax_year(id)
    id
  end
end

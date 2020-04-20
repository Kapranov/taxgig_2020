defmodule Core.Seeder.Services do
  @moduledoc """
  Seeds for `Core.Services` context.
  """

  alias Core.{
    Repo,
    Services.MatchValueRelate
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(MatchValueRelate)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_match_value_relate()
  end

  @spec seed_match_value_relate() :: nil | Ecto.Schema.t()
  defp seed_match_value_relate do
    case Repo.aggregate(MatchValueRelate, :count, :id) > 0 do
      true -> nil
      false -> insert_match_value_relate()
    end
  end

  @spec insert_match_value_relate() :: Ecto.Schema.t()
  defp insert_match_value_relate do
    [
      Repo.insert!(%MatchValueRelate{
        match_for_book_keeping_additional_need:             20,
        match_for_book_keeping_annual_revenue:              25,
        match_for_book_keeping_industry:                    10,
        match_for_book_keeping_number_employee:             25,
        match_for_book_keeping_payroll:                     20,
        match_for_book_keeping_type_client:                 60,
        match_for_business_enity_type:                      50,
        match_for_business_number_of_employee:              20,
        match_for_business_total_revenue:                   20,
        match_for_individual_employment_status:             35,
        match_for_individual_filing_status:                 50,
        match_for_individual_foreign_account:               20,
        match_for_individual_home_owner:                    20,
        match_for_individual_itemized_deduction:            20,
        match_for_individual_living_abroad:                 20,
        match_for_individual_non_resident_earning:          20,
        match_for_individual_own_stock_crypto:              20,
        match_for_individual_rental_prop_income:            20,
        match_for_individual_stock_divident:                20,
        match_for_sale_tax_count:                           50,
        match_for_sale_tax_frequency:                       10,
        match_for_sale_tax_industry:                        10,
        value_for_book_keeping_payroll:                   80.0,
        value_for_book_keeping_tax_year:                 150.0,
        value_for_business_accounting_software:          29.99,
        value_for_business_dispose_property:             99.99,
        value_for_business_foreign_shareholder:          150.0,
        value_for_business_income_over_thousand:         99.99,
        value_for_business_invest_research:               20.0,
        value_for_business_k1_count:                       6.0,
        value_for_business_make_distribution:             20.0,
        value_for_business_state:                         50.0,
        value_for_business_tax_exemption:                400.0,
        value_for_business_total_asset_over:             150.0,
        value_for_individual_employment_status:          180.0,
        value_for_individual_foreign_account_limit:      199.0,
        value_for_individual_foreign_financial_interest: 299.0,
        value_for_individual_home_owner:                 120.0,
        value_for_individual_k1_count:                   17.99,
        value_for_individual_rental_prop_income:          30.0,
        value_for_individual_sole_prop_count:            180.0,
        value_for_individual_state:                       40.0,
        value_for_individual_tax_year:                    40.0,
        value_for_sale_tax_count:                         30.0
      })
    ]
  end
end

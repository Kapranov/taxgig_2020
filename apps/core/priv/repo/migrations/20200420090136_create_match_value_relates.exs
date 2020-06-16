defmodule Core.Repo.Migrations.CreateMatchValueRelates do
  use Ecto.Migration

  def change do
    create table(:match_value_relates, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :match_for_book_keeping_additional_need, :integer, default: 0
      add :match_for_book_keeping_annual_revenue, :integer, default: 0
      add :match_for_book_keeping_industry, :integer, default: 0
      add :match_for_book_keeping_number_employee, :integer, default: 0
      add :match_for_book_keeping_payroll, :integer, default: 0
      add :match_for_book_keeping_type_client, :integer, default: 0
      add :match_for_business_enity_type, :integer, default: 0
      add :match_for_business_industry, :integer, default: 0
      add :match_for_business_number_of_employee, :integer, default: 0
      add :match_for_business_total_revenue, :integer, default: 0
      add :match_for_individual_employment_status, :integer, default: 0
      add :match_for_individual_filing_status, :integer, default: 0
      add :match_for_individual_foreign_account, :integer, default: 0
      add :match_for_individual_home_owner, :integer, default: 0
      add :match_for_individual_industry, :integer, default: 0
      add :match_for_individual_itemized_deduction, :integer, default: 0
      add :match_for_individual_living_abroad, :integer, default: 0
      add :match_for_individual_non_resident_earning, :integer, default: 0
      add :match_for_individual_own_stock_crypto, :integer, default: 0
      add :match_for_individual_rental_prop_income, :integer, default: 0
      add :match_for_individual_stock_divident, :integer, default: 0
      add :match_for_sale_tax_count, :integer, default: 0
      add :match_for_sale_tax_frequency, :integer, default: 0
      add :match_for_sale_tax_industry, :integer, default: 0
      add :value_for_book_keeping_payroll, :decimal, default: 0.0
      add :value_for_book_keeping_tax_year, :decimal, default: 0.0
      add :value_for_business_accounting_software, :decimal, default: 0.0
      add :value_for_business_dispose_property, :decimal, default: 0.0
      add :value_for_business_foreign_shareholder, :decimal, default: 0.0
      add :value_for_business_income_over_thousand, :decimal, default: 0.0
      add :value_for_business_invest_research, :decimal, default: 0.0
      add :value_for_business_k1_count, :decimal, default: 0.0
      add :value_for_business_make_distribution, :decimal, default: 0.0
      add :value_for_business_state, :decimal, default: 0.0
      add :value_for_business_tax_exemption, :decimal, default: 0.0
      add :value_for_business_total_asset_over, :decimal, default: 0.0
      add :value_for_individual_employment_status, :decimal, default: 0.0
      add :value_for_individual_foreign_account_limit, :decimal, default: 0.0
      add :value_for_individual_foreign_financial_interest, :decimal, default: 0.0
      add :value_for_individual_home_owner, :decimal, default: 0.0
      add :value_for_individual_k1_count, :decimal, default: 0.0
      add :value_for_individual_rental_prop_income, :decimal, default: 0.0
      add :value_for_individual_sole_prop_count, :decimal, default: 0.0
      add :value_for_individual_state, :decimal, default: 0.0
      add :value_for_individual_tax_year, :decimal, default: 0.0
      add :value_for_sale_tax_count, :decimal, default: 0.0

      timestamps(type: :utc_datetime_usec)
    end
  end
end

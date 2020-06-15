defmodule Core.Services.MatchValueRelate do
  @moduledoc """
  Schema for MatchValueRelates.
  """

  use Core.Model

  @zero 0

  @type t :: %__MODULE__{
    match_for_book_keeping_additional_need: integer,
    match_for_book_keeping_annual_revenue: integer,
    match_for_book_keeping_industry: integer,
    match_for_book_keeping_number_employee: integer,
    match_for_book_keeping_payroll: integer,
    match_for_book_keeping_type_client: integer,
    match_for_business_enity_type: integer,
    match_for_business_industry: integer,
    match_for_business_number_of_employee: integer,
    match_for_business_total_revenue: integer,
    match_for_individual_employment_status: integer,
    match_for_individual_filing_status: integer,
    match_for_individual_foreign_account: integer,
    match_for_individual_home_owner: integer,
    match_for_individual_itemized_deduction: integer,
    match_for_individual_living_abroad: integer,
    match_for_individual_non_resident_earning: integer,
    match_for_individual_own_stock_crypto: integer,
    match_for_individual_rental_prop_income: integer,
    match_for_individual_stock_divident: integer,
    match_for_sale_tax_count: integer,
    match_for_sale_tax_frequency: integer,
    match_for_sale_tax_industry: integer,
    value_for_book_keeping_payroll: integer,
    value_for_book_keeping_tax_year: integer,
    value_for_business_accounting_software: integer,
    value_for_business_dispose_property: integer,
    value_for_business_foreign_shareholder: integer,
    value_for_business_income_over_thousand: integer,
    value_for_business_invest_research: integer,
    value_for_business_k1_count: integer,
    value_for_business_make_distribution: integer,
    value_for_business_state: integer,
    value_for_business_tax_exemption: integer,
    value_for_business_total_asset_over: integer,
    value_for_individual_employment_status: integer,
    value_for_individual_foreign_account_limit: integer,
    value_for_individual_foreign_financial_interest: integer,
    value_for_individual_home_owner: integer,
    value_for_individual_k1_count: integer,
    value_for_individual_rental_prop_income: integer,
    value_for_individual_sole_prop_count: integer,
    value_for_individual_state: integer,
    value_for_individual_tax_year: integer,
    value_for_sale_tax_count: integer
  }

  @allowed_params ~w(
    match_for_book_keeping_additional_need
    match_for_book_keeping_annual_revenue
    match_for_book_keeping_industry
    match_for_book_keeping_number_employee
    match_for_book_keeping_payroll
    match_for_book_keeping_type_client
    match_for_business_enity_type
    match_for_business_industry
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
  )a

  @required_params ~w(
    match_for_book_keeping_additional_need
    match_for_book_keeping_annual_revenue
    match_for_book_keeping_industry
    match_for_book_keeping_number_employee
    match_for_book_keeping_payroll
    match_for_book_keeping_type_client
    match_for_business_enity_type
    match_for_business_industry
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
  )a

  schema "match_value_relates" do
    field :match_for_book_keeping_additional_need, :integer
    field :match_for_book_keeping_annual_revenue, :integer
    field :match_for_book_keeping_industry, :integer
    field :match_for_book_keeping_number_employee, :integer
    field :match_for_book_keeping_payroll, :integer
    field :match_for_book_keeping_type_client, :integer
    field :match_for_business_enity_type, :integer
    field :match_for_business_industry, :integer
    field :match_for_business_number_of_employee, :integer
    field :match_for_business_total_revenue, :integer
    field :match_for_individual_employment_status, :integer
    field :match_for_individual_filing_status, :integer
    field :match_for_individual_foreign_account, :integer
    field :match_for_individual_home_owner, :integer
    field :match_for_individual_itemized_deduction, :integer
    field :match_for_individual_living_abroad, :integer
    field :match_for_individual_non_resident_earning, :integer
    field :match_for_individual_own_stock_crypto, :integer
    field :match_for_individual_rental_prop_income, :integer
    field :match_for_individual_stock_divident, :integer
    field :match_for_sale_tax_count, :integer
    field :match_for_sale_tax_frequency, :integer
    field :match_for_sale_tax_industry, :integer
    field :value_for_book_keeping_payroll, :decimal
    field :value_for_book_keeping_tax_year, :decimal
    field :value_for_business_accounting_software, :decimal
    field :value_for_business_dispose_property, :decimal
    field :value_for_business_foreign_shareholder, :decimal
    field :value_for_business_income_over_thousand, :decimal
    field :value_for_business_invest_research, :decimal
    field :value_for_business_k1_count, :decimal
    field :value_for_business_make_distribution, :decimal
    field :value_for_business_state, :decimal
    field :value_for_business_tax_exemption, :decimal
    field :value_for_business_total_asset_over, :decimal
    field :value_for_individual_employment_status, :decimal
    field :value_for_individual_foreign_account_limit, :decimal
    field :value_for_individual_foreign_financial_interest, :decimal
    field :value_for_individual_home_owner, :decimal
    field :value_for_individual_k1_count, :decimal
    field :value_for_individual_rental_prop_income, :decimal
    field :value_for_individual_sole_prop_count, :decimal
    field :value_for_individual_state, :decimal
    field :value_for_individual_tax_year, :decimal
    field :value_for_sale_tax_count, :decimal

    timestamps()
  end

  @doc """
  Create changeset for MatchValueRelate.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> validate_number(:match_for_book_keeping_additional_need, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_book_keeping_annual_revenue, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_book_keeping_industry, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_book_keeping_number_employee, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_book_keeping_payroll, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_book_keeping_type_client, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_business_enity_type, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_business_industry, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_business_number_of_employee, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_business_total_revenue, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_individual_employment_status, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_individual_filing_status, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_individual_foreign_account, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_individual_home_owner, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_individual_itemized_deduction, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_individual_living_abroad, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_individual_non_resident_earning, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_individual_own_stock_crypto, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_individual_rental_prop_income, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_individual_stock_divident, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_sale_tax_count, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_sale_tax_frequency, greater_than_or_equal_to: @zero)
    |> validate_number(:match_for_sale_tax_industry, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_book_keeping_payroll, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_book_keeping_tax_year, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_business_accounting_software, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_business_dispose_property, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_business_foreign_shareholder, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_business_income_over_thousand, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_business_invest_research, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_business_k1_count, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_business_make_distribution, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_business_state, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_business_tax_exemption, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_business_total_asset_over, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_individual_employment_status, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_individual_foreign_account_limit, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_individual_foreign_financial_interest, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_individual_home_owner, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_individual_k1_count, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_individual_rental_prop_income, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_individual_sole_prop_count, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_individual_state, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_individual_tax_year, greater_than_or_equal_to: @zero)
    |> validate_number(:value_for_sale_tax_count, greater_than_or_equal_to: @zero)
  end
end

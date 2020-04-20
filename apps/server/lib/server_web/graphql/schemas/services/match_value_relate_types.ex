defmodule ServerWeb.GraphQL.Schemas.Services.MatchValueRelateTypes do
  @moduledoc """
  The MatchValueRelate GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Services.MatchValueRelatesResolver

  @desc "The list match value relates"
  object :match_value_relate do
    field :id, non_null(:string)
    field :inserted_at, non_null(:datetime)
    field :match_for_book_keeping_additional_need, non_null(:integer)
    field :match_for_book_keeping_annual_revenue, non_null(:integer)
    field :match_for_book_keeping_industry, non_null(:integer)
    field :match_for_book_keeping_number_employee, non_null(:integer)
    field :match_for_book_keeping_payroll, non_null(:integer)
    field :match_for_book_keeping_type_client, non_null(:integer)
    field :match_for_business_enity_type, non_null(:integer)
    field :match_for_business_number_of_employee, non_null(:integer)
    field :match_for_business_total_revenue, non_null(:integer)
    field :match_for_individual_employment_status, non_null(:integer)
    field :match_for_individual_filing_status, non_null(:integer)
    field :match_for_individual_foreign_account, non_null(:integer)
    field :match_for_individual_home_owner, non_null(:integer)
    field :match_for_individual_itemized_deduction, non_null(:integer)
    field :match_for_individual_living_abroad, non_null(:integer)
    field :match_for_individual_non_resident_earning, non_null(:integer)
    field :match_for_individual_own_stock_crypto, non_null(:integer)
    field :match_for_individual_rental_prop_income, non_null(:integer)
    field :match_for_individual_stock_divident, non_null(:integer)
    field :match_for_sale_tax_count, non_null(:integer)
    field :match_for_sale_tax_frequency, non_null(:integer)
    field :match_for_sale_tax_industry, non_null(:integer)
    field :updated_at, non_null(:datetime)
    field :value_for_book_keeping_payroll, non_null(:decimal)
    field :value_for_book_keeping_tax_year, non_null(:decimal)
    field :value_for_business_accounting_software, non_null(:decimal)
    field :value_for_business_dispose_property, non_null(:decimal)
    field :value_for_business_foreign_shareholder, non_null(:decimal)
    field :value_for_business_income_over_thousand, non_null(:decimal)
    field :value_for_business_invest_research, non_null(:decimal)
    field :value_for_business_k1_count, non_null(:decimal)
    field :value_for_business_make_distribution, non_null(:decimal)
    field :value_for_business_state, non_null(:decimal)
    field :value_for_business_tax_exemption, non_null(:decimal)
    field :value_for_business_total_asset_over, non_null(:decimal)
    field :value_for_individual_employment_status, non_null(:decimal)
    field :value_for_individual_foreign_account_limit, non_null(:decimal)
    field :value_for_individual_foreign_financial_interest, non_null(:decimal)
    field :value_for_individual_home_owner, non_null(:decimal)
    field :value_for_individual_k1_count, non_null(:decimal)
    field :value_for_individual_rental_prop_income, non_null(:decimal)
    field :value_for_individual_sole_prop_count, non_null(:decimal)
    field :value_for_individual_state, non_null(:decimal)
    field :value_for_individual_tax_year, non_null(:decimal)
    field :value_for_sale_tax_count, non_null(:decimal)
  end

  @desc "The match value relate update via params"
  input_object :update_match_value_relate_params do
    field :match_for_book_keeping_additional_need, :integer
    field :match_for_book_keeping_annual_revenue, :integer
    field :match_for_book_keeping_industry, :integer
    field :match_for_book_keeping_number_employee, :integer
    field :match_for_book_keeping_payroll, :integer
    field :match_for_book_keeping_type_client, :integer
    field :match_for_business_enity_type, :integer
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
  end

  object :match_value_relate_queries do
    @desc "Get all match value relates"
    field(:all_match_value_relates,
      non_null(list_of(non_null(:match_value_relate)))) do
        resolve &MatchValueRelatesResolver.list/3
    end

    @desc "Get a specific match value relate"
    field(:show_match_value_relate, non_null(:match_value_relate)) do
      arg(:id, non_null(:string))

      resolve(&MatchValueRelatesResolver.show/3)
    end

    @desc "Find the match value relate by id"
    field :find_match_value_relate, :match_value_relate do
      arg(:id, non_null(:string))

      resolve &MatchValueRelatesResolver.find/3
    end
  end

  object :match_value_relate_mutations do
    @desc "Create the match value relate"
    field :create_match_value_relate, :match_value_relate do
      arg :match_for_book_keeping_additional_need, non_null(:integer)
      arg :match_for_book_keeping_annual_revenue, non_null(:integer)
      arg :match_for_book_keeping_industry, non_null(:integer)
      arg :match_for_book_keeping_number_employee, non_null(:integer)
      arg :match_for_book_keeping_payroll, non_null(:integer)
      arg :match_for_book_keeping_type_client, non_null(:integer)
      arg :match_for_business_enity_type, non_null(:integer)
      arg :match_for_business_number_of_employee, non_null(:integer)
      arg :match_for_business_total_revenue, non_null(:integer)
      arg :match_for_individual_employment_status, non_null(:integer)
      arg :match_for_individual_filing_status, non_null(:integer)
      arg :match_for_individual_foreign_account, non_null(:integer)
      arg :match_for_individual_home_owner, non_null(:integer)
      arg :match_for_individual_itemized_deduction, non_null(:integer)
      arg :match_for_individual_living_abroad, non_null(:integer)
      arg :match_for_individual_non_resident_earning, non_null(:integer)
      arg :match_for_individual_own_stock_crypto, non_null(:integer)
      arg :match_for_individual_rental_prop_income, non_null(:integer)
      arg :match_for_individual_stock_divident, non_null(:integer)
      arg :match_for_sale_tax_count, non_null(:integer)
      arg :match_for_sale_tax_frequency, non_null(:integer)
      arg :match_for_sale_tax_industry, non_null(:integer)
      arg :value_for_book_keeping_payroll, non_null(:decimal)
      arg :value_for_book_keeping_tax_year, non_null(:decimal)
      arg :value_for_business_accounting_software, non_null(:decimal)
      arg :value_for_business_dispose_property, non_null(:decimal)
      arg :value_for_business_foreign_shareholder, non_null(:decimal)
      arg :value_for_business_income_over_thousand, non_null(:decimal)
      arg :value_for_business_invest_research, non_null(:decimal)
      arg :value_for_business_k1_count, non_null(:decimal)
      arg :value_for_business_make_distribution, non_null(:decimal)
      arg :value_for_business_state, non_null(:decimal)
      arg :value_for_business_tax_exemption, non_null(:decimal)
      arg :value_for_business_total_asset_over, non_null(:decimal)
      arg :value_for_individual_employment_status, non_null(:decimal)
      arg :value_for_individual_foreign_account_limit, non_null(:decimal)
      arg :value_for_individual_foreign_financial_interest, non_null(:decimal)
      arg :value_for_individual_home_owner, non_null(:decimal)
      arg :value_for_individual_k1_count, non_null(:decimal)
      arg :value_for_individual_rental_prop_income, non_null(:decimal)
      arg :value_for_individual_sole_prop_count, non_null(:decimal)
      arg :value_for_individual_state, non_null(:decimal)
      arg :value_for_individual_tax_year, non_null(:decimal)
      arg :value_for_sale_tax_count, non_null(:decimal)

      resolve &MatchValueRelatesResolver.create/3
    end

    @desc "Update a specific the match value relate"
    field :update_match_value_relate, :match_value_relate do
      arg :id, non_null(:string)
      arg :match_value_relate, :update_match_value_relate_params

      resolve &MatchValueRelatesResolver.update/3
    end

    @desc "Delete a specific the match value relate"
    field :delete_match_value_relate, :match_value_relate do
      arg :id, non_null(:string)

      resolve &MatchValueRelatesResolver.delete/3
    end
  end

  object :match_value_relate_subscriptions do
    @desc "Create match value relate via channel"
    field :match_value_relate_created, :match_value_relate do
      config(fn _, _ ->
        {:ok, topic: "match_value_relates"}
      end)

      trigger(:create_match_value_relate,
        topic: fn _ ->
          "match_value_relates"
        end
      )
    end
  end
end

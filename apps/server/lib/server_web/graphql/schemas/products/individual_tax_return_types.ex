defmodule ServerWeb.GraphQL.Schemas.Products.IndividualTaxReturnTypes do
  @moduledoc """
  The IndividualTaxReturn GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.IndividualTaxReturnsResolver
  }

  @desc "The list individual tax returns"
  object :individual_tax_return do
    field :id, non_null(:string)
    field :deadline, :date
    field :financial_situation, :string
    field :foreign_account, :boolean
    field :foreign_account_limit, :boolean
    field :foreign_financial_interest, :boolean
    field :home_owner, :boolean
    field :individual_employment_statuses, list_of(:individual_employment_status), resolve: dataloader(Data)
    field :individual_filing_statuses, list_of(:individual_filing_status), resolve: dataloader(Data)
    field :individual_foreign_account_counts, list_of(:individual_foreign_account_count), resolve: dataloader(Data)
    field :individual_industries, list_of(:individual_industry), resolve: dataloader(Data)
    field :individual_itemized_deductions, list_of(:individual_itemized_deduction), resolve: dataloader(Data)
    field :individual_stock_transaction_counts, list_of(:individual_stock_transaction_count), resolve: dataloader(Data)
    field :k1_count, :integer
    field :k1_income, :boolean
    field :living_abroad, :boolean
    field :non_resident_earning, :boolean
    field :none_expat, :boolean
    field :own_stock_crypto, :boolean
    field :price_foreign_account, :integer
    field :price_home_owner, :integer
    field :price_living_abroad, :integer
    field :price_non_resident_earning, :integer
    field :price_own_stock_crypto, :integer
    field :price_rental_property_income, :integer
    field :price_sole_proprietorship_count, :integer
    field :price_state, :integer
    field :price_stock_divident, :integer
    field :price_tax_year, :integer
    field :rental_property_count, :integer
    field :rental_property_income, :boolean
    field :sole_proprietorship_count, :integer
    field :state, list_of(:string)
    field :stock_divident, :boolean
    field :tax_year, list_of(:string)
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The list individual tax returns via role's Tp"
  object :tp_individual_tax_return do
    field :id, non_null(:string)
    field :deadline, :date
    field :financial_situation, :string
    field :foreign_account, :boolean
    field :foreign_account_limit, :boolean
    field :foreign_financial_interest, :boolean
    field :home_owner, :boolean
    field :individual_employment_statuses, list_of(:individual_employment_status), resolve: dataloader(Data)
    field :individual_filing_statuses, list_of(:individual_filing_status), resolve: dataloader(Data)
    field :individual_foreign_account_counts, list_of(:individual_foreign_account_count), resolve: dataloader(Data)
    field :individual_industries, list_of(:individual_industry), resolve: dataloader(Data)
    field :individual_itemized_deductions, list_of(:individual_itemized_deduction), resolve: dataloader(Data)
    field :individual_stock_transaction_counts, list_of(:individual_stock_transaction_count), resolve: dataloader(Data)
    field :k1_count, :integer
    field :k1_income, :boolean
    field :living_abroad, :boolean
    field :non_resident_earning, :boolean
    field :none_expat, :boolean
    field :own_stock_crypto, :boolean
    field :rental_property_count, :integer
    field :rental_property_income, :boolean
    field :sole_proprietorship_count, :integer
    field :state, list_of(:string)
    field :stock_divident, :boolean
    field :tax_year, list_of(:string)
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The list individual tax returns via role's Pro"
  object :pro_individual_tax_return do
    field :id, non_null(:string)
    field :foreign_account, :boolean
    field :home_owner, :boolean
    field :individual_employment_statuses, list_of(:individual_employment_status), resolve: dataloader(Data)
    field :individual_filing_statuses, list_of(:individual_filing_status), resolve: dataloader(Data)
    field :individual_industries, list_of(:individual_industry), resolve: dataloader(Data)
    field :individual_itemized_deductions, list_of(:individual_itemized_deduction), resolve: dataloader(Data)
    field :living_abroad, :boolean
    field :non_resident_earning, :boolean
    field :none_expat, :boolean
    field :own_stock_crypto, :boolean
    field :price_foreign_account, :integer
    field :price_home_owner, :integer
    field :price_living_abroad, :integer
    field :price_non_resident_earning, :integer
    field :price_own_stock_crypto, :integer
    field :price_rental_property_income, :integer
    field :price_sole_proprietorship_count, :integer
    field :price_state, :integer
    field :price_stock_divident, :integer
    field :price_tax_year, :integer
    field :rental_property_income, :boolean
    field :stock_divident, :boolean
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The individual tax return update via params"
  input_object :update_individual_tax_return_params do
    field :deadline, :date
    field :financial_situation, :string
    field :foreign_account, :boolean
    field :foreign_account_limit, :boolean
    field :foreign_financial_interest, :boolean
    field :home_owner, :boolean
    field :k1_count, :integer
    field :k1_income, :boolean
    field :living_abroad, :boolean
    field :non_resident_earning, :boolean
    field :none_expat, :boolean
    field :own_stock_crypto, :boolean
    field :price_foreign_account, :integer
    field :price_home_owner, :integer
    field :price_living_abroad, :integer
    field :price_non_resident_earning, :integer
    field :price_own_stock_crypto, :integer
    field :price_rental_property_income, :integer
    field :price_sole_proprietorship_count, :integer
    field :price_state, :integer
    field :price_stock_divident, :integer
    field :price_tax_year, :integer
    field :rental_property_count, :integer
    field :rental_property_income, :boolean
    field :sole_proprietorship_count, :integer
    field :state, list_of(:string)
    field :stock_divident, :boolean
    field :tax_year, list_of(:string)
    field :user_id, non_null(:string)
  end

  @desc "The individual tax return via role's Tp update with params"
  input_object :update_tp_individual_tax_return_params do
    field :deadline, :date
    field :financial_situation, :string
    field :foreign_account, :boolean
    field :foreign_account_limit, :boolean
    field :foreign_financial_interest, :boolean
    field :home_owner, :boolean
    field :k1_count, :integer
    field :k1_income, :boolean
    field :living_abroad, :boolean
    field :non_resident_earning, :boolean
    field :none_expat, :boolean
    field :own_stock_crypto, :boolean
    field :rental_property_count, :integer
    field :rental_property_income, :boolean
    field :sole_proprietorship_count, :integer
    field :state, list_of(:string)
    field :stock_divident, :boolean
    field :tax_year, list_of(:string)
    field :user_id, non_null(:string)
  end

  @desc "The individual tax return via role's Pro update with params"
  input_object :update_pro_individual_tax_return_params do
    field :foreign_account, :boolean
    field :home_owner, :boolean
    field :living_abroad, :boolean
    field :non_resident_earning, :boolean
    field :none_expat, :boolean
    field :own_stock_crypto, :boolean
    field :price_foreign_account, :integer
    field :price_home_owner, :integer
    field :price_living_abroad, :integer
    field :price_non_resident_earning, :integer
    field :price_own_stock_crypto, :integer
    field :price_rental_property_income, :integer
    field :price_sole_proprietorship_count, :integer
    field :price_state, :integer
    field :price_stock_divident, :integer
    field :price_tax_year, :integer
    field :rental_property_income, :boolean
    field :stock_divident, :boolean
    field :user_id, non_null(:string)
  end

  object :individual_tax_return_queries do
    @desc "Get all individual tax returns"
    field(:all_individual_tax_returns,
      non_null(list_of(non_null(:individual_tax_return)))) do
        resolve &IndividualTaxReturnsResolver.list/3
    end

    @desc "Get all individual tax returns via role's Tp"
    field(:all_tp_individual_tax_returns,
      non_null(list_of(non_null(:tp_individual_tax_return)))) do
        resolve &IndividualTaxReturnsResolver.list/3
    end

    @desc "Get all individual tax returns via role's Pro"
    field(:all_pro_individual_tax_returns,
      non_null(list_of(non_null(:pro_individual_tax_return)))) do
        resolve &IndividualTaxReturnsResolver.list/3
    end

    @desc "Get a specific individual tax return"
    field(:show_individual_tax_return, non_null(:individual_tax_return)) do
      arg(:id, non_null(:string))
      resolve(&IndividualTaxReturnsResolver.show/3)
    end

    @desc "Get a specific individual tax return via role's Tp"
    field(:show_tp_individual_tax_return, non_null(:tp_individual_tax_return)) do
      arg(:id, non_null(:string))
      resolve(&IndividualTaxReturnsResolver.show/3)
    end

    @desc "Get a specific individual tax return via role's Pro"
    field(:show_pro_individual_tax_return, non_null(:pro_individual_tax_return)) do
      arg(:id, non_null(:string))
      resolve(&IndividualTaxReturnsResolver.show/3)
    end

    @desc "Find the individual tax return by id"
    field :find_individual_tax_return, :individual_tax_return do
      arg(:id, non_null(:string))
      resolve &IndividualTaxReturnsResolver.find/3
    end

    @desc "Find the individual tax return by id via role's Tp"
    field :tp, :tp_individual_tax_return do
      arg(:id, non_null(:string))
      resolve &IndividualTaxReturnsResolver.role_client/3
    end

    @desc "Find the individual tax return by id via role's Pro"
    field :pro, :pro_individual_tax_return do
      arg(:id, non_null(:string))
      resolve &IndividualTaxReturnsResolver.role_pro/3
    end
  end

  object :individual_tax_return_mutations do
    @desc "Create the individual tax return"
    field :create_individual_tax_return, :individual_tax_return do
      arg :deadline, :date
      arg :financial_situation, :string
      arg :foreign_account, :boolean
      arg :foreign_account_limit, :boolean
      arg :foreign_financial_interest, :boolean
      arg :home_owner, :boolean
      arg :k1_count, :integer
      arg :k1_income, :boolean
      arg :living_abroad, :boolean
      arg :non_resident_earning, :boolean
      arg :none_expat, :boolean
      arg :own_stock_crypto, :boolean
      arg :price_foreign_account, :integer
      arg :price_home_owner, :integer
      arg :price_living_abroad, :integer
      arg :price_non_resident_earning, :integer
      arg :price_own_stock_crypto, :integer
      arg :price_rental_property_income, :integer
      arg :price_sole_proprietorship_count, :integer
      arg :price_state, :integer
      arg :price_stock_divident, :integer
      arg :price_tax_year, :integer
      arg :rental_property_count, :integer
      arg :rental_property_income, :boolean
      arg :sole_proprietorship_count, :integer
      arg :state, list_of(:string)
      arg :stock_divident, :boolean
      arg :tax_year, list_of(:string)
      arg :user_id, non_null(:string)
      resolve &IndividualTaxReturnsResolver.create/3
    end

    @desc "Create the individual tax return via role's Tp"
    field :create_tp_individual_tax_return, :tp_individual_tax_return do
      arg :deadline, :date
      arg :financial_situation, :string
      arg :foreign_account, :boolean
      arg :foreign_account_limit, :boolean
      arg :foreign_financial_interest, :boolean
      arg :home_owner, :boolean
      arg :k1_count, :integer
      arg :k1_income, :boolean
      arg :living_abroad, :boolean
      arg :non_resident_earning, :boolean
      arg :none_expat, :boolean
      arg :own_stock_crypto, :boolean
      arg :rental_property_count, :integer
      arg :rental_property_income, :boolean
      arg :sole_proprietorship_count, :integer
      arg :state, list_of(:string)
      arg :stock_divident, :boolean
      arg :tax_year, list_of(:string)
      arg :user_id, non_null(:string)
      resolve &IndividualTaxReturnsResolver.create/3
    end

    @desc "Create the individual tax return via role's Pro"
    field :create_pro_individual_tax_return, :pro_individual_tax_return do
      arg :foreign_account, :boolean
      arg :home_owner, :boolean
      arg :living_abroad, :boolean
      arg :non_resident_earning, :boolean
      arg :none_expat, :boolean
      arg :own_stock_crypto, :boolean
      arg :price_foreign_account, :integer
      arg :price_home_owner, :integer
      arg :price_living_abroad, :integer
      arg :price_non_resident_earning, :integer
      arg :price_own_stock_crypto, :integer
      arg :price_rental_property_income, :integer
      arg :price_sole_proprietorship_count, :integer
      arg :price_state, :integer
      arg :price_stock_divident, :integer
      arg :price_tax_year, :integer
      arg :rental_property_income, :boolean
      arg :stock_divident, :boolean
      arg :user_id, non_null(:string)
      resolve &IndividualTaxReturnsResolver.create/3
    end

    @desc "Update a specific the individual tax return"
    field :update_individual_tax_return, :individual_tax_return do
      arg :id, non_null(:string)
      arg :individual_tax_return, :update_individual_tax_return_params
      resolve &IndividualTaxReturnsResolver.update/3
    end

    @desc "Update a specific the individual tax return via role's Tp"
    field :update_tp_individual_tax_return, :tp_individual_tax_return do
      arg :id, non_null(:string)
      arg :individual_tax_return, :update_tp_individual_tax_return_params
      resolve &IndividualTaxReturnsResolver.update/3
    end

    @desc "Update a specific the individual tax return via role's Pro"
    field :update_pro_individual_tax_return, :pro_individual_tax_return do
      arg :id, non_null(:string)
      arg :individual_tax_return, :update_pro_individual_tax_return_params
      resolve &IndividualTaxReturnsResolver.update/3
    end

    @desc "Delete a specific the individual tax return"
    field :delete_individual_tax_return, :individual_tax_return do
      arg :id, non_null(:string)
      resolve &IndividualTaxReturnsResolver.delete/3
    end
  end

  object :individual_tax_return_subscriptions do
    @desc "Create individual tax return via channel"
    field :individual_tax_return_created, :individual_tax_return do
      config(fn _, _ ->
        {:ok, topic: ":individual_tax_returns"}
      end)

      trigger(:create_individual_tax_return,
        topic: fn _ ->
          "individual_tax_returns"
        end
      )
    end
  end
end

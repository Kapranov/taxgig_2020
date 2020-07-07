defmodule ServerWeb.GraphQL.Schemas.Products.BusinessTaxReturnTypes do
  @moduledoc """
  The BusinessTaxReturn GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.BusinessTaxReturnsResolver
  }

  @desc "The list business tax returns"
  object :business_tax_return do
    field :id, non_null(:string)
    field :accounting_software, :boolean
    field :business_entity_types, list_of(:business_entity_type), resolve: dataloader(Data)
    field :business_foreign_account_counts, list_of(:business_foreign_account_count), resolve: dataloader(Data)
    field :business_foreign_ownership_counts, list_of(:business_foreign_ownership_count), resolve: dataloader(Data)
    field :business_llc_types, list_of(:business_llc_type), resolve: dataloader(Data)
    field :business_number_employees, list_of(:business_number_employee), resolve: dataloader(Data)
    field :business_total_revenues, list_of(:business_total_revenue), resolve: dataloader(Data)
    field :business_transaction_counts, list_of(:business_transaction_count), resolve: dataloader(Data)
    field :capital_asset_sale, :boolean
    field :church_hospital, :boolean
    field :deadline, :date
    field :dispose_asset, :boolean
    field :dispose_property, :boolean
    field :educational_facility, :boolean
    field :financial_situation, :string
    field :foreign_account_interest, :boolean
    field :foreign_account_value_more, :boolean
    field :foreign_entity_interest, :boolean
    field :foreign_partner_count, :integer
    field :foreign_shareholder, :boolean
    field :foreign_value, :boolean
    field :fundraising_over, :boolean
    field :has_contribution, :boolean
    field :has_loan, :boolean
    field :income_over_thousand, :boolean
    field :invest_research, :boolean
    field :k1_count, :integer
    field :lobbying, :boolean
    field :make_distribution, :boolean
    field :none_expat, :boolean
    field :operate_facility, :boolean
    field :price_state, :integer
    field :price_tax_year, :integer
    field :property_sale, :boolean
    field :public_charity, :boolean
    field :rental_property_count, :integer
    field :reported_grant, :boolean
    field :restricted_donation, :boolean
    field :state, list_of(:string)
    field :tax_exemption, :boolean
    field :tax_year, list_of(:string)
    field :total_asset_less, :boolean
    field :total_asset_over, :boolean
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The list individual tax returns via role's Tp"
  object :tp_business_tax_return do
    field :id, non_null(:string)
    field :accounting_software, :boolean
    field :business_entity_types, list_of(:business_entity_type), resolve: dataloader(Data)
    field :business_foreign_account_counts, list_of(:business_foreign_account_count), resolve: dataloader(Data)
    field :business_foreign_ownership_counts, list_of(:business_foreign_ownership_count), resolve: dataloader(Data)
    field :business_llc_types, list_of(:business_llc_type), resolve: dataloader(Data)
    field :business_number_employees, list_of(:business_number_employee), resolve: dataloader(Data)
    field :business_total_revenues, list_of(:business_total_revenue), resolve: dataloader(Data)
    field :business_transaction_counts, list_of(:business_transaction_count), resolve: dataloader(Data)
    field :capital_asset_sale, :boolean
    field :church_hospital, :boolean
    field :deadline, :date
    field :dispose_asset, :boolean
    field :dispose_property, :boolean
    field :educational_facility, :boolean
    field :financial_situation, :string
    field :foreign_account_interest, :boolean
    field :foreign_account_value_more, :boolean
    field :foreign_entity_interest, :boolean
    field :foreign_partner_count, :integer
    field :foreign_shareholder, :boolean
    field :foreign_value, :boolean
    field :fundraising_over, :boolean
    field :has_contribution, :boolean
    field :has_loan, :boolean
    field :income_over_thousand, :boolean
    field :invest_research, :boolean
    field :k1_count, :integer
    field :lobbying, :boolean
    field :make_distribution, :boolean
    field :none_expat, :boolean
    field :operate_facility, :boolean
    field :property_sale, :boolean
    field :public_charity, :boolean
    field :rental_property_count, :integer
    field :reported_grant, :boolean
    field :restricted_donation, :boolean
    field :state, list_of(:string)
    field :tax_exemption, :boolean
    field :tax_year, list_of(:string)
    field :total_asset_less, :boolean
    field :total_asset_over, :boolean
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The list individual tax returns via role's Pro"
  object :pro_business_tax_return do
    field :id, non_null(:string)
    field :business_entity_types, list_of(:business_entity_type), resolve: dataloader(Data)
    field :business_foreign_account_counts, list_of(:business_foreign_account_count), resolve: dataloader(Data)
    field :business_foreign_ownership_counts, list_of(:business_foreign_ownership_count), resolve: dataloader(Data)
    field :business_llc_types, list_of(:business_llc_type), resolve: dataloader(Data)
    field :business_number_employees, list_of(:business_number_employee), resolve: dataloader(Data)
    field :business_total_revenues, list_of(:business_total_revenue), resolve: dataloader(Data)
    field :business_transaction_counts, list_of(:business_transaction_count), resolve: dataloader(Data)
    field :none_expat, :boolean
    field :price_state, :integer
    field :price_tax_year, :integer
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The business tax return update via params"
  input_object :update_business_tax_return_params do
    field :accounting_software, :boolean
    field :capital_asset_sale, :boolean
    field :church_hospital, :boolean
    field :deadline, :date
    field :dispose_asset, :boolean
    field :dispose_property, :boolean
    field :educational_facility, :boolean
    field :financial_situation, :string
    field :foreign_account_interest, :boolean
    field :foreign_account_value_more, :boolean
    field :foreign_entity_interest, :boolean
    field :foreign_partner_count, :integer
    field :foreign_shareholder, :boolean
    field :foreign_value, :boolean
    field :fundraising_over, :boolean
    field :has_contribution, :boolean
    field :has_loan, :boolean
    field :income_over_thousand, :boolean
    field :invest_research, :boolean
    field :k1_count, :integer
    field :lobbying, :boolean
    field :make_distribution, :boolean
    field :none_expat, :boolean
    field :operate_facility, :boolean
    field :price_state, :integer
    field :price_tax_year, :integer
    field :property_sale, :boolean
    field :public_charity, :boolean
    field :rental_property_count, :integer
    field :reported_grant, :boolean
    field :restricted_donation, :boolean
    field :state, list_of(:string)
    field :tax_exemption, :boolean
    field :tax_year, list_of(:string)
    field :total_asset_less, :boolean
    field :total_asset_over, :boolean
    field :user_id, non_null(:string)
  end

  @desc "The business tax return via role's Tp update with params"
  input_object :update_tp_business_tax_return_params do
    field :id, non_null(:string)
    field :accounting_software, :boolean
    field :capital_asset_sale, :boolean
    field :church_hospital, :boolean
    field :deadline, :date
    field :dispose_asset, :boolean
    field :dispose_property, :boolean
    field :educational_facility, :boolean
    field :financial_situation, :string
    field :foreign_account_interest, :boolean
    field :foreign_account_value_more, :boolean
    field :foreign_entity_interest, :boolean
    field :foreign_partner_count, :integer
    field :foreign_shareholder, :boolean
    field :foreign_value, :boolean
    field :fundraising_over, :boolean
    field :has_contribution, :boolean
    field :has_loan, :boolean
    field :income_over_thousand, :boolean
    field :invest_research, :boolean
    field :k1_count, :integer
    field :lobbying, :boolean
    field :make_distribution, :boolean
    field :none_expat, :boolean
    field :operate_facility, :boolean
    field :property_sale, :boolean
    field :public_charity, :boolean
    field :rental_property_count, :integer
    field :reported_grant, :boolean
    field :restricted_donation, :boolean
    field :state, list_of(:string)
    field :tax_exemption, :boolean
    field :tax_year, list_of(:string)
    field :total_asset_less, :boolean
    field :total_asset_over, :boolean
    field :user_id, non_null(:string)
  end

  @desc "The business tax return via role's Pro update with params"
  input_object :update_pro_business_tax_return_params do
    field :none_expat, :boolean
    field :price_state, :integer
    field :price_tax_year, :integer
    field :user_id, non_null(:string)
  end

  object :business_tax_return_queries do
    @desc "Get all business tax returns"
    field(:all_business_tax_returns, non_null(list_of(non_null(:business_tax_return)))) do
      resolve &BusinessTaxReturnsResolver.list/3
    end

    @desc "Get all business tax returns via role's Tp"
    field(:all_tp_business_tax_returns, non_null(list_of(non_null(:tp_business_tax_return)))) do
        resolve &BusinessTaxReturnsResolver.list/3
    end

    @desc "Get all business tax returns via role's Pro"
    field(:all_pro_business_tax_returns, non_null(list_of(non_null(:pro_business_tax_return)))) do
        resolve &BusinessTaxReturnsResolver.list/3
    end

    @desc "Get a specific business tax return"
    field(:show_business_tax_return, non_null(:business_tax_return)) do
      arg(:id, non_null(:string))

      resolve(&BusinessTaxReturnsResolver.show/3)
    end

    @desc "Get a specific business tax return via role's Tp"
    field(:show_tp_business_tax_return, non_null(:tp_business_tax_return)) do
      arg(:id, non_null(:string))

      resolve(&BusinessTaxReturnsResolver.show/3)
    end

    @desc "Get a specific business tax return via role's Pro"
    field(:show_pro_business_tax_return, non_null(:pro_business_tax_return)) do
      arg(:id, non_null(:string))

      resolve(&BusinessTaxReturnsResolver.show/3)
    end

    @desc "Find the business tax return by id"
    field :find_business_tax_return, :business_tax_return do
      arg(:id, non_null(:string))

      resolve &BusinessTaxReturnsResolver.find/3
    end

    @desc "Find the business tax return by id via role's Tp"
    field :find_tp_business_tax_return, :tp_business_tax_return do
      arg(:id, non_null(:string))

      resolve &BusinessTaxReturnsResolver.role_client/3
    end

    @desc "Find the business tax return by id via role's Pro"
    field :find_pro_business_tax_return, :pro_business_tax_return do
      arg(:id, non_null(:string))

      resolve &BusinessTaxReturnsResolver.role_pro/3
    end
  end

  object :business_tax_return_mutations do
    @desc "Create the business tax return"
    field :create_business_tax_return, :business_tax_return do
      arg :accounting_software, :boolean
      arg :capital_asset_sale, :boolean
      arg :church_hospital, :boolean
      arg :deadline, :date
      arg :dispose_asset, :boolean
      arg :dispose_property, :boolean
      arg :educational_facility, :boolean
      arg :financial_situation, :string
      arg :foreign_account_interest, :boolean
      arg :foreign_account_value_more, :boolean
      arg :foreign_entity_interest, :boolean
      arg :foreign_partner_count, :integer
      arg :foreign_shareholder, :boolean
      arg :foreign_value, :boolean
      arg :fundraising_over, :boolean
      arg :has_contribution, :boolean
      arg :has_loan, :boolean
      arg :income_over_thousand, :boolean
      arg :invest_research, :boolean
      arg :k1_count, :integer
      arg :lobbying, :boolean
      arg :make_distribution, :boolean
      arg :none_expat, non_null(:boolean)
      arg :operate_facility, :boolean
      arg :price_state, :integer
      arg :price_tax_year, :integer
      arg :property_sale, :boolean
      arg :public_charity, :boolean
      arg :rental_property_count, :integer
      arg :reported_grant, :boolean
      arg :restricted_donation, :boolean
      arg :state, list_of(:string)
      arg :tax_exemption, :boolean
      arg :tax_year, list_of(:string)
      arg :total_asset_less, :boolean
      arg :total_asset_over, :boolean
      arg :user_id, non_null(:string)

      resolve &BusinessTaxReturnsResolver.create/3
    end

    @desc "Create the business tax return via role's Tp"
    field :create_tp_business_tax_return, :tp_business_tax_return do
      arg :accounting_software, :boolean
      arg :capital_asset_sale, :boolean
      arg :church_hospital, :boolean
      arg :deadline, :date
      arg :dispose_asset, :boolean
      arg :dispose_property, :boolean
      arg :educational_facility, :boolean
      arg :financial_situation, :string
      arg :foreign_account_interest, :boolean
      arg :foreign_account_value_more, :boolean
      arg :foreign_entity_interest, :boolean
      arg :foreign_partner_count, :integer
      arg :foreign_shareholder, :boolean
      arg :foreign_value, :boolean
      arg :fundraising_over, :boolean
      arg :has_contribution, :boolean
      arg :has_loan, :boolean
      arg :income_over_thousand, :boolean
      arg :invest_research, :boolean
      arg :k1_count, :integer
      arg :lobbying, :boolean
      arg :make_distribution, :boolean
      arg :none_expat, :boolean
      arg :operate_facility, :boolean
      arg :property_sale, :boolean
      arg :public_charity, :boolean
      arg :rental_property_count, :integer
      arg :reported_grant, :boolean
      arg :restricted_donation, :boolean
      arg :state, list_of(:string)
      arg :tax_exemption, :boolean
      arg :tax_year, list_of(:string)
      arg :total_asset_less, :boolean
      arg :total_asset_over, :boolean
      arg :user_id, non_null(:string)

      resolve &BusinessTaxReturnsResolver.create/3
    end

    @desc "Create the business tax return via role's Pro"
    field :create_pro_business_tax_return, :pro_business_tax_return do
      arg :none_expat, non_null(:boolean)
      arg :price_state, :integer
      arg :price_tax_year, :integer
      arg :user_id, non_null(:string)

      resolve &BusinessTaxReturnsResolver.create/3
    end

    @desc "Update a specific the business tax return"
    field :update_business_tax_return, :business_tax_return do
      arg :id, non_null(:string)
      arg :business_tax_return, :update_business_tax_return_params

      resolve &BusinessTaxReturnsResolver.update/3
    end

    @desc "Update a specific the business tax return via role's Tp"
    field :update_tp_business_tax_return, :tp_business_tax_return do
      arg :id, non_null(:string)
      arg :business_tax_return, :update_tp_business_tax_return_params

      resolve &BusinessTaxReturnsResolver.update/3
    end

    @desc "Update a specific the business tax return via role's Pro"
    field :update_pro_business_tax_return, :pro_business_tax_return do
      arg :id, non_null(:string)
      arg :business_tax_return, :update_pro_business_tax_return_params

      resolve &BusinessTaxReturnsResolver.update/3
    end

    @desc "Delete a specific the business tax return"
    field :delete_business_tax_return, :business_tax_return do
      arg :id, non_null(:string)

      resolve &BusinessTaxReturnsResolver.delete/3
    end
  end

  object :business_tax_return_subscriptions do
    @desc "Create business tax return via channel"
    field :business_tax_return_created, :business_tax_return do
      config(fn _, _ ->
        {:ok, topic: ":business_tax_returns"}
      end)

      trigger(:create_business_tax_return,
        topic: fn _ ->
          "business_tax_returns"
        end
      )
    end
  end
end

defmodule ServerWeb.GraphQL.Schemas.Services.PlaidTypes do
  @moduledoc """
  The Plaid GraphQL interface.
  """


  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Services.PlaidResolver
  }

  @desc "A plaid account on the site"
  object :plaid_account do
    field :id, non_null(:string)
    field :from_plaid_account_mask, :string
    field :from_plaid_account_name, :string
    field :from_plaid_account_official_name, :string
    field :from_plaid_account_subtype, :string
    field :from_plaid_account_type, :string
    field :from_plaid_balance_currency, :string
    field :from_plaid_balance_current, :decimal
    field :from_plaid_total_transaction, :integer
    field :id_from_plaid_account, :string
  end

  @desc "A plaid transaction on the site"
  object :plaid_transaction do
    field :id, non_null(:string)
    field :from_plaid_transaction_address, :string
    field :from_plaid_transaction_amount, :decimal
    field :from_plaid_transaction_authorization_date, :date
    field :from_plaid_transaction_category, list_of(:string)
    field :from_plaid_transaction_city, :string
    field :from_plaid_transaction_country, :string
    field :from_plaid_transaction_currency, :decimal
    field :from_plaid_transaction_merchant_name, :integer
    field :from_plaid_transaction_name, :string
    field :from_plaid_transaction_postal_code, :string
    field :from_plaid_transaction_region, :string
    field :id_from_plaid_transaction, :string
    field :id_from_plaid_transaction_category, :string
    field :plaid_accounts, list_of(:plaid_account), resolve: dataloader(Data)
  end

  object :plaid_queries do
    @desc "Get all plaid accounts"
    field :all_plaid_accounts, list_of(:plaid_account) do
      resolve(&PlaidResolver.list_account/3)
    end

    @desc "Get all plaid transactions"
    field :all_plaid_transactions, list_of(:plaid_transaction) do
      resolve(&PlaidResolver.list_transaction/3)
    end

    @desc "Get a specific plaid account"
    field :show_plaid_account, :plaid_account do
      arg(:id, non_null(:string))
      resolve(&PlaidResolver.show_account/3)
    end

    @desc "Get a specific plaid transaction"
    field :show_plaid_transaction, :plaid_transaction do
      arg(:id, non_null(:string))
      resolve(&PlaidResolver.show_transaction/3)
    end
  end

  object :plaid_mutations do
    @desc "Create the Plaid"
    field :create_plaid, :plaid_account do
      arg :start_date, :date
      arg :end_date, :date
      arg :count, :integer
      arg :offset, :integer
      arg :projects, list_of(:string)
      resolve &PlaidResolver.create/3
    end

    @desc "Delete a specific the plaid account"
    field :delete_plaid_account, :plaid_account do
      arg :id, non_null(:string)
      resolve &PlaidResolver.delete_account/3
    end

    @desc "Delete a specific the plaid transaction"
    field :delete_plaid_transaction, :plaid_transaction do
      arg :id, non_null(:string)
      resolve &PlaidResolver.delete_transaction/3
    end
  end
end

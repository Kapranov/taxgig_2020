defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformBankAccountTokenTypes do
  @moduledoc """
  The StripeBankAccountToken GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.StripeService.StripePlatformBankAccountTokenResolver
  }

  @desc "The StripeBankAccountToken"
  object :stripe_platform_bank_account_token do
    field :id, non_null(:string)
    field :id_from_stripe, non_null(:string)
    field :account_holder_name, non_null(:string)
    field :account_holder_type, non_null(:string)
    field :bank_name, non_null(:string)
    field :client_ip, non_null(:string)
    field :country, non_null(:string)
    field :created, non_null(:integer)
    field :currency, non_null(:string)
    field :fingerprint, non_null(:string)
    field :id_from_bank_account, non_null(:string)
    field :last4, non_null(:string)
    field :routing_number, non_null(:string)
    field :status, non_null(:string)
    field :used, non_null(:boolean)
    field :users, :user, resolve: dataloader(Data)
  end

  object :stripe_platform_bank_account_token_mutations do
    @desc "Create the StripePlatformBankAccountToken"
    field :create_stripe_platform_bank_account_token, :stripe_platform_bank_account_token_mutations, description: "Create a new stripe platform bank account token" do
      arg :account_holder_name, non_null(:string)
      arg :account_holder_type, non_null(:string)
      arg :account_number, non_null(:integer)
      arg :country, non_null(:string)
      arg :currency, non_null(:string)
      arg :routing_number, non_null(:integer)
      arg :user_id, non_null(:string)
      resolve &StripePlatformBankAccountTokenResolver.create/3
    end

    @desc "Delete a specific the StripePlatformBankAccountToken"
    field :delete_stripe_platform_charge, :stripe_platform_bank_account_token do
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformBankAccountTokenResolver.delete/3
    end
  end
end

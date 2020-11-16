defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformExternalAccountBankTypes do
  @moduledoc """
  The StripeExternalAccountBank GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.StripeService.StripePlatformExternalAccountBankResolver
  }

  @desc "The StripePlatformExternalAccountBank"
  object :stripe_platform_external_account_bank do
    field :id, non_null(:string)
    field :id_from_account, non_null(:string)
    field :id_from_stripe, non_null(:string)
    field :account_holder_name, non_null(:string)
    field :account_holder_type, non_null(:string)
    field :bank_name, non_null(:string)
    field :country, non_null(:string)
    field :currency, non_null(:string)
    field :fingerprint, non_null(:string)
    field :last4, non_null(:string)
    field :routing_number, non_null(:string)
    field :status, non_null(:string)
    field :users, :user, resolve: dataloader(Data)
  end

  object :stripe_platform_external_account_bank_queries do
    @desc "Get all StripePlatformExternalAccountBanks"
    field :all_stripe_platform_external_account_banks, list_of(:stripe_platform_external_account_bank) do
      resolve(&StripePlatformExternalAccountBankResolver.list/3)
    end
  end

  object :stripe_platform_external_account_bank_mutations do
    @desc "Create the StripePlatformExternalAccountBank"
    field :create_stripe_platform_external_account_bank, :stripe_platform_external_account_bank, description: "Create a new stripe platform external account bank" do
      arg :token, non_null(:string)
      arg :user_id, non_null(:string)
      resolve &StripePlatformExternalAccountBankResolver.create/3
    end

    @desc "Delete a specific the StripePlatformExternalAccountBank"
    field :delete_stripe_platform_external_account_bank, :stripe_platform_external_account_bank do
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformExternalAccountBankResolver.delete/3
    end
  end
end

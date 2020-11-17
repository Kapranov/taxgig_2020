defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformExternalAccountCardTypes do
  @moduledoc """
  The StripeExternalAccountCard GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformExternalAccountCardResolver

  @desc "The StripePlatformExternalAccountCard"
  object :stripe_platform_external_account_card do
    field :id, non_null(:string)
    field :id_from_account, non_null(:string)
    field :id_from_stripe, non_null(:string)
    field :brand, non_null(:string)
    field :country, non_null(:string)
    field :currency, non_null(:string)
    field :cvc_check, non_null(:string)
    field :default_for_currency, non_null(:boolean)
    field :exp_month, non_null(:integer)
    field :exp_year, non_null(:integer)
    field :fingerprint, non_null(:string)
    field :funding, non_null(:string)
    field :last4, non_null(:string)
    field :user_id, non_null(:string)
  end

  object :stripe_platform_external_account_card_queries do
    @desc "Get all StripePlatformExternalAccountCards"
    field :all_stripe_platform_external_account_cards, list_of(:stripe_platform_external_account_card) do
      resolve(&StripePlatformExternalAccountCardResolver.list/3)
    end
  end

  object :stripe_platform_external_account_card_mutations do
    @desc "Create the StripePlatformExternalAccountCard"
    field :create_stripe_platform_external_account_card, :stripe_platform_external_account_card, description: "Create a new stripe platform external account card" do
      arg :token, non_null(:string)
      resolve &StripePlatformExternalAccountCardResolver.create/3
    end

    @desc "Delete a specific the StripePlatformExternalAccountCard"
    field :delete_stripe_platform_external_account_card, :stripe_platform_external_account_card do
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformExternalAccountCardResolver.delete/3
    end
  end
end

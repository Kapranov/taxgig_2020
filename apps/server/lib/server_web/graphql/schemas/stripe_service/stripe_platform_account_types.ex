defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformAccountTypes do
  @moduledoc """
  The StripeAccount GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.StripeService.StripePlatformAccountResolver
  }

  @desc "The StripePlatformAccount"
  object :stripe_platform_account do
    field :id, non_null(:string)
    field :id_from_stripe, non_null(:string)
    field :business_url, non_null(:string)
    field :capabilities, list_of(:string)
    field :charges_enabled, non_null(:boolean)
    field :country, non_null(:string)
    field :created, non_null(:integer)
    field :default_currency, non_null(:string)
    field :details_submitted, non_null(:boolean)
    field :email, non_null(:string)
    field :payouts_enabled, non_null(:boolean)
    field :tos_acceptance, list_of(:string)
    field :type, non_null(:string)
    field :users, :user, resolve: dataloader(Data)
  end

  object :stripe_platform_account_mutations do
    @desc "Delete a specific the StripePlatformAccount"
    field :delete_stripe_platform_account, :stripe_platform_account do
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformAccountResolver.delete/3
    end
  end
end

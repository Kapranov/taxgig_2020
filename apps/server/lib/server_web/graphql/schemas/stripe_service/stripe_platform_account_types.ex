defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformAccountTypes do
  @moduledoc """
  The StripeAccount GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformAccountResolver

  @desc "The StripePlatformAccount"
  object :stripe_platform_account do
    field :id, :string
    field :business_url, :string
    field :capabilities, :capability
    field :charges_enabled, :boolean
    field :country, :string
    field :created, :integer
    field :default_currency, :string
    field :details_submitted, :boolean
    field :email, :string
    field :error, :string
    field :error_description, :string
    field :id_from_stripe, :string
    field :payouts_enabled, :boolean
    field :tos_acceptance, list_of(:string)
    field :type, :string
    field :user_id, :string
  end

  object :capability do
    field :card_payments, :string
    field :transfers, :string
  end

  @desc "The stripe account an update via params"
  input_object :update_stripe_account_params do
    field :email, :string
  end

  object :stripe_platform_account_mutations do
    @desc "Update a specific StripePlatformAccount"
    field :update_stripe_platform_account, :stripe_platform_account do
      arg :id_from_stripe, non_null(:string)
      arg :stripe_account, :update_stripe_account_params
      resolve &StripePlatformAccountResolver.update/3
    end

    @desc "Delete a specific the StripePlatformAccount"
    field :delete_stripe_platform_account, :stripe_platform_account do
      arg :id_from_stripe, non_null(:string)
      arg :user_id, non_null(:string)
      resolve &StripePlatformAccountResolver.delete/3
    end
  end
end

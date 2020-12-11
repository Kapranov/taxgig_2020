defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformAccountTokenTypes do
  @moduledoc """
  The StripeAccountToken GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformAccountTokenResolver

  @desc "The StripeAccountToken"
  object :stripe_platform_account_token do
    field :id, non_null(:string)
    field :id_from_stripe, non_null(:string)
    field :client_ip, non_null(:string)
    field :created, non_null(:integer)
    field :used, non_null(:boolean)
    field :user_id, non_null(:string)
  end

  object :stripe_platform_account_token_mutations do
    @desc "Create the StripePlatformAccountToken"
    field :create_stripe_platform_account_token, :stripe_platform_account_token, description: "Create a new stripe platform account token" do
      arg :business_type, non_null(:string)
      arg :city, non_null(:string)
      arg :country, non_null(:string)
      arg :day, non_null(:integer)
      arg :email, non_null(:string)
      arg :first_name, non_null(:string)
      arg :last_name, non_null(:string)
      arg :line1, non_null(:string)
      arg :maiden_name, :string
      arg :month, non_null(:integer)
      arg :phone, non_null(:string)
      arg :postal_code, non_null(:integer)
      arg :ssn_last4, non_null(:string)
      arg :state, non_null(:string)
      arg :tos_shown_and_accepted, (:boolean)
      arg :year, non_null(:integer)
      resolve &StripePlatformAccountTokenResolver.create/3
    end

    @desc "Delete a specific the StripePlatformAccountToken"
    field :delete_stripe_platform_charge, :stripe_platform_account_token do
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformAccountTokenResolver.delete/3
    end
  end
end

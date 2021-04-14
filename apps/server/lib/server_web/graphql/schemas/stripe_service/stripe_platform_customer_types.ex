defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformCustomerTypes do
  @moduledoc """
  The StripeCustomer GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformCustomerResolver

  @desc "The StripePlatformCustomer"
  object :stripe_platform_customer do
    field :id, non_null(:string)
    field :id_from_stripe, :string
    field :balance, :integer
    field :created, :integer
    field :currency, :string
    field :email, :string
    field :error, :string
    field :name, :string
    field :phone, :string
    field :user_id, :string
  end

  object :stripe_platform_customer_mutations do
    @desc "Delete a specific the StripePlatformCustomer"
    field :delete_stripe_platform_customer, :stripe_platform_customer do
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformCustomerResolver.delete/3
    end
  end
end

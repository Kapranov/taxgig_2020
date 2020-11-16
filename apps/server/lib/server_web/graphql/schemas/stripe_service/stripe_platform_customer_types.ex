defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformCustomerTypes do
  @moduledoc """
  The StripeCustomer GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.StripeService.StripePlatformCustomerResolver
  }

  @desc "The StripePlatformCustomer"
  object :stripe_platform_customer do
    field :id, non_null(:string)
    field :id_from_stripe, non_null(:string)
    field :balance, non_null(:integer)
    field :created, non_null(:integer)
    field :currency, non_null(:string)
    field :email, non_null(:string)
    field :name, non_null(:string)
    field :phone, non_null(:string)
    field :users, :user, resolve: dataloader(Data)
  end

  object :stripe_platform_customer_mutations do
    @desc "Delete a specific the StripePlatformCustomer"
    field :delete_stripe_platform_customer, :stripe_platform_customer do
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformCustomerResolver.delete/3
    end
  end
end

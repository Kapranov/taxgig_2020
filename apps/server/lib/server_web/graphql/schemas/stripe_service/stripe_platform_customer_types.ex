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

  @desc "The StripeCardCustomer"
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

  @desc "The StripeCardCustomer update via params"
  input_object :update_stripe_platform_customer_params, description: "update stripe platform customer" do
    field :email, :string, description: "email's an user"
    field :name, :string, description: "name's an user"
    field :phone, :string, description: "phone's an user"
  end

  object :stripe_platform_customer_mutations do
    @desc "Update a specific StripePlatformCustomer"
    field :update_stripe_platform_customer, :stripe_platform_customer do
      arg :id, non_null(:string)
      arg :stripe_platform_customer, :update_stripe_platform_customer_params
      resolve &StripePlatformCustomerResolver.update/3
    end

    @desc "Delete a specific the StripePlatformCustomer"
    field :delete_stripe_platform_customer, :stripe_platform_customer do
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformCustomerResolver.delete/3
    end
  end
end

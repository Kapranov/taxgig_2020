defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformCardTypes do
  @moduledoc """
  The StripeCardToken GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.StripeService.StripePlatformCardResolver
  }

  @desc "The StripeCardToken"
  object :stripe_platform_card do
    field :id, non_null(:string)
    field :brand, non_null(:string)
    field :client_ip, non_null(:string)
    field :created, non_null(:integer)
    field :cvc_check, non_null(:string)
    field :exp_month, non_null(:integer)
    field :exp_year, non_null(:integer)
    field :funding, non_null(:string)
    field :id_from_customer, non_null(:string)
    field :id_from_stripe, non_null(:string)
    field :last4, non_null(:string)
    field :name, non_null(:string)
    field :token, non_null(:string)
    field :used, non_null(:boolean)
    field :users, :user, resolve: dataloader(Data)
  end

  object :stripe_platform_card_queries do
    @desc "Get all StripePlatformCardTokens"
    field :all_stripe_platform_cards, list_of(:stripe_platform_card) do
      resolve(&StripePlatformCardResolver.list/3)
    end
  end

  object :stripe_platform_card_mutations do
    @desc "Create the StripePlatformCardToken"
    field :create_stripe_platform_card, :stripe_platform_card, description: "Create a new stripe platform card token" do
      arg :cvc, non_null(:integer)
      arg :exp_month, non_null(:integer)
      arg :exp_year, non_null(:integer)
      arg :name, non_null(:string)
      arg :number, non_null(:integer)
      resolve &StripePlatformCardResolver.create/3
    end

    @desc "Delete a specific the StripePlatformCardToken"
    field :delete_stripe_platform_card, :stripe_platform_card do
      arg :id_from_customer, non_null(:string)
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformCardResolver.delete/3
    end
  end
end

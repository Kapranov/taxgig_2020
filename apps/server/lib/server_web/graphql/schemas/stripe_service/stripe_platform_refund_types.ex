defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformRefundTypes do
  @moduledoc """
  The StripeRefund GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.StripeService.StripePlatformRefundResolver
  }

  @desc "The StripeRefund"
  object :stripe_platform_refund do
    field :id, non_null(:string)
    field :id_from_charge, non_null(:string)
    field :id_from_stripe, non_null(:string)
    field :amount, non_null(:integer)
    field :balance_transaction, non_null(:string)
    field :created, non_null(:integer)
    field :currency, non_null(:string)
    field :status, non_null(:string)
    field :users, :user, resolve: dataloader(Data)
  end

  object :stripe_platform_refund_mutations do
    @desc "Create the StripePlatformRefund"
    field :create_stripe_platform_refund, :stripe_platform_refund_mutations, description: "Create a new stripe platform refund" do
      arg :amount, non_null(:integer)
      arg :id_from_charge, non_null(:string)
      arg :user_id, non_null(:string)
      resolve &StripePlatformRefundResolver.create/3
    end

    @desc "Delete a specific the StripePlatformRefund"
    field :delete_stripe_platform_refund, :stripe_platform_refund do
      arg :id_from_charge, non_null(:string)
      resolve &StripePlatformRefundResolver.delete/3
    end
  end
end

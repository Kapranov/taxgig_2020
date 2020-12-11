defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformTransferReversalTypes do
  @moduledoc """
  The StripeTransferReversal GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformTransferReversalResolver

  @desc "The StripeTransferReversal"
  object :stripe_platform_transfer_reversal do
    field :id, non_null(:string)
    field :id_from_stripe, non_null(:string)
    field :id_from_transfer, non_null(:string)
    field :amount, non_null(:integer)
    field :balance_transaction, non_null(:string)
    field :created, non_null(:integer)
    field :currency, non_null(:string)
    field :destination_payment_refund, non_null(:string)
    field :user_id, non_null(:string)
  end

  object :stripe_platform_transfer_reversal_mutations do
    @desc "Create the StripePlatformTransferReversal"
    field :create_stripe_platform_transfer_reversal, :stripe_platform_transfer_reversal, description: "Create a new stripe platform transfer reversal" do
      arg :amount, non_null(:integer)
      arg :id_from_transfer, non_null(:string)
      resolve &StripePlatformTransferReversalResolver.create/3
    end

    @desc "Delete a specific the StripePlatformTransferReversal"
    field :delete_stripe_platform_transfer_reversal, :stripe_platform_transfer_reversal do
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformTransferReversalResolver.delete/3
    end
  end
end

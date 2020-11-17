defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformTransferTypes do
  @moduledoc """
  The StripeTransfer GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformTransferResolver

  @desc "The StripeTransfer"
  object :stripe_platform_transfer do
    field :id, non_null(:string)
    field :id_from_stripe, non_null(:string)
    field :amount, non_null(:integer)
    field :amount_reversed, non_null(:integer)
    field :balance_transaction, non_null(:string)
    field :created, non_null(:integer)
    field :currency, non_null(:string)
    field :destination, non_null(:string)
    field :destination_payment, non_null(:string)
    field :reversed, non_null(:boolean)
    field :source_type, non_null(:string)
    field :user_id, non_null(:string)
  end

  object :stripe_platform_transfer_mutations do
    @desc "Create the StripePlatformTransfer"
    field :create_stripe_platform_transfer, :stripe_platform_transfer_mutations, description: "Create a new stripe platform transfer" do
      arg :id_from_project, non_null(:string)
      arg :currency, non_null(:string)
      resolve &StripePlatformTransferResolver.create/3
    end

    @desc "Delete a specific the StripePlatformTransfer"
    field :delete_stripe_platform_transfer, :stripe_platform_transfer do
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformTransferResolver.delete/3
    end
  end
end

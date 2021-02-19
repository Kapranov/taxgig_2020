defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformPayoutTypes do
  @moduledoc """
  The StripePayout GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformPayoutResolver

  @desc "The StripePayout"
  object :stripe_platform_payout do
    field :id, non_null(:string)
    field :object, non_null(:string)
    field :amount, non_null(:integer)
    field :arrival_date, non_null(:integer)
    field :automatic, non_null(:boolean)
    field :balance_transaction, non_null(:string)
    field :created, non_null(:integer)
    field :currency, non_null(:string)
    field :description, :string
    field :destination, non_null(:string)
    field :failure_balance_transaction, :string
    field :failure_code, :string
    field :failure_message, :string
    field :livemode, non_null(:boolean)
    field :metadata, list_of(:string)
    field :method, non_null(:string)
    field :original_payout, :string
    field :reversed_by, :string
    field :source_type, non_null(:string)
    field :statement_descriptor, :string
    field :status, non_null(:string)
    field :type, non_null(:string)
  end

  object :stripe_platform_payout_mutations do
    @desc "Create the StripePlatformPayout"
    field :create_stripe_platform_payout, :stripe_platform_payout, description: "Create a new stripe platform payout" do
      arg :amount, non_null(:integer)
      arg :currency, non_null(:string)
      arg :destination, non_null(:string)
      arg :type, non_null(:string)
      resolve &StripePlatformPayoutResolver.create/3
    end
  end
end

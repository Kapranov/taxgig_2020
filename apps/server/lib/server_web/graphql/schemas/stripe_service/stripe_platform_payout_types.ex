defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformPayoutTypes do
  @moduledoc """
  The StripePayout GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformPayoutResolver

  @desc "The StripePayout"
  object :stripe_platform_payout do
    field :id, :string
    #field :metadata, list_of(:string)
    field :amount, :integer
    field :arrival_date, :integer
    field :automatic, :boolean
    field :balance_transaction, :string
    field :created, :integer
    field :currency, :string
    field :description, :string
    field :destination, :string
    field :failure_balance_transaction, :string
    field :failure_code, :string
    field :failure_message, :string
    field :livemode, :boolean
    field :method, :string
    field :object, :string
    field :original_payout, :string
    field :reversed_by, :string
    field :source_type, :string
    field :statement_descriptor, :string
    field :status, :string
    field :type, :string
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

  object :stripe_platform_payout_subscriptions do
    @desc "Create StripePayout via Channel"
    field :stripe_platform_payout_create, list_of(:stripe_platform_balance_transaction) do
      config(fn _, _ ->
        {:ok, topic: "stripe_platform_payouts"}
      end)

      trigger([
        :all_stripe_platform_balance_transaction,
        :create_stripe_platform_payout
      ], topic: fn _ -> "stripe_platform_balance_transactions" end)
    end
  end
end

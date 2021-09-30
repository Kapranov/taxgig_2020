defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformBalanceTransactionTypes do
  @moduledoc """
  The StripeBalanceTransaction GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformBalanceTransactionResolver

  @desc "The StripePlatformBalanceTransaction"
  object :stripe_platform_balance_transaction do
    field :amount, :integer
    field :available_on, :integer
    field :created, :integer
    field :currency, :string
    field :error, :string
    field :id, :string
    field :net, :integer
    field :reporting_category, :string
    field :status, :string
    field :type, :string
  end

  object :source_types_stripe_balance do
    field :card, :integer
  end

  object :available_stripe_balance do
    field :amount, :integer
    field :currency, :string
    field :source_types, :source_types_stripe_balance
  end

  object :stripe_platform_balance_retrieve do
    field :available, list_of(:available_stripe_balance)
    field :object, :string
    field :pending, list_of(:pending_stripe_balance)
  end

  object :pending_stripe_balance do
    field :amount, :integer
    field :currency, :string
    field :source_types, :source_types_stripe_balance
  end

  object :stripe_platform_balance_transaction_queries do
    @desc "Get all StripePlatformBalanceTransactions"
    field :all_stripe_platform_balance_transaction, list_of(:stripe_platform_balance_transaction) do
      resolve(&StripePlatformBalanceTransactionResolver.list/3)
    end

    @desc "Retrieve StripePlatformBalance by StripeAccount"
    field :retrieve_stripe_platform_balance, list_of(:stripe_platform_balance_retrieve) do
      resolve(&StripePlatformBalanceTransactionResolver.retrieve/3)
    end
  end

  object :stripe_platform_balance_transaction_subscriptions do
    @desc "All List StripeBalanceTransactions via Channel"
    field :stripe_platform_balance_transaction_all, list_of(:stripe_platform_balance_transaction) do
      config(fn _, _ ->
        {:ok, topic: "stripe_platform_balance_transactions"}
      end)

      trigger(:all_stripe_platform_balance_transaction, topic: fn _ -> "stripe_platform_balance_transactions" end)
    end
  end
end

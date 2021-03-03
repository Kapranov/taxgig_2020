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

  object :stripe_platform_balance_transaction_queries do
    @desc "Get all StripePlatformBalanceTransactions"
    field :all_stripe_platform_balance_transaction, list_of(:stripe_platform_balance_transaction) do
      resolve(&StripePlatformBalanceTransactionResolver.list/3)
    end
  end

  object :stripe_platform_balance_transaction_subscriptions do
    @desc "All List StripeBalanceTransactions via Channel"
    field :stripe_platform_balance_transaction_all, :stripe_platform_balance_transaction do
      config(fn _, _ ->
        {:ok, topic: "stripe_platform_balance_transactions"}
      end)

      trigger(:all_stripe_platform_balance_transaction,
        topic: fn _ ->
          "stripe_platform_balance_transactions"
        end
      )
    end
  end
end

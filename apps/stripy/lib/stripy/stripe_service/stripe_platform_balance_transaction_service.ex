defmodule Stripy.StripeService.StripePlatformBalanceTransactionService do
  @moduledoc """
  Balance transactions represent funds moving through your
  Stripe account. They're created for every type of transaction
  that comes into or flows out of your Stripe account balance.

  Returns a list of transactions that have contributed to the
  Stripe account balance (e.g., charges, transfers, and so forth).
  The transactions are returned in sorted order, with the most recent
  transactions appearing first.

  You can:

  - List all balance transactions with a specified account `id`

  Stripe API reference: https://stripe.com/docs/api/balance_transactions/list
  """

  @doc """
  List all balance transactions

  ## Example

      iex> account = "acct_1HmmYOQ1ofBpQHz3"
      iex> {:ok, data} = list(account)

  """
  @spec list(String.t) ::
          {:ok, Stripe.List.t} |
          {:ok, []} |
          {:error, Stripe.Error.t}
  def list(account) do
    with {:ok, %Stripe.List{data: data}} <- Stripe.BalanceTransaction.all(%{}, [], %{"Stripe-Account": account}) do
      {:ok, data}
    else
      failure -> failure
    end
  end

  @doc """
  Retrieves/shows available balance from selected account.
  If not account id identified, then shows TaxGig's overall balance from Stripe

  ## Example

      iex> opts = []
      iex> account = "acct_1HmmYOQ1ofBpQHz3"
      iex> {:ok, data} = retrieve(opts, %{"Stripe-Account": account})

  """
  @spec retrieve(list, %{"Stripe-Account": String.t()}) ::
          {:ok, Stripe.Balance.t} |
          {:error, Stripe.Error.t}
  def retrieve(opts \\ [], headers \\ %{}) do
    with {:ok, %Stripe.Balance{} = data} <- Stripe.Balance.retrieve(opts, headers) do
      {:ok, data}
    else
      failure -> failure
    end
  end
end

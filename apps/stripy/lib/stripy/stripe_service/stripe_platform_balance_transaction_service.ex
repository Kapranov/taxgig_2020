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
          {:error, Ecto.Changeset.t} |
          {:error, Stripe.Error.t} |
          {:error, :platform_not_ready} |
          {:error, :not_found}
  def list(account) do
    with {:ok, %Stripe.List{data: data}} <- Stripe.BalanceTransaction.all(%{}, [], %{"Stripe-Account": account}) do
      {:ok, data}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end
end

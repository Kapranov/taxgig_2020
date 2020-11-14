defmodule Stripy.StripeService.StripePlatformPayoutService do
  @moduledoc """
  A Payout object is created when you receive funds from Stripe, or when you initiate
  a payout to either a bank account or debit card of a connected Stripe account.
  You can retrieve individual payouts, as well as list all payouts. Payouts are made
  on varying schedules, depending on your country and industry.

  You can:

  - Create a payout

  Stripe API reference: https://stripe.com/docs/api/payouts
  """

  @doc """
  Used to create a remote `Stripe.Payout` record as well as
  an associated only local show  without record.

  A Payout object is created when you receive funds from Stripe, or when you
  initiate a payout to either a bank account or debit card of a connected Stripe
  account. You can retrieve individual payouts, as well as list all payouts.

  frontend - [:amount, :currency, destination]
  backend  - [:account]

  ## Example

    iex> account = "acct_1Hn6RgPwerpw7uUl"
    iex> account_bank = "ba_1Hn6VNPwerpw7uUllbb32208"
    iex> account_card = "card_1Hn6VHPwerpw7uUlhUkRCrlV"
    iex> attrs_bank = %{amount: 2000, destination: account_bank, currency: "usd"}
    iex> attrs_card = %{amount: 2000, destination: account_card, currency: "usd"}
    iex> {:ok, payout_bank} = create(attrs_bank, account)
    iex> {:ok, payout_card} = create(attrs_card, account)

  """
  @spec create_bank(map, String.t()) ::
          {:ok, Stripe.Payout.t}
          | {:error, Ecto.Changeset.t}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create_bank(attrs, account) do
    with {:ok,  %Stripe.Payout{} = data} <- Stripe.Payout.create(attrs, [], %{"Stripe-Account": account}) do
      {:ok, data}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end

  @spec create_card(map, String.t()) ::
          {:ok, Stripe.Payout.t}
          | {:error, Ecto.Changeset.t}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create_card(attrs, account) do
    with {:ok,  %Stripe.Payout{} = data} <- Stripe.Payout.create(attrs, [], %{"Stripe-Account": account}) do
      {:ok, data}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end
end

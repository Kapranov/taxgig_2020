defmodule Stripy.StripeService.StripePlatformRefundService do
  @moduledoc """
  Work with [Stripe `refund` objects](https://stripe.com/docs/api/refunds/object).
  Used to perform actions on StripeRefund records.

  You can:
  - [Create a refund](https://stripe.com/docs/api/refunds/create)
  """

  alias Stripy.{
    Payments,
    Payments.StripeRefund,
    Repo,
    StripeService.Adapters.StripePlatformRefundAdapter
  }

  @doc """
  Creates a new `Stripe.Refund` record on Stripe API, as well as an associated local
  `StripeRefund` record

  When you create a new refund, you must specify a charge to create it on.
  Creating a new refund will refund a charge that has previously been created
  but not yet refunded. Funds will be refunded to the credit or debit card
  that was originally charged.

  You can optionally refund only part of a charge. You can do so as many times
  as you wish until the entire charge has been refunded.

  Once entirely refunded, a charge can't be refunded again. This method will
  return an error when called on an already-refunded charge, or when trying to
  refund more money than is left on a charge.

  See the [Stripe docs](https://stripe.com/docs/api/refunds/create).

  Refund objects allow you to refund a charge that has previously been created but
  not yet refunded. Funds will be refunded to the credit or debit card that was
  originally charged.

  frontend - [:amount]
  backend = [:id_from_stripe]

  1. If created a new `StripeRefund` field's captured must be true by `StripeCharge`,
     field's amount must be equels or less by `StripeCharge.amount >= attrs["amount"]
     Check all records by userId and `id_from_charge` in `StripeRefund` take there
     are amounts summarized result must be less by `StripeCharge.amount`.
     You can optionally refund only part of a charge. You can do so multiple times,
     until the entire charge has been refunded.
  2. If created a new `StripeRefund` in `StripeCharge` field's captured is false return error

  ## Example

      iex> id_from_stripe = "ch_1HP2hvJ2Ju0cX1cPUxoku93W"
      iex> attrs = %{amount: 2000, charge: id_from_stripe}
      iex> user_id = FlakeId.get()
      iex> user_attrs = %{"user_id" => user_id}
      iex> {:ok, refuned} = create(attrs, user_attrs)

  """
  @spec create(map, map) ::
          {:ok, StripeRefund.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(attrs, user_attrs) do
    with {:ok, %Stripe.Refund{} = refund} = Stripe.Refund.create(attrs),
         {:ok, params} <- StripePlatformRefundAdapter.to_params(refund, user_attrs)
    do
      case Payments.create_stripe_refund(params) do
        {:error, error} -> {:error, error}
        {:ok, data} -> {:ok, data}
      end
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end

  @doc """
  Delete Refund

  ## Example

      iex> id = "ch_1HmHM4LhtqtNnMeb4r1LgOYL"
      iex> {:ok, deleted} = delete(id)

  """
  @spec delete(String.t) ::
          {:ok, StripeRefund.t} |
          {:error, Ecto.Changeset.t} |
          {:error, Stripe.Error.t} |
          {:error, :platform_not_ready} |
          {:error, :not_found}
  def delete(id) do
    with struct <- Repo.get_by(StripeRefund, %{id_from_charge: id}),
         {:ok, deleted} <- Payments.delete_stripe_refund(struct)
    do
      {:ok, deleted}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end
end

defmodule Stripy.StripeService.StripePlatformRefundService do
  @moduledoc """
  Work with [Stripe `refund` objects](https://stripe.com/docs/api/refunds/object).
  Used to perform actions on StripeRefund records.

  You can:
  - [Create a refund](https://stripe.com/docs/api/refunds/create)
  - [Retrieve a refund](https://stripe.com/docs/api/refunds/retrieve)
  - [Update a refund](https://stripe.com/docs/api/update)
  - [List all refunds](https://stripe.com/docs/api/refunds/list)
  """

  alias Stripy.{
    Payments,
    Payments.StripeRefund,
    StripeService.Adapters.StripePlatformRefundAdapter
  }

  @api Application.get_env(:stripy, :stripe)

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

  ## Example

      iex> user_id = FlakeId.get()
      iex> id_from_charge = "ch_1HP2hvJ2Ju0cX1cPUxoku93W"
      iex> user_attrs = %{"user_id" => user_id}
      iex> attrs = %{amount: 2000, charge: id_from_charge}
      iex> {:ok, refund} = Stripe.Refund.create(attrs)
      iex> {:ok, result} = StripePlatformRefundAdapter.to_params(refund, user_attrs)

  """
  @spec create(map, map) ::
          {:ok, StripeRefund.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(attrs, user_attrs) do
    with {:ok, %Stripe.Refund{} = refund} = @api.Refund.create(attrs),
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
end

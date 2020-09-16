defmodule Stripy.StripeService.StripePlatformRefundService do
  @moduledoc """
  Used to perform actions on StripeRefund records
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

  ## Example

      iex> user_id = "9yk8z0djhUG2r9LMK8"
      iex> id_from_charge = "ch_1HP2hvJ2Ju0cX1cPUxoku93W"
      iex> attrs = %{"user_id" => user_id}
      iex> refund_attrs = %{amount: 2000, charge: id_from_charge}
      iex> {:ok, stripe_refund} = Stripe.Refund.create(refund_attrs)
      iex> {:ok, result} = StripePlatformRefundAdapter.to_params(stripe_refund, attrs)

  """
  @spec create(map, map) ::
          {:ok, StripeRefund.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(refund_attrs, attrs) do
    with {:ok, %Stripe.Refund{} = refund} = @api.Refund.create(refund_attrs),
         {:ok, params} <- StripePlatformRefundAdapter.to_params(refund, attrs) do
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

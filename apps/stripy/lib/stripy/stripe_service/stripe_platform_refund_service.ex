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

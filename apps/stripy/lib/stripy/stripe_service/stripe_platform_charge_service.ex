defmodule Stripy.StripeService.StripePlatformChargeService do
  @moduledoc """
  Used to perform actions on StripeCharge records
  """

  alias Stripy.{
    Payments,
    Payments.StripeCharge,
    StripeService.Adapters.StripePlatformChargeAdapter
  }

  @api Application.get_env(:stripy, :stripe)

  @doc """
  Creates a new `Stripe.Charge` record on Stripe API, as well as an associated local
  `StripeCharge` record

  ## Example

      iex> user_id = "9yk8z0djhUG2r9LMK8"
      iex> id_from_card = "card_1HP2frJ2Ju0cX1cPJqmUkzO3"
      iex> id_from_customer = "cus_Hz0iaxWhaRWm6b"
      iex> attrs = %{"user_id" => user_id, "id_from_card" => id_from_card}
      iex> charge_attrs = %{amount: 2000, currency: "usd", customer: id_from_customer, source: id_from_card, description: "Test description", capture: false}
      iex> {:ok, stripe_charge} = Stripe.Charge.create(charge_attrs)
      iex> {:ok, result} = StripePlatformChargeAdapter.to_params(stripe_charge, attrs)

  """
  @spec create(map, map) ::
          {:ok, StripeCharge.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(charge_attrs, attrs) do
    with {:ok, %Stripe.Charge{} = charge} = @api.Charge.create(charge_attrs),
         {:ok, params} <- StripePlatformChargeAdapter.to_params(charge, attrs) do
      case Payments.create_stripe_charge(params) do
        {:error, error} -> {:error, error}
        {:ok, data} -> {:ok, data}
      end
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end
end

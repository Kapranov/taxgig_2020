defmodule Stripy.StripeService.StripePlatformChargeCaptureService do
  @moduledoc """
  Capture a charge.

  Capture the payment of an existing, uncaptured, charge. This is the second
  half of the two-step payment flow, where first you created a charge with the
  capture option set to false.

  Uncaptured payments expire exactly seven days after they are created. If they
  are not captured by that point in time, they will be marked as refunded and
  will no longer be capturable.

  Used to perform actions on StripeChargeCapture records

  See the [Stripe docs](https://stripe.com/docs/api/charges/capture).
  """

  alias Stripy.{
    Payments,
    Payments.StripeCharge,
    Payments.StripeChargeCapture,
    Repo,
    StripeService.Adapters.StripePlatformChargeCaptureAdapter
  }

  @doc """
  Creates a new `Stripe.ChargeCapture` record on Stripe API, as well as an associated local
  `StripeChargeCapture` record

  ## Example

      iex> id = "ch_1HP2hvJ2Ju0cX1cPUxoku93W"
      iex> attrs = %{amount: 2000}
      iex> {:ok, captured} = create(id, attrs)

  """
  @spec create(String.t, %{amount: integer}) ::
          {:ok, StripeChargeCapture.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(id, attrs) do
    with {:ok, %Stripe.Charge{} = captured} = Stripe.Charge.capture(id, attrs),
         {:ok, params} <- StripePlatformChargeCaptureAdapter.to_params(captured),
         struct <- Repo.get_by(StripeCharge, %{id_from_stripe: id})
    do
      case Payments.update_stripe_charge(struct, params) do
        {:ok, data} -> {:ok, data}
        {:error, error} -> {:error, error}
      end
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end
end

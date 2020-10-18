defmodule Stripy.StripeService.StripePlatformChargeCaptureService do
  @moduledoc """
  Used to perform actions on StripeChargeCapture records
  """

  alias Stripy.{
    Payments,
    Payments.StripeChargeCapture,
    StripeService.Adapters.StripePlatformChargeCaptureAdapter
  }

  @api Application.get_env(:stripy, :stripe)

  @doc """
  Creates a new `Stripe.ChargeCapture` record on Stripe API, as well as an associated local
  `StripeChargeCapture` record

  ## Example

        iex> user_id = FlakeId.get()
        iex> id_from_charge = "ch_1HP2hvJ2Ju0cX1cPUxoku93W"
        iex> charge_capture_attrs = %{amount: 2000}
        iex> {:ok, stripe_charge_capture} = Stripe.Charge.create(id_from_charge, charge_capture_attrs)
        iex> {:ok, result} = StripePlatformCardTokenAdapter.to_params(stripe_charge_capture)

  """
  @spec create(map, map) ::
          {:ok, StripeChargeCapture.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(id_from_charge, charge_capture_attrs) do
    with {:ok, %Stripe.Charge{} = stripe_charge_capture} = @api.Charge.capture(id_from_charge, charge_capture_attrs),
      {:ok, params} <- StripePlatformChargeCaptureAdapter.to_params(stripe_charge_capture)
    do
      struct = Payments.get_stripe_charge!(id_from_charge)
      case Payments.update_stripe_charge(struct, params) do
        {:error, error} -> {:error, error}
        {:ok, data} -> {:ok, data}
      end
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end
end

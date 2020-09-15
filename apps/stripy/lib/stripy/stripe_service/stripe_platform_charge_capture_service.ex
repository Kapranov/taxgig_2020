defmodule Stripy.StripeService.StripePlatformChargeCaptureService do
  @moduledoc """
  Used to perform actions on StripeChargeCapture records
  """

  alias Stripy.{
    Payments.StripeChargeCapture,
    Repo,
    StripeService.Adapters.StripePlatformChargeCaptureAdapter
  }

  @api Application.get_env(:stripy, :stripe)

  @doc """
  Creates a new `Stripe.ChargeCapture` record on Stripe API, as well as an associated local
  `StripeChargeCapture` record

  ## Example

    iex> user_id = "9yk8z0djhUG2r9LMK8"
    iex> charge_id_from_stripe = "ch_1HP2hvJ2Ju0cX1cPUxoku93W"
    iex> charge_capture_attrs = %{amount: 2000}
    iex> {:ok, stripe_charge_capture} = Stripe.Charge.create(charge_id_from_stripe, charge_capture_attrs)
    iex> {:ok, result} = StripePlatformCardTokenAdapter.to_params(stripe_charge_capture)
  """
  @spec create(map, map) ::
          {:ok, StripeChargeCapture.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(charge_id_from_stripe, charge_capture_attrs) do
    with {:ok, %Stripe.Charge{} = stripe_charge_capture} =
           @api.Charge.capture(charge_id_from_stripe, charge_capture_attrs),
         {:ok, params} <-
           StripePlatformChargeCaptureAdapter.to_params(stripe_charge_capture) do
      %StripeChargeCapture{}
      |> StripeChargeCapture.changeset(params)
      |> Repo.insert()
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end
end

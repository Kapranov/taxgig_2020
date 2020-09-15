defmodule Stripy.StripeService.Adapters.StripePlatformChargeCaptureAdapter do
  @moduledoc """
  Transfer model from Stripe.ChargeCapture to Application schema model
  """

  import Stripy.MapUtils, only: [keys_to_string: 1, rename: 3]

  @stripe_attributes [
    :amount,
    :application_fee_amount,
    :id,
    :receipt_email,
    :statement_descriptor,
    :statement_descriptor_suffix,
    :transfer_data,
    :transfer_group
  ]

  @spec to_params(Stripe.Charge.t()) :: {:ok, map}
  def to_params(%Stripe.Charge{} = stripe_charge_capture) do
    result =
      stripe_charge_capture
      |> Map.take(@stripe_attributes)
      |> rename(:id, :id_from_stripe)
      |> keys_to_string

    {:ok, result}
  end
end

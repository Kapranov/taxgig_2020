defmodule Stripy.StripeService.Adapters.StripePlatformChargeAdapter do
  @moduledoc """
  Transfer model from Stripe.Charge to Application schema model
  """

  import Stripy.MapUtils, only: [keys_to_string: 1, nested_merge: 2, rename: 3]

  @stripe_attributes [
    :amount,
    :amount_refunded,
    :captured,
    :created,
    :currency,
    :customer,
    :description,
    :failure_code,
    :failure_message,
    :fraud_details,
    :id,
    :outcome,
    :receipt_url,
    :status
  ]

  @stripe_charges_attributes [
    :amount,
    :amount_captured,
    :amount_refunded,
    :captured,
    :created,
    :currency,
    :object,
    :refunded,
    :source,
    :status
  ]

  @nested_source_attributes ["brand", "funding", "id", "last4", "object"]

  @non_stripe_attributes ["id_from_card", "user_id"]

  @spec to_params(Stripe.Charge.t(), map) :: {:ok, map}
  def to_params(%Stripe.Charge{} = stripe_charge, %{} = attrs) do
    result =
      stripe_charge
      |> Map.take(@stripe_attributes)
      |> rename(:id, :id_from_stripe)
      |> rename(:customer, :id_from_customer)
      |> keys_to_string
      |> add_non_stripe_attributes(attrs)

    {:ok, result}
  end

  def to_list_params(%Stripe.Charge{} = stripe_charge, %{}) do
    result =
      stripe_charge
      |> nested_merge(:source)
      |> Map.take(@stripe_charges_attributes)
      |> keys_to_string

    {:ok, result}
  end

  @spec add_non_stripe_attributes(map, map) :: map
  defp add_non_stripe_attributes(%{} = params, %{} = attrs) do
    attrs
    |> Map.take(@non_stripe_attributes)
    |> Map.merge(params)
  end
end

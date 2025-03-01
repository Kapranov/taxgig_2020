defmodule Stripy.StripeService.Adapters.StripePlatformChargeAdapter do
  @moduledoc """
  Transfer model from Stripe.Charge to Application schema model
  """

  import Stripy.MapUtils, only: [keys_to_string: 1, rename: 3]

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

  @stripe_list_charges_attributes [
    :amount,
    :amount_captured,
    :amount_refunded,
    :captured,
    :created,
    :currency,
    :description,
    :object,
    :payment_method,
    :refunded,
    :status
  ]

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

  @spec to_params_for_list(String.t()) :: {:ok, [map]}
  def to_params_for_list(stripe_charge) do
     {:ok, completed(stripe_charge)}
  end

  @spec add_non_stripe_attributes(map, map) :: map
  defp add_non_stripe_attributes(%{} = params, %{} = attrs) do
    attrs
    |> Map.take(@non_stripe_attributes)
    |> Map.merge(params)
  end

  @spec completed(list()) :: [map()]
  defp completed(stripe_charge) do
    Enum.reduce(stripe_charge, [], fn(item, acc) ->
      %{source: source} =
        item
        |> Map.from_struct
        |> Map.take([:source])

      source_data = %{
        source: %{
          brand: source.brand,
          funding: source.funding,
          id: source.id,
          last4: source.last4,
          object: source.object
        }
      }

      %{payment_method_details: payment_method_details} =
        item
        |> Map.from_struct
        |> Map.take([:payment_method_details])

      payment_method_details_data = %{
        payment_method_details: %{
          brand: payment_method_details.card.brand,
          funding: payment_method_details.card.funding,
          last4: payment_method_details.card.last4,
          type: payment_method_details.type
        }
      }

      result =
        item
        |> Map.from_struct
        |> Map.take(@stripe_list_charges_attributes)
        |> Map.merge(source_data)
        |> Map.merge(payment_method_details_data)

      [result | acc]
    end)
  end
end

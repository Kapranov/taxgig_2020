defmodule Stripy.StripeService.Adapters.StripePlatformChargeAdapter do
  @moduledoc """
  Transfer model from Stripe.Charge to Application schema model
  """

  import Stripy.MapUtils, only: [keys_to_string: 1, rename: 3]

  @stripe_attributes [
    :amount,
    :amount_refunded,
    :application,
    :application_fee,
    :application_fee_amount,
    :balance_transaction,
    :billing_details,
    :calculated_statement_descriptor,
    :captured,
    :created,
    :currency,
    :customer,
    :description,
    :disputed,
    :failure_code,
    :failure_message,
    :fraud_details,
    :id,
    :livemode,
    :metadata,
    :on_behalf_of,
    :order,
    :outcome,
    :paid,
    :payment_method,
    :payment_method_details,
    :receipt_email,
    :receipt_number,
    :receipt_url,
    :refunded,
    :refunds,
    :review,
    :shipping,
    :source_transfer,
    :statement_descriptor,
    :statement_descriptor_suffix,
    :status,
    :transfer,
    :transfer_data,
    :transfer_group
  ]

  @non_stripe_attributes ["user_id", "card_token_id_from_stripe"]

  @spec to_params(Stripe.Charge.t(), map) :: {:ok, map}
  def to_params(%Stripe.Charge{} = stripe_charge, %{} = attributes) do
    result =
      stripe_charge
      |> Map.take(@stripe_attributes)
      |> rename(:id, :id_from_stripe)
      |> rename(:customer, :customer_id)
      |> keys_to_string
      |> add_non_stripe_attributes(attributes)

    {:ok, result}
  end

  @spec add_non_stripe_attributes(map, map) :: map
  defp add_non_stripe_attributes(%{} = params, %{} = attributes) do
    attributes
    |> Map.take(@non_stripe_attributes)
    |> Map.merge(params)
  end
end

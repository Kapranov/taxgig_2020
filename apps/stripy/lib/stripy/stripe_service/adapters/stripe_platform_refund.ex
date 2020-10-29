defmodule Stripy.StripeService.Adapters.StripePlatformRefundAdapter do
  @moduledoc """
  Transfer model from Stripe.Refund to Application schema model
  """

  import Stripy.MapUtils, only: [keys_to_string: 1, rename: 3]

  @stripe_attributes [
    :amount,
    :balance_transaction,
    :created,
    :currency,
    :id,
    :status,
    :charge
  ]

  @non_stripe_attributes ["user_id"]

  @spec to_params(Stripe.Refund.t(), map) :: {:ok, map}
  def to_params(%Stripe.Refund{} = stripe_refund, %{} = attrs) do
    result =
      stripe_refund
      |> Map.take(@stripe_attributes)
      |> rename(:id, :id_from_stripe)
      |> rename(:charge, :id_from_charge)
      |> keys_to_string
      |> add_non_stripe_attributes(attrs)

    {:ok, result}
  end

  @spec add_non_stripe_attributes(map, map) :: map
  defp add_non_stripe_attributes(%{} = params, %{} = attrs) do
    attrs
    |> Map.take(@non_stripe_attributes)
    |> Map.merge(params)
  end
end

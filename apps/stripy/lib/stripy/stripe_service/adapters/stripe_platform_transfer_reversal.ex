defmodule Stripy.StripeService.Adapters.StripePlatformTransferReversalAdapter do
  @moduledoc """
  Transfer model from Stripe.Transfer to Application schema model
  """

  import Stripy.MapUtils, only: [rename: 3, keys_to_string: 1]

  @stripe_attributes [
    :amount,
    :balance_transaction,
    :created,
    :currency,
    :destination_payment_refund,
    :id,
    :transfer
  ]

  @non_stripe_attributes ["user_id"]

  @spec to_params(Stripe.Transfer.t, map) :: {:ok, map}
  def to_params(%Stripe.Transfer{} = transfer_reversal, %{} = attributes) do
    result =
      transfer_reversal
      |> Map.take(@stripe_attributes)
      |> rename(:id, :id_from_stripe)
      |> rename(:transfer, :id_from_transfer)
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

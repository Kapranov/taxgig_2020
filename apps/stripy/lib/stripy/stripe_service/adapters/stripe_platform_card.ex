defmodule Stripy.StripeService.Adapters.StripePlatformCardAdapter do
  @moduledoc """
  Transfer model from Stripe.Card to Application schema model
  """

  import Stripy.MapUtils, only: [rename: 3, keys_to_string: 1]

  @stripe_attributes [
    :brand,
    :client_ip,
    :created,
    :customer,
    :cvc_check,
    :exp_month,
    :exp_year,
    :funding,
    :id,
    :last4,
    :name,
    :used
  ]

  @non_stripe_attributes ["user_id"]

  @spec to_params(Stripe.Card.t, map) :: {:ok, map}
  def to_params(%Stripe.Card{} = stripe_card, %{} = attributes) do
    result =
      stripe_card
      |> Map.from_struct
      |> Map.take(@stripe_attributes)
      |> rename(:id, :id_from_stripe)
      |> rename(:customer, :id_from_customer)
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

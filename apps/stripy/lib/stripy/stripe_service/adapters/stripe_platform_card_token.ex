defmodule Stripy.StripeService.Adapters.StripePlatformCardTokenAdapter do
  @moduledoc """
  Transfer model from Stripe.Token to Application schema model
  """

  import Stripy.MapUtils, only: [keys_to_string: 1, nested_merge: 2, rename: 3]

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
    :token,
    :used
  ]

  @non_stripe_attributes ["user_id"]

  @spec to_params(Stripe.Token.t, map) :: {:ok, map}
  def to_params(%Stripe.Token{} = stripe_card_token, %{} = attrs) do
    result =
      stripe_card_token
      |> rename(:id, :token)
      |> nested_merge(:card)
      |> Map.take(@stripe_attributes)
      |> rename(:id, :id_from_stripe)
      |> rename(:customer, :id_from_customer)
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

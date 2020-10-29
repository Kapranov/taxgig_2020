defmodule Stripy.StripeService.Adapters.StripePlatformExternalAccountCardAdapter do
  @moduledoc """
  Transfer model from Stripe.Card to Application schema model
  """

  import Stripy.MapUtils, only: [keys_to_string: 1, rename: 3]

  @stripe_attributes [
    :account,
    :brand,
    :country,
    :currency,
    :cvc_check,
    :default_for_currency,
    :exp_month,
    :exp_year,
    :fingerprint,
    :funding,
    :id,
    :last4,
    :name
  ]

  @non_stripe_attributes ["user_id"]

  @spec to_params(Stripe.Card.t(), map) :: {:ok, map}
  def to_params(%Stripe.Card{} = stripe_card, %{} = attrs) do
    result =
      stripe_card
      |> Map.take(@stripe_attributes)
      |> rename(:id, :id_from_stripe)
      |> rename(:account, :id_from_account)
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

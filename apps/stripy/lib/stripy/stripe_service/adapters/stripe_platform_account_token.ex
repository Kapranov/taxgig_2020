defmodule Stripy.StripeService.Adapters.StripePlatformAccountTokenAdapter do
  @moduledoc """
  Transfer model from Stripe.Token to Application schema model
  """

  import Stripy.MapUtils, only: [keys_to_string: 1, rename: 3]

  @stripe_attributes [
    :client_ip,
    :created,
    :id,
    :used
  ]

  @non_stripe_attributes ["user_id"]

  @spec to_params(Stripe.Token.t(), map) :: {:ok, map}
  def to_params(%Stripe.Token{} = stripe_account, %{} = attributes) do
    result =
      stripe_account
      |> Map.take(@stripe_attributes)
      |> rename(:id, :id_from_stripe)
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

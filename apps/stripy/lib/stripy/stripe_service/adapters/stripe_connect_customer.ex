defmodule Stripy.StripeService.Adapters.StripeConnectCustomerAdapter do
  @moduledoc """
  Transfer model from Stripe.Customer to Application schema model
  """

  import Stripy.MapUtils, only: [rename: 3, keys_to_string: 1]

  @non_stripe_attributes [
    "stripe_connect_account_id",
    "stripe_platform_customer_id",
    "user_id"
  ]

  @spec to_params(Stripe.Customer.t, map) :: {:ok, map}
  def to_params(%Stripe.Customer{} = customer, %{} = attributes) do
    result =
      customer
      |> Map.from_struct
      |> Map.take([:id])
      |> rename(:id, :id_from_stripe)
      |> keys_to_string
      |> add_non_stripe_attributes(attributes)

    {:ok, result}
  end

  @spec add_non_stripe_attributes(map, map) :: map
  defp add_non_stripe_attributes(%{} = params, %{} = attributes) do
    attributes
    |> get_non_stripe_attributes
    |> add_to(params)
  end

  @spec get_non_stripe_attributes(map) :: map
  defp get_non_stripe_attributes(%{} = attributes) do
    attributes
    |> Map.take(@non_stripe_attributes)
  end

  @spec add_to(map, map) :: map
  defp add_to(%{} = attributes, %{} = params) do
    params
    |> Map.merge(attributes)
  end
end

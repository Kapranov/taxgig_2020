defmodule Stripy.StripeService.Adapters.StripePlatformCustomerAdapter do
  @moduledoc """
  Transfer model from Stripe.Customer to Application schema model
  """

  import Stripy.MapUtils, only: [rename: 3, keys_to_string: 1]

  @stripe_attributes [
    :balance,
    :created,
    :currency,
    :email,
    :id,
    :name,
    :phone
  ]

  @non_stripe_attribute_keys ["user_id"]

  @spec to_params(Stripe.Customer.t, map) :: {:ok, map}
  def to_params(%Stripe.Customer{} = customer, %{} = attrs) do
    result =
      customer
      |> Map.from_struct
      |> Map.take(@stripe_attributes)
      |> rename(:id, :id_from_stripe)
      |> keys_to_string
      |> add_non_stripe_attributes(attrs)

    {:ok, result}
  end

  @spec add_non_stripe_attributes(map, map) :: map
  defp add_non_stripe_attributes(%{} = params, %{} = attrs) do
    attrs
    |> get_non_stripe_attributes
    |> add_to(params)
  end

  @spec get_non_stripe_attributes(map) :: map
  defp get_non_stripe_attributes(%{} = attrs) do
    attrs
    |> Map.take(@non_stripe_attribute_keys)
  end

  @spec add_to(map, map) :: map
  defp add_to(%{} = attrs, %{} = params) do
    params
    |> Map.merge(attrs)
  end
end

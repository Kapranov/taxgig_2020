defmodule Stripy.StripeService.Adapters.StripePlatformAccountAdapter do
  @moduledoc """
  Transfer model from Stripe.Account to Application schema model
  """

  import Stripy.MapUtils, only: [keys_to_string: 1, nested_merge: 2, rename: 3]

  @stripe_attributes [
    :business_url,
    :capabilities,
    :charges_enabled,
    :country,
    :created,
    :default_currency,
    :details_submitted,
    :email,
    :id,
    :payout_schedule,
    :payouts_enabled,
    :tos_acceptance,
    :type
  ]

  @non_stripe_attributes ["user_id"]

  @spec to_params(Stripe.Account.t(), map) :: {:ok, map}
  def to_params(%Stripe.Account{} = stripe_account, %{} = attrs) do
    result =
      stripe_account
      |> nested_merge(:business_profile)
      |> rename(:url, :business_url)
      |> Map.take(@stripe_attributes)
      |> rename(:id, :id_from_stripe)
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

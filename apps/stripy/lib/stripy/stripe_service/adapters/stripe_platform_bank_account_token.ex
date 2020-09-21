defmodule Stripy.StripeService.Adapters.StripePlatformBankAccountTokenAdapter do
  @moduledoc """
  Transfer model from Stripe.Token to Application schema model
  """

  import Stripy.MapUtils, only: [keys_to_string: 1, rename: 3, nested_merge: 2]

  @stripe_attributes [
    :account_holder_name,
    :account_holder_type,
    :bank_name,
    :client_ip,
    :country,
    :created,
    :currency,
    :fingerprint,
    :id,
    :last4,
    :routing_number,
    :status,
    :used
  ]

  @non_stripe_attributes ["user_id"]

  @spec to_params(Stripe.Token.t(), map) :: {:ok, map}
  def to_params(%Stripe.Token{} = stripe_bank_account_token, %{} = attributes) do
    result =
      stripe_bank_account_token
      |> rename(:id, :id_from_stripe)
      |> nested_merge(:bank_account)
      |> Map.take(@stripe_attributes)
      |> rename(:id ,:id_from_bank_account)
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

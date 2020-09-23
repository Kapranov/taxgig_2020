defmodule Stripy.StripeService.Adapters.StripePlatformExternalAccountBankAdapter do
  @moduledoc """
  Transfer model from Stripe.BankAccount to Application schema model
  """

  import Stripy.MapUtils, only: [keys_to_string: 1, rename: 3]

  @stripe_attributes [
    :account,
    :account_holder_name,
    :account_holder_type,
    :bank_name,
    :country,
    :currency,
    :fingerprint,
    :id,
    :last4,
    :routing_number,
    :status
  ]

  @non_stripe_attributes ["user_id"]

  @spec to_params(Stripe.BankAccount.t(), map) :: {:ok, map}
  def to_params(%Stripe.BankAccount{} = stripe_bank_account, %{} = attributes) do
    result =
      stripe_bank_account
      |> Map.take(@stripe_attributes)
      |> rename(:id, :id_from_stripe)
      |> rename(:account, :id_from_account)
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

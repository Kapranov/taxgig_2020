defmodule ServerWeb.Seeder.Updated.StripeExternalAccountBank do
  @moduledoc """
  An update are seeds whole the stripe external account banks.
  """
  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_stripe_external_account_bank()
  end

  @spec update_stripe_external_account_bank() :: Ecto.Schema.t()
  defp update_stripe_external_account_bank do
  end
end

defmodule Stripy.Seeder.Updated.StripeExternalAccountCard do
  @moduledoc """
  An update are seeds whole the stripe external account cards.
  """

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_stripe_external_account_card()
  end

  @spec update_stripe_external_account_card() :: Ecto.Schema.t()
  defp update_stripe_external_account_card do
  end
end


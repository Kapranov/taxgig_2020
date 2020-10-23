defmodule ServerWeb.Seeder.Updated.StripeCard do
  @moduledoc """
  An update are seeds whole the stripe cards.
  """
  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_stripe_card_token()
  end

  @spec update_stripe_card_token() :: Ecto.Schema.t()
  defp update_stripe_card_token do
  end
end

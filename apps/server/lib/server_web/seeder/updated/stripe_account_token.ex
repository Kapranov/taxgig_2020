defmodule ServerWeb.Seeder.Updated.StripeAccountToken do
  @moduledoc """
  An update are seeds whole the stripe account tokens.
  """
  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_stripe_account_token()
  end

  @spec update_stripe_account_token() :: Ecto.Schema.t()
  defp update_stripe_account_token do
  end
end

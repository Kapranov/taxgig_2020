defmodule ServerWeb.Seeder.Updated.StripeAccount do
  @moduledoc """
  An update are seeds whole the stripe accounts.
  """
  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_stripe_account()
  end

  @spec update_stripe_account() :: Ecto.Schema.t()
  defp update_stripe_account do
  end
end

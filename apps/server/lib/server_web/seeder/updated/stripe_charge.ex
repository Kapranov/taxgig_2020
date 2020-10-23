defmodule ServerWeb.Seeder.Updated.StripeCharge do
  @moduledoc """
  An update are seeds whole the stripe charges.
  """
  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_stripe_charge()
  end

  @spec update_stripe_charge() :: Ecto.Schema.t()
  defp update_stripe_charge do
  end
end

defmodule ServerWeb.Seeder.Updated.StripeCustomer do
  @moduledoc """
  An update are seeds whole the stripe customer.
  """
  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_stripe_customer()
  end

  @spec update_stripe_customer() :: Ecto.Schema.t()
  defp update_stripe_customer do
  end
end


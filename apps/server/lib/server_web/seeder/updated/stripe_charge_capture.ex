defmodule ServerWeb.Seeder.Updated.StripeChargeCapture do
  @moduledoc """
  An update are seeds whole the stripe charge captures.
  """
  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_stripe_charge_capture()
  end

  @spec update_stripe_charge_capture() :: Ecto.Schema.t()
  defp update_stripe_charge_capture do
  end
end

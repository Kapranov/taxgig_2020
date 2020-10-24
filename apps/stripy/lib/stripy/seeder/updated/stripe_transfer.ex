defmodule Stripy.Seeder.Updated.StripeTransfer do
  @moduledoc """
  An update are seeds whole the stripe transfers.
  """

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_stripe_transfer()
  end

  @spec update_stripe_transfer() :: Ecto.Schema.t()
  defp update_stripe_transfer do
  end
end

defmodule Stripy.Seeder.Updated.StripeTransferReversal do
  @moduledoc """
  An update are seeds whole the stripe transfer reversals.
  """

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_stripe_transfer_reversal()
  end

  @spec update_stripe_transfer_reversal() :: Ecto.Schema.t()
  defp update_stripe_transfer_reversal do
  end
end

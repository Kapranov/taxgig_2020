defmodule Stripy.Seeder.Updated.StripeRefund do
  @moduledoc """
  An update are seeds whole the stripe refunds.
  """

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_stripe_refund()
  end

  @spec update_stripe_refund() :: Ecto.Schema.t()
  defp update_stripe_refund do
  end
end

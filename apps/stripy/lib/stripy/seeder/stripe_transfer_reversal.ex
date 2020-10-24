defmodule Stripy.Seeder.StripeTransferReversal do
  @moduledoc """
  Seeds for `Stripy.StripeTransferReversal` context.
  """

  alias Stripy.{
    Payments.StripeTransferReversal,
    Repo
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(StripeTransferReversal)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_transfer_reversal()
  end

  @spec seed_stripe_transfer_reversal() :: [Ecto.Schema.t()]
  defp seed_stripe_transfer_reversal do
  end
end

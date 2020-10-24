defmodule Stripy.Seeder.StripeTransfer do
  @moduledoc """
  Seeds for `Stripy.StripeTransfer` context.
  """

  alias Stripy.{
    Payments.StripeTransfer,
    Repo
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(StripeTransfer)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_transfer()
  end

  @spec seed_stripe_transfer() :: [Ecto.Schema.t()]
  defp seed_stripe_transfer do
  end
end

defmodule Stripy.Seeder.StripeCharge do
  @moduledoc """
  Seeds for `Stripy.StripeCharge` context.
  """

  alias Stripy.{
    Payments.StripeCharge,
    Repo
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(StripeCharge)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_charge()
  end

  @spec seed_stripe_charge() :: [Ecto.Schema.t()]
  defp seed_stripe_charge do
  end
end

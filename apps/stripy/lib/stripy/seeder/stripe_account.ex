defmodule Stripy.Seeder.StripeAccount do
  @moduledoc """
  Seeds for `Stripy.StripeAccount` context.
  """

  alias Stripy.{
    Payments.StripeAccount,
    Repo
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(StripeAccount)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_account()
  end

  @spec seed_stripe_account() :: [Ecto.Schema.t()]
  defp seed_stripe_account do
  end
end

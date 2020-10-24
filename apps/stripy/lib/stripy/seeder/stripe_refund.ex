defmodule Stripy.Seeder.StripeRefund do
  @moduledoc """
  Seeds for `Stripy.StripeRefund` context.
  """

  alias Stripy.{
    Payments.StripeRefund,
    Repo
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(StripeRefund)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_refund()
  end

  @spec seed_stripe_refund() :: [Ecto.Schema.t()]
  defp seed_stripe_refund do
  end
end

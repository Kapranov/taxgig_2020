defmodule Stripy.Seeder.StripeChargeCapture do
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
    seed_stripe_charge_capture()
  end

  @spec seed_stripe_charge_capture() :: [Ecto.Schema.t()]
  defp seed_stripe_charge_capture do
  end
end

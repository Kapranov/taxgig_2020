defmodule Stripy.Seeder.StripeExternalAccountBank do
  @moduledoc """
  Seeds for `Stripy.StripeExternalAccountBank` context.
  """

  alias Stripy.{
    Payments.StripeExternalAccountBank,
    Repo
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(StripeExternalAccountBank)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_external_account_bank()
  end

  @spec seed_stripe_external_account_bank() :: [Ecto.Schema.t()]
  defp seed_stripe_external_account_bank do
  end
end

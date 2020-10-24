defmodule Stripy.Seeder.StripeExternalAccountCard do
  @moduledoc """
  Seeds for `Stripy.StripeExternalAccountCard` context.
  """

  alias Stripy.{
    Payments.StripeExternalAccountCard,
    Repo
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(StripeExternalAccountCard)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_external_account_card()
  end

  @spec seed_stripe_external_account_card() :: [Ecto.Schema.t()]
  defp seed_stripe_external_account_card do
  end
end

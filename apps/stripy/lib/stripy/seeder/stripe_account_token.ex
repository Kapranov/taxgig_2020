defmodule Stripy.Seeder.StripeAccountToken do
  @moduledoc """
  Seeds for `Stripy.StripeAccountToken` context.
  """

  alias Stripy.{
    Payments.StripeAccountToken,
    Repo
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(StripeAccountToken)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_account_token()
  end

  @spec seed_stripe_account_token() :: [Ecto.Schema.t()]
  defp seed_stripe_account_token do
  end
end

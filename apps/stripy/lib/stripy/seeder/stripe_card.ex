defmodule Stripy.Seeder.StripeCard do
  @moduledoc """
  Seeds for `Stripy.StripeCardToken` context.
  """

  alias Stripy.{
    Payments.StripeCardToken,
    Repo
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(StripeCardToken)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_card_token()
  end

  @spec seed_stripe_card_token() :: [Ecto.Schema.t()]
  def seed_stripe_card_token do
  end
end

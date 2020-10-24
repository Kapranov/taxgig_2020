defmodule Stripy.Seeder.StripeBankAccountToken do
  @moduledoc """
  Seeds for `Stripy.StripeBankAccountToken` context.
  """

  alias Stripy.{
    Payments.StripeBankAccountToken,
    Repo
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(StripeBankAccountToken)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_bank_account_token()
  end

  @spec seed_stripe_bank_account_token() :: [Ecto.Schema.t()]
  defp seed_stripe_bank_account_token do
  end
end

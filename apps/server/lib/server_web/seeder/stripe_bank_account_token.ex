defmodule ServerWeb.Seeder.StripeBankAccountToken do
  @moduledoc """
  Seeds for `Stripy.StripeBankAccountToken` context.
  """

  alias Stripy.Payments.StripeBankAccountToken
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeBankAccountToken)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_bank_account_token()
  end

  @spec seed_stripe_bank_account_token() :: [Ecto.Schema.t()]
  def seed_stripe_bank_account_token do
  end

  @doc """
  """
  @spec platform_bank_account_token(map, map) :: {:ok, StripeBankAccountToken.t} |
                                                 {:error, Ecto.Changeset.t} |
                                                 {:error, :not_found}
  def platform_bank_account_token(attrs, user_attrs) do
    {attrs, user_attrs}
  end
end

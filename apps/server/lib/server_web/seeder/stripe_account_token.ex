defmodule ServerWeb.Seeder.StripeAccountToken do
  @moduledoc """
  Seeds for `Stripy.StripeAccountToken` context.
  """

  alias Stripy.Payments.StripeAccountToken
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeAccountToken)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_account_token()
  end

  @spec seed_stripe_account_token() :: [Ecto.Schema.t()]
  def seed_stripe_account_token do
  end

  @doc """
  """
  @spec platform_account_token(map, map) :: {:ok, StripeAccountToken.t} |
                                            {:error, Ecto.Changeset.t} |
                                            {:error, :not_found}
  def platform_account_token(attrs, user_attrs) do
    {attrs, user_attrs}
  end
end

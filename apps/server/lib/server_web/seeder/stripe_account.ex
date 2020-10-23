defmodule ServerWeb.Seeder.StripeAccount do
  @moduledoc """
  Seeds for `Stripy.StripeAccount` context.
  """

  alias Stripy.Payments.StripeAccount
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeAccount)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_account()
  end

  @spec seed_stripe_account() :: [Ecto.Schema.t()]
  def seed_stripe_account do
  end

  @doc """
  """
  @spec platform_account(map, map) :: {:ok, StripeAccount.t} |
                                      {:error, Ecto.Changeset.t} |
                                      {:error, :not_found}
  def platform_account(attrs, user_attrs) do
    {attrs, user_attrs}
  end
end

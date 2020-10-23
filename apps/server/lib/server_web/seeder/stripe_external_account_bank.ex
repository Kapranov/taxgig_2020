defmodule ServerWeb.Seeder.StripeExternalAccountBank do
  @moduledoc """
  Seeds for `Stripy.StripeExternalAccountBank` context.
  """

  alias Stripy.Payments.StripeExternalAccountBank
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeExternalAccountBank)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_external_account_bank()
  end

  @spec seed_stripe_external_account_bank() :: [Ecto.Schema.t()]
  def seed_stripe_external_account_bank do
  end

  @doc """
  """
  @spec platform_external_account_bank(map, map) :: {:ok, StripeExternalAccountBank.t} |
                                                    {:error, Ecto.Changeset.t} |
                                                    {:error, :not_found}
  def platform_external_account_bank(attrs, user_attrs) do
    {attrs, user_attrs}
  end
end

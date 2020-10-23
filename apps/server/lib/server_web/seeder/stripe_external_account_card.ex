defmodule ServerWeb.Seeder.StripeExternalAccountCard do
  @moduledoc """
  Seeds for `Stripy.StripeExternalAccountCard` context.
  """
  alias Stripy.Payments.StripeExternalAccountCard
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeExternalAccountCard)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_external_account_card()
  end

  @spec seed_stripe_external_account_card() :: [Ecto.Schema.t()]
  def seed_stripe_external_account_card do
  end

  @doc """
  """
  @spec platform_external_account_card(map, map) :: {:ok, StripeExternalAccountCard.t} |
                                                    {:error, Ecto.Changeset.t} |
                                                    {:error, :not_found}
  def platform_external_account_card(attrs, user_attrs) do
    {attrs, user_attrs}
  end

end

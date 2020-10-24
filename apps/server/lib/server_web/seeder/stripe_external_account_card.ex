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

  @doc """
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_external_account_card()
  end

  @spec seed_stripe_external_account_card() :: [Ecto.Schema.t()]
  defp seed_stripe_external_account_card do
    platform_external_account_card(%{}, %{})
  end

  @spec platform_external_account_card(map, map) :: {:ok, StripeExternalAccountCard.t} |
                                                    {:error, Ecto.Changeset.t} |
                                                    {:error, :not_found}
  defp platform_external_account_card(_attrs, _user_attrs) do
  end
end

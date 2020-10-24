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

  @doc """
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_external_account_bank()
  end

  @spec seed_stripe_external_account_bank() :: [Ecto.Schema.t()]
  defp seed_stripe_external_account_bank do
    platform_external_account_bank(%{}, %{})
  end

  @spec platform_external_account_bank(map, map) :: {:ok, StripeExternalAccountBank.t} |
                                                    {:error, Ecto.Changeset.t} |
                                                    {:error, :not_found}
  defp platform_external_account_bank(_attrs, _user_attrs) do
  end
end

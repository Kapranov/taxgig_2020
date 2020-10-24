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

  @doc """
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_account()
  end

  @spec seed_stripe_account() :: [Ecto.Schema.t()]
  defp seed_stripe_account do
    platform_account(%{}, %{})
  end

  @spec platform_account(map, map) :: {:ok, StripeAccount.t} |
                                      {:error, Ecto.Changeset.t} |
                                      {:error, :not_found}
  defp platform_account(_attrs, _user_attrs) do
  end
end

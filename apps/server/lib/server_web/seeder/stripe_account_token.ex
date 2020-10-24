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

  @doc """
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_account_token()
  end

  @spec seed_stripe_account_token() :: [Ecto.Schema.t()]
  defp seed_stripe_account_token do
    platform_account_token(%{}, %{})
  end

  @spec platform_account_token(map, map) :: {:ok, StripeAccountToken.t} |
                                            {:error, Ecto.Changeset.t} |
                                            {:error, :not_found}
  defp platform_account_token(_attrs, _user_attrs) do
  end
end

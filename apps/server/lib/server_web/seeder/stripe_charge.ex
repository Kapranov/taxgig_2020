defmodule ServerWeb.Seeder.StripeCharge do
  @moduledoc """
  Seeds for `Stripy.StripeCharge` context.
  """

  alias Stripy.Payments.StripeCharge
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeCharge)
  end

  @doc """
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_charge()
  end

  @spec seed_stripe_charge() :: [Ecto.Schema.t()]
  defp seed_stripe_charge do
    platform_charge(%{}, %{})
  end

  @spec platform_charge(map, map) :: {:ok, StripeCharge.t} |
                                     {:error, Ecto.Changeset.t} |
                                     {:error, :not_found}
  defp platform_charge(_attrs, _user_attrs) do
  end
end

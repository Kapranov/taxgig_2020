defmodule ServerWeb.Seeder.StripeTransfer do
  @moduledoc """
  Seeds for `Stripy.StripeTransfer` context.
  """

  alias Stripy.Payments.StripeTransfer
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeTransfer)
  end

  @doc """
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_transfer()
  end

  @spec seed_stripe_transfer() :: [Ecto.Schema.t()]
  defp seed_stripe_transfer do
    platform_transfer(%{}, %{})
  end

  @spec platform_transfer(map, map) :: {:ok, StripeTransfer.t} |
                                       {:error, Ecto.Changeset.t} |
                                       {:error, :not_found}
  defp platform_transfer(_attrs, _user_attrs) do
  end
end

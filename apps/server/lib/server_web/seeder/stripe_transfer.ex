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

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_transfer()
  end

  @spec seed_stripe_transfer() :: [Ecto.Schema.t()]
  def seed_stripe_transfer do
  end

  @doc """
  """
  @spec platform_transfer(map, map) :: {:ok, StripeTransfer.t} |
                                       {:error, Ecto.Changeset.t} |
                                       {:error, :not_found}
  def platform_transfer(attrs, user_attrs) do
    {attrs, user_attrs}
  end
end

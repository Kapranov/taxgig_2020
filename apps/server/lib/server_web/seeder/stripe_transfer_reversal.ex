defmodule ServerWeb.Seeder.StripeTransferReversal do
  @moduledoc """
  Seeds for `Stripy.StripeTransferReversal` context.
  """

  alias Stripy.Payments.StripeTransferReversal
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeTransferReversal)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_transfer_reversal()
  end

  @spec seed_stripe_transfer_reversal() :: [Ecto.Schema.t()]
  def seed_stripe_transfer_reversal do
  end

  @doc """
  """
  @spec platform_transfer_reversal(map, map) :: {:ok, StripeTransferReversal.t} |
                                                {:error, Ecto.Changeset.t} |
                                                {:error, :not_found}
  def platform_transfer_reversal(attrs, user_attrs) do
    {attrs, user_attrs}
  end
end

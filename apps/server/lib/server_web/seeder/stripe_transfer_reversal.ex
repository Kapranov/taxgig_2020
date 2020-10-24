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

  @doc """
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_transfer_reversal()
  end

  @spec seed_stripe_transfer_reversal() :: [Ecto.Schema.t()]
  defp seed_stripe_transfer_reversal do
    platform_transfer_reversal(%{}, %{})
  end

  @spec platform_transfer_reversal(map, map) :: {:ok, StripeTransferReversal.t} |
                                                {:error, Ecto.Changeset.t} |
                                                {:error, :not_found}
  defp platform_transfer_reversal(_attrs, _user_attrs) do
  end
end

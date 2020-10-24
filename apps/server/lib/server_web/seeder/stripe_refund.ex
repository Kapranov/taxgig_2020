defmodule ServerWeb.Seeder.StripeRefund do
  @moduledoc """
  Seeds for `Stripy.StripeRefund` context.
  """

  alias Stripy.Payments.StripeRefund
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeRefund)
  end

  @doc """
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_refund()
  end

  @spec seed_stripe_refund() :: [Ecto.Schema.t()]
  defp seed_stripe_refund do
    platform_refund(%{}, %{})
  end

  @spec platform_refund(map, map) :: {:ok, StripeRefund.t} |
                                     {:error, Ecto.Changeset.t} |
                                     {:error, :not_found}
  defp platform_refund(_attrs, _user_attrs) do
  end
end

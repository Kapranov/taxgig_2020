defmodule ServerWeb.Seeder.StripeChargeCapture do
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
    seed_stripe_charge_capture()
  end

  @spec seed_stripe_charge_capture() :: [Ecto.Schema.t()]
  defp seed_stripe_charge_capture do
    platform_charge_capture(%{}, %{})
  end

  @spec platform_charge_capture(map, map) :: {:ok, StripeCharge.t} |
                                             {:error, Ecto.Changeset.t} |
                                             {:error, :not_found}
  defp platform_charge_capture(_attrs, _user_attrs) do
  end
end

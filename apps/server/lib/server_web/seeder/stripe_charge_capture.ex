defmodule ServerWeb.Seeder.StripeChargeCapture do
  @moduledoc """
  Seeds for `Stripy.StripeChargeCapture` context.
  """

  alias Stripy.Payments.StripeCharge
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeCharge)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_charge_capture()
  end

  @spec seed_stripe_charge_capture() :: [Ecto.Schema.t()]
  def seed_stripe_charge_capture do
  end

  @doc """
  """
  @spec platform_charge_capture(map, map) :: {:ok, StripeCharge.t} |
                                             {:error, Ecto.Changeset.t} |
                                             {:error, :not_found}
  def platform_charge_capture(attrs, user_attrs) do
    {attrs, user_attrs}
  end
end

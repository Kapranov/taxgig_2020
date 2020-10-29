defmodule ServerWeb.Seeder.StripeChargeCapture do
  @moduledoc """
  Seeds for `Stripy.StripeCharge` context.
  """

  alias Core.Accounts
  alias Stripy.{
    Payments.StripeCharge,
    Repo,
    StripeService.StripePlatformChargeCaptureService
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(StripeCharge)
  end

  @doc """
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_charge_capture()
  end

  @spec seed_stripe_charge_capture() :: [Ecto.Schema.t()]
  defp seed_stripe_charge_capture do
    charge_ids = Enum.map(Repo.all(StripeCharge), &(&1))
    { charged } = { Enum.at(charge_ids, 0) }

    attrs = %{ amount: 2000 , user_id: charged.user_id}

    platform_charge_capture(charged.id_from_stripe, attrs)
  end

  @spec platform_charge_capture(map, map) :: {:ok, StripeCharge.t} |
                                             {:error, Ecto.Changeset.t} |
                                             {:error, :not_found}
  defp platform_charge_capture(id_from_charge, attrs) do
    case Accounts.by_role(attrs.user_id) do
      true -> {:error, %Ecto.Changeset{}}
      false ->
        with {:ok,  %StripeCharge{} = data} <- StripePlatformChargeCaptureService.create(id_from_charge, Map.take(attrs, [:amount])) do
          {:ok, data}
        else
          nil -> {:error, :not_found}
          failure -> failure
        end
    end
  end
end

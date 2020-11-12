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
  frontend - []
  backend - [:amount, :id_from_stripe]

  1. If field `capture` is false, create capture by 'StripeCharge'
  2. If field `capture` is true, return error

  ## Example

  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_charge_capture()
  end

  @spec seed_stripe_charge_capture() :: [Ecto.Schema.t()]
  defp seed_stripe_charge_capture do
    charge_ids = Enum.map(Repo.all(StripeCharge), &(&1))
    { ch01 } = { Enum.at(charge_ids, 0) }
    { ch02 } = { Enum.at(charge_ids, 1) }
    { ch03 } = { Enum.at(charge_ids, 2) }
    { ch04 } = { Enum.at(charge_ids, 3) }
    { ch05 } = { Enum.at(charge_ids, 4) }
    { ch06 } = { Enum.at(charge_ids, 5) }
    { ch07 } = { Enum.at(charge_ids, 6) }
    { ch08 } = { Enum.at(charge_ids, 7) }
    { ch09 } = { Enum.at(charge_ids, 8) }
    { ch10 } = { Enum.at(charge_ids, 9) }
    { ch11 } = { Enum.at(charge_ids, 10) }

    attrs01 = %{ amount: ch01.amount, user_id: ch01.user_id}
    attrs02 = %{ amount: ch02.amount, user_id: ch02.user_id}
    attrs03 = %{ amount: ch03.amount, user_id: ch03.user_id}
    attrs04 = %{ amount: ch04.amount, user_id: ch04.user_id}
    attrs05 = %{ amount: ch05.amount, user_id: ch05.user_id}
    attrs06 = %{ amount: ch06.amount, user_id: ch06.user_id}
    attrs07 = %{ amount: ch07.amount, user_id: ch07.user_id}
    attrs08 = %{ amount: ch08.amount, user_id: ch08.user_id}
    attrs09 = %{ amount: ch09.amount, user_id: ch09.user_id}
    attrs10 = %{ amount: ch10.amount, user_id: ch10.user_id}
    attrs11 = %{ amount: ch11.amount, user_id: ch11.user_id}

    if ch01.captured == false and
       ch02.captured == false and
       ch03.captured == false and
       ch04.captured == false and
       ch05.captured == false and
       ch06.captured == false and
       ch07.captured == false and
       ch08.captured == false and
       ch09.captured == false and
       ch10.captured == false and
       ch11.captured == false
    do
      platform_charge_capture(ch01.id_from_stripe, attrs01)
      platform_charge_capture(ch02.id_from_stripe, attrs02)
      platform_charge_capture(ch03.id_from_stripe, attrs03)
      platform_charge_capture(ch04.id_from_stripe, attrs04)
      platform_charge_capture(ch05.id_from_stripe, attrs05)
      platform_charge_capture(ch06.id_from_stripe, attrs06)
      platform_charge_capture(ch07.id_from_stripe, attrs07)
      platform_charge_capture(ch08.id_from_stripe, attrs08)
      platform_charge_capture(ch09.id_from_stripe, attrs09)
      platform_charge_capture(ch10.id_from_stripe, attrs10)
      platform_charge_capture(ch11.id_from_stripe, attrs11)
    else
      {:error, %Ecto.Changeset{}}
    end
  end

  @spec platform_charge_capture(map, map) ::
          {:ok, StripeCharge.t}
          | {:error, Ecto.Changeset.t}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
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

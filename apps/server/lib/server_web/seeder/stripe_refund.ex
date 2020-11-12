defmodule ServerWeb.Seeder.StripeRefund do
  @moduledoc """
  Seeds for `Stripy.StripeRefund` context.
  """

  alias Core.Accounts

  alias Stripy.{
    Payments.StripeCharge,
    Payments.StripeRefund,
    Repo,
    StripeService.StripePlatformRefundService
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(StripeRefund)
  end

  @doc """
  frontend - [:amount]
  backend = [:id_from_stripe]

  1. If created a new `StripeRefund` field's captured must be true by `StripeCharge`,
     field's amount must be equels or less by `StripeCharge.amount >= attrs["amount"]
     Check all records by userId and `id_from_charge` in `StripeRefund` take there
     are amounts summarized result must be less by `StripeCharge.amount`.
     You can optionally refund only part of a charge. You can do so multiple times,
     until the entire charge has been refunded.
  2. If created a new `StripeRefund` in `StripeCharge` field's captured is false return error

  ## Example

  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_refund()
  end

  @spec seed_stripe_refund() :: [Ecto.Schema.t()]
  defp seed_stripe_refund do
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

    attrs01 = %{amount: 2000, charge: ch01.id_from_stripe}
    attrs02 = %{amount: 1000, charge: ch02.id_from_stripe}
    attrs03 = %{amount: 2000, charge: ch03.id_from_stripe}
    attrs04 = %{amount: 2000, charge: ch04.id_from_stripe}
    attrs05 = %{amount: 2000, charge: ch05.id_from_stripe}
    attrs06 = %{amount: 2000, charge: ch06.id_from_stripe}
    attrs07 = %{amount: 2000, charge: ch07.id_from_stripe}
    attrs08 = %{amount: 1000, charge: ch08.id_from_stripe}
    attrs09 = %{amount: 2000, charge: ch09.id_from_stripe}
    attrs10 = %{amount: 2000, charge: ch10.id_from_stripe}
    attrs11 = %{amount: 2000, charge: ch11.id_from_stripe}

    user_attrs01 = %{"user_id" => ch01.user_id}
    user_attrs02 = %{"user_id" => ch02.user_id}
    user_attrs03 = %{"user_id" => ch03.user_id}
    user_attrs04 = %{"user_id" => ch04.user_id}
    user_attrs05 = %{"user_id" => ch05.user_id}
    user_attrs06 = %{"user_id" => ch06.user_id}
    user_attrs07 = %{"user_id" => ch07.user_id}
    user_attrs08 = %{"user_id" => ch08.user_id}
    user_attrs09 = %{"user_id" => ch09.user_id}
    user_attrs10 = %{"user_id" => ch10.user_id}
    user_attrs11 = %{"user_id" => ch11.user_id}

    if ch01.captured == true and
       ch02.captured == true and
       ch03.captured == true and
       ch04.captured == true and
       ch05.captured == true and
       ch06.captured == true and
       ch07.captured == true and
       ch08.captured == true and
       ch09.captured == true and
       ch10.captured == true and
       ch11.captured == true and
       ch01.amount >= attrs01.amount and
       ch02.amount >= attrs02.amount and
       ch03.amount >= attrs03.amount and
       ch04.amount >= attrs04.amount and
       ch05.amount >= attrs05.amount and
       ch06.amount >= attrs06.amount and
       ch07.amount >= attrs07.amount and
       ch08.amount >= attrs08.amount and
       ch09.amount >= attrs09.amount and
       ch10.amount >= attrs10.amount and
       ch11.amount >= attrs11.amount
    do
      case Stripy.Queries.by_proba(Stripy.Payments.StripeCharge, Stripy.Payments.StripeRefund, :id_from_stripe, :id_from_charge, :user_id, :amount, attrs01.charge) do
        [true]  -> platform_refund(attrs01, user_attrs01)
        [false] -> {:error, %Ecto.Changeset{}}
        [nil] -> platform_refund(attrs01, user_attrs01)
      end
      case Stripy.Queries.by_proba(Stripy.Payments.StripeCharge, Stripy.Payments.StripeRefund, :id_from_stripe, :id_from_charge, :user_id, :amount, attrs02.charge) do
        [true]  -> platform_refund(attrs02, user_attrs02)
        [false] -> {:error, %Ecto.Changeset{}}
        [nil] -> platform_refund(attrs02, user_attrs02)
      end
      case Stripy.Queries.by_proba(Stripy.Payments.StripeCharge, Stripy.Payments.StripeRefund, :id_from_stripe, :id_from_charge, :user_id, :amount, attrs03.charge) do
        [true]  -> platform_refund(attrs03, user_attrs03)
        [false] -> {:error, %Ecto.Changeset{}}
        [nil] -> platform_refund(attrs03, user_attrs03)
      end
      case Stripy.Queries.by_proba(Stripy.Payments.StripeCharge, Stripy.Payments.StripeRefund, :id_from_stripe, :id_from_charge, :user_id, :amount, attrs04.charge) do
        [true]  -> platform_refund(attrs04, user_attrs04)
        [false] -> {:error, %Ecto.Changeset{}}
        [nil] -> platform_refund(attrs04, user_attrs04)
      end
      case Stripy.Queries.by_proba(Stripy.Payments.StripeCharge, Stripy.Payments.StripeRefund, :id_from_stripe, :id_from_charge, :user_id, :amount, attrs05.charge) do
        [true]  -> platform_refund(attrs05, user_attrs05)
        [false] -> {:error, %Ecto.Changeset{}}
        [nil] -> platform_refund(attrs05, user_attrs05)
      end
      case Stripy.Queries.by_proba(Stripy.Payments.StripeCharge, Stripy.Payments.StripeRefund, :id_from_stripe, :id_from_charge, :user_id, :amount, attrs06.charge) do
        [true]  -> platform_refund(attrs06, user_attrs06)
        [false] -> {:error, %Ecto.Changeset{}}
        [nil] -> platform_refund(attrs06, user_attrs06)
      end
      case Stripy.Queries.by_proba(Stripy.Payments.StripeCharge, Stripy.Payments.StripeRefund, :id_from_stripe, :id_from_charge, :user_id, :amount, attrs07.charge) do
        [true]  -> platform_refund(attrs07, user_attrs07)
        [false] -> {:error, %Ecto.Changeset{}}
        [nil] -> platform_refund(attrs07, user_attrs07)
      end
      case Stripy.Queries.by_proba(Stripy.Payments.StripeCharge, Stripy.Payments.StripeRefund, :id_from_stripe, :id_from_charge, :user_id, :amount, attrs08.charge) do
        [true]  -> platform_refund(attrs08, user_attrs08)
        [false] -> {:error, %Ecto.Changeset{}}
        [nil] -> platform_refund(attrs08, user_attrs08)
      end
      case Stripy.Queries.by_proba(Stripy.Payments.StripeCharge, Stripy.Payments.StripeRefund, :id_from_stripe, :id_from_charge, :user_id, :amount, attrs09.charge) do
        [true]  -> platform_refund(attrs09, user_attrs09)
        [false] -> {:error, %Ecto.Changeset{}}
        [nil] -> platform_refund(attrs09, user_attrs09)
      end
      case Stripy.Queries.by_proba(Stripy.Payments.StripeCharge, Stripy.Payments.StripeRefund, :id_from_stripe, :id_from_charge, :user_id, :amount, attrs10.charge) do
        [true]  -> platform_refund(attrs10, user_attrs10)
        [false] -> {:error, %Ecto.Changeset{}}
        [nil] -> platform_refund(attrs10, user_attrs10)
      end
      case Stripy.Queries.by_proba(Stripy.Payments.StripeCharge, Stripy.Payments.StripeRefund, :id_from_stripe, :id_from_charge, :user_id, :amount, attrs11.charge) do
        [true]  -> platform_refund(attrs11, user_attrs11)
        [false] -> {:error, %Ecto.Changeset{}}
        [nil] -> platform_refund(attrs11, user_attrs11)
      end
    else
      {:error, %Ecto.Changeset{}}
    end
  end

  @spec platform_refund(map, map) ::
          {:ok, StripeRefund.t}
          | {:error, Ecto.Changeset.t}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  defp platform_refund(attrs, user_attrs) do
    case Accounts.by_role(user_attrs["user_id"]) do
      true -> {:error, %Ecto.Changeset{}}
      false ->
        with {:ok,  %StripeRefund{} = data} <- StripePlatformRefundService.create(attrs, user_attrs) do
          {:ok, data}
        else
          nil -> {:error, :not_found}
          failure -> failure
        end
    end
  end
end

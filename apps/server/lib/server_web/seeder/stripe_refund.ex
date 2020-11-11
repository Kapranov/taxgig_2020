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
    { charged } = { Enum.at(charge_ids, 0) }

    attrs = %{amount: 2000, charge: charged.id_from_stripe}
    user_attrs = %{"user_id" => charged.user_id}

    platform_refund(attrs, user_attrs)
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

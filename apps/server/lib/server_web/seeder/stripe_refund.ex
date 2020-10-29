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
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_refund()
  end

  @spec seed_stripe_refund() :: [Ecto.Schema.t()]
  defp seed_stripe_refund do
    charge_ids = Enum.map(Repo.all(StripeCharge), &(&1))
    { charged } = { Enum.at(charge_ids, 0) }

    attrs = %{amount: 1000, charge: charged.id_from_stripe}
    user_attrs = %{"user_id" => charged.user_id}

    platform_refund(attrs, user_attrs)
  end

  @spec platform_refund(map, map) :: {:ok, StripeRefund.t} |
                                     {:error, Ecto.Changeset.t} |
                                     {:error, :not_found}
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

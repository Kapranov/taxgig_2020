defmodule ServerWeb.Seeder.StripeTransferReversal do
  @moduledoc """
  Seeds for `Stripy.StripeTransferReversal` context.
  """

  alias Core.{
    Accounts,
    Accounts.User
  }

  alias Stripy.{
    Payments.StripeTransfer,
    Payments.StripeTransferReversal,
    StripeService.StripePlatformTransferReversalService
  }

  alias Core.Repo, as: CoreRepo
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeTransferReversal)
  end

  @doc """
  Used to create a remote `Stripe.TransferReversal` record as well as
  an associated local `StripeTransferReversal` record. When you create
  a new reversal, you must specify a transfer to create it on.

  When reversing transfers, you can optionally reverse part of the transfer.
  You can do so as many times as you wish until the entire transfer has been
  reversed.

  frontend - [:amount]
  backend  - [:project.stripe_transfer.id_from_stripe]

  1. If create a new `StripeTransferReversal` field's amount must be equels or less
     same field by `StripeTransfer` (StripeTransfer.amount >= attrs.amount) then need
     check all records by userId and `id_from_transfer` in `StripeTransferReversal`
     take there are amounts summarized and result must be less by `StripeTransfer`.
     You can optionally reversal only part of a transfer. You can do so multiple times,
     until the entire transfer has been reversed.
  2. If created a new `StripeTransferReversal` if summarized more item above return error
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_transfer_reversal()
  end

  @spec seed_stripe_transfer_reversal() :: [Ecto.Schema.t()]
  defp seed_stripe_transfer_reversal do
    user = CoreRepo.get_by(User, %{email: "op@taxgig.com"})
    user_attrs = %{"user_id" => user.id}
    transfer = StripyRepo.get_by(StripeTransfer, %{user_id: user_attrs["user_id"]})
    attrs = %{amount: 900}

    if transfer.amount >= attrs.amount do
      platform_transfer_reversal(transfer.id_from_stripe, attrs, user_attrs)
      case Stripy.Queries.by_sum(StripeTransfer, StripeTransferReversal, :id_from_stripe, :id_from_transfer, :user_id, :amount, transfer.id_from_stripe) do
         [true] -> platform_transfer_reversal(transfer.id_from_stripe, attrs, user_attrs)
        [false] -> {:error, %Ecto.Changeset{}}
          [nil] -> platform_transfer_reversal(transfer.id_from_stripe, attrs, user_attrs)
      end
    else
      {:error, %Ecto.Changeset{}}
    end
  end

  @spec platform_transfer_reversal(String.t(), map, map) ::
          {:ok, StripeTransferReversal.t}
          | {:error, Ecto.Changeset.t}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  defp platform_transfer_reversal(transfer_id, attrs, user_attrs) do
    case Accounts.by_role(user_attrs["user_id"]) do
      true ->
        with {:ok, %StripeTransferReversal{} = data} <- StripePlatformTransferReversalService.create(transfer_id, attrs, user_attrs) do
          {:ok, data}
        else
          nil -> {:error, :not_found}
          failure -> failure
        end
      false -> {:error, %Ecto.Changeset{}}
    end
  end
end

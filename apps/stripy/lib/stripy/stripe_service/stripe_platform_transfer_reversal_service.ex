defmodule Stripy.StripeService.StripePlatformTransferReversalService do
  @moduledoc """
  Work with Stripe transfer_reversal objects.
  Used to perform actions on StripeTransferReversal records.

  Stripe API reference: https://stripe.com/docs/api#transfer_reversal_object
  """

  alias Stripy.{
    Payments,
    Payments.StripeTransferReversal,
    Repo,
    StripeService.Adapters.StripePlatformTransferReversalAdapter
  }

  @doc """
  Creates a new `Stripe.TransferReversal` record on Stripe API, as well as
  an associated local `StripeTransferReversal` record. When you create a new
  reversal, you must specify a transfer tocreate it on.

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


  ## Example

      iex> user_id = FlakeId.get()
      iex> transfer_id = "tr_1HQACVLhtqtNnMeb9Dd0g5Rm"
      iex> user_attrs = %{"user_id" => user_id}
      iex> attrs = %{amount: 45}
      iex> {:ok, transfer_reversal} = create(transfer_id, attrs, user_attrs)

  """
  @spec create(String.t(), map, map) ::
          {:ok, StripeTransferReversal.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(transfer_id, attrs, user_attrs) do
    with {:ok, %Stripe.TransferReversal{} = transfer_reversal} = Stripe.TransferReversal.create(transfer_id, attrs),
         {:ok, params} <- StripePlatformTransferReversalAdapter.to_params(transfer_reversal, user_attrs)
    do
      case Payments.create_stripe_transfer_reversal(params) do
        {:error, error} -> {:error, error}
        {:ok, data} -> {:ok, data}
      end
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end

  @doc """
  Delete `StripeTransferReversal`

  ## Example

      iex> id = "trr_1HjRcK2eZvKYlo2CxLOacpcS"
      iex> {:ok, deleted} = delete(id)

  """
  @spec delete(String.t) ::
          {:ok, StripeTransferReversal.t} |
          {:error, Ecto.Changeset.t} |
          {:error, Stripe.Error.t} |
          {:error, :platform_not_ready} |
          {:error, :not_found}
  def delete(id) do
    with struct <- Repo.get_by(StripeTransferReversal, %{id_from_stripe: id}),
         {:ok, deleted} <- Payments.delete_stripe_transfer_reversal(struct)
    do
      {:ok, deleted}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end
end

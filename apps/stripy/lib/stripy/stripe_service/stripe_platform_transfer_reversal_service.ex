defmodule Stripy.StripeService.StripePlatformTransferReversalService do
  @moduledoc """
  Work with Stripe transfer_reversal objects.
  Used to perform actions on StripeTransferReversal records.

  Stripe API reference: https://stripe.com/docs/api#transfer_reversal_object
  """

  alias Stripy.{
    Payments,
    Payments.StripeTransferReversal,
    StripeService.Adapters.StripePlatformTransferReversalAdapter
  }

  @api Application.get_env(:stripy, :stripe)

  @doc """
  Creates a new `Stripe.TransferReversal` record on Stripe API,
  as well as an associated local `StripeTransferReversal` record

  ## Example

      iex> user_id = FlakeId.get()
      iex> transfer_id = "tr_1HQACVLhtqtNnMeb9Dd0g5Rm"
      iex> user_attrs = %{"user_id" => user_id}
      iex> attrs = %{amount: 45}
      iex> {:ok, transfer_reversal} = Stripe.Transfer.create(transfer_id, attrs)
      iex> {:ok, result} = StripePlatformTransferReversalAdapter.to_params(transfer_reversal, user_attrs)

  """
  @spec create(String.t(), map, map) ::
          {:ok, StripeTransferReversal.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(transfer_id, attrs, user_attrs) do
    with {:ok, %Stripe.TransferReversal{} = transfer_reversal} = @api.TransferReversal.create(transfer_id, attrs),
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
  """
  def delete do
  end
end

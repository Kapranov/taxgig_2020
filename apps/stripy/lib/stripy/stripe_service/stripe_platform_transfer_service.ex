defmodule Stripy.StripeService.StripePlatformTransferService do
  @moduledoc """
  Work with Stripe transfer objects.
  Used to perform actions on StripeTransfer records.

  Stripe API reference: https://stripe.com/docs/api#transfers
  """

  alias Stripy.{
    Payments,
    Payments.StripeTransfer,
    Repo,
    StripeService.Adapters.StripePlatformTransferAdapter
  }

  @doc """
  Creates a new `Stripe.Transfer` record on Stripe API,
  as well as an associated local `StripeTransfer` record

  To send funds from your Stripe account to a connected account, you create a new
  transfer object. Your Stripe balance must be able to cover the transfer amount,
  or you’ll receive an Insufficient Funds error.

  frontend - []
  backend  - [:amount, :destination, :currency]

  1. For create a new `StripeTransfer` check field's `stripe_transfer` by `Core.Project`
     it must be null, it will take field's `project_price` by `Core.Project` and create
     new value (amount = (project.project_price * 0.8 * 100)), result write in field's
     `amount` by `StripeTransfer`. If Trasfer has been successful to update it.
     Transfer can be performed once per Project.
  2. If no data, show error

  ## Example

      iex> user_id = FlakeId.get()
      iex> user_attrs = %{"user_id" => user_id}
      iex> attrs = %{amount: 2000, currency: "usd", destination: "acct_1HhegAKd3U6sXORc"}
      iex> {:ok, transfer} = create(attrs, user_attrs)

  """
  @spec create(%{amount: integer, currency: String.t(), destination: String.t()}, map) ::
          {:ok, StripeTransfer.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(attrs, user_attrs) do
    with {:ok, %Stripe.Transfer{} = transfer} = Stripe.Transfer.create(attrs),
         {:ok, params} <- StripePlatformTransferAdapter.to_params(transfer, user_attrs)
    do
      case Payments.create_stripe_transfer(params) do
        {:error, error} -> {:error, error}
        {:ok, data} -> {:ok, data}
      end
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end

  @doc """
  Delete `StripeTransfer`

  ## Example

      iex> id = "tr_1HmFhN2eZvKYlo2CzqkuA775"
      iex> {:ok, deleted} = delete(id)

  """
  @spec delete(String.t) ::
          {:ok, StripeTransfer.t} |
          {:error, Ecto.Changeset.t} |
          {:error, Stripe.Error.t} |
          {:error, :platform_not_ready} |
          {:error, :not_found}
  def delete(id) do
    with struct <- Repo.get_by(StripeTransfer, %{id_from_stripe: id}),
         {:ok, deleted} <- Payments.delete_stripe_transfer(struct)
    do
      {:ok, deleted}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end
end

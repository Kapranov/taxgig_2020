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

  @api Application.get_env(:stripy, :stripe)

  @doc """
  Creates a new `Stripe.Transfer` record on Stripe API,
  as well as an associated local `StripeTransfer` record

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
    with {:ok, %Stripe.Transfer{} = transfer} = @api.Transfer.create(attrs),
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

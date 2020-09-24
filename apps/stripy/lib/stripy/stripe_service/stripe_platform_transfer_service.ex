defmodule Stripy.StripeService.StripePlatformTransferService do
  @moduledoc """
  Used to perform actions on StripeTransfer records
  """

  alias Stripy.{
    Payments,
    Payments.StripeTransfer,
    StripeService.Adapters.StripePlatformTransferAdapter
  }

  @api Application.get_env(:stripy, :stripe)

  @doc """
  Creates a new `Stripe.Transfer` record on Stripe API, as well as an associated local
  `StripeTransfer` record

  ## Example

      iex> user_id = FlakeId.get()
      iex> attrs = %{"user_id" => user_id}
      iex> transfer_attrs = %{amount: 2000, currency: "usd"}
      iex> {:ok, stripe_transfer} = Stripe.Transfer.create(transfer_attrs)
      iex> {:ok, result} = StripePlatformTransferAdapter.to_params(stripe_transfer, attrs)

  """
  @spec create(map, map) ::
          {:ok, StripeTransfer.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(transfer_attrs, attrs) do
    with {:ok, %Stripe.Refund{} = transfer} = @api.Transfer.create(transfer_attrs),
         {:ok, params} <- StripePlatformTransferAdapter.to_params(transfer, attrs)
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
end

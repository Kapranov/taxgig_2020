defmodule Stripy.StripeService.StripePlatformChargeService do
  @moduledoc """
  Work with [Stripe `charge` objects](https://stripe.com/docs/api/charges).
  Used to perform actions on StripeCharge records.

  You can:
  - [Create a charge](https://stripe.com/docs/api/charges/create)
  - [Update a charge](https://stripe.com/docs/api/charges/update)
  - [Capture a charge](https://stripe.com/docs/api/charges/capture)
  """

  alias Stripy.{
    Payments,
    Payments.StripeCharge,
    Repo,
    StripeService.Adapters.StripePlatformChargeAdapter
  }

  @doc """
  Creates a new `Stripe.Charge` record on Stripe API, as well as
  an associated local `StripeCharge` record

  See the [Stripe docs](https://stripe.com/docs/api/charges/create).

  To charge a credit card or other payment source, you create a Charge object.

  frontend: [:amount, :currency, :description, :capture]
  backend:  [:customer, :source]

  1. Charge can be performed infinite number of times and can charge the same card
  2. If no data, show error

  ## Example

      iex> id_from_card = "card_1HP2frJ2Ju0cX1cPJqmUkzO3"
      iex> id_from_customer = "cus_Hz0iaxWhaRWm6b"
      iex> user_id = FlakeId.get()
      iex> user_attrs = %{"user_id" => user_id, "id_from_card" => id_from_card}
      iex> attrs = %{amount: 2000, currency: "usd", customer: id_from_customer, source: id_from_card, description: "Test description", capture: false}
      iex> {:ok, charged} = create(attrs, user_attrs)

  """
  @spec create(map, map) ::
          {:ok, StripeCharge.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(attrs, user_attrs) do
    with {:ok, %Stripe.Charge{} = charge} = Stripe.Charge.create(attrs),
         {:ok, params} <- StripePlatformChargeAdapter.to_params(charge, user_attrs)
    do
      case Payments.create_stripe_charge(params) do
        {:error, error} -> {:error, error}
        {:ok, data} -> {:ok, data}
      end
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end

  @doc """
  Delete Charge

  ## Example

      iex> id = "ch_1HmHM4LhtqtNnMeb4r1LgOYL"
      iex> {:ok, deleted} = delete(id)

  """
  @spec delete(String.t) ::
          {:ok, StripeCharge.t} |
          {:error, Ecto.Changeset.t} |
          {:error, Stripe.Error.t} |
          {:error, :platform_not_ready} |
          {:error, :not_found}
  def delete(id) do
    with struct <- Repo.get_by(StripeCharge, %{id_from_stripe: id}),
         {:ok, deleted} <- Payments.delete_stripe_charge(struct)
    do
      {:ok, deleted}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end
end

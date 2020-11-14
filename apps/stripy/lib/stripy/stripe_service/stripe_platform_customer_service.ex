defmodule Stripy.StripeService.StripePlatformCustomerService do
  @moduledoc """
  Work with Stripe customer objects.

  You can:

  - Create a customer
  - Update a customer
  - Delete a customer

  Stripe API reference:
  https://stripe.com/docs/api/customers
  https://stripe.com/docs/api/customers/delete
  https://stripe.com/docs/api/customers/update
  """

  alias Stripy.{
    Payments,
    Payments.StripeCardToken,
    Payments.StripeCustomer,
    Queries,
    Repo,
    StripeService.Adapters.StripePlatformCustomerAdapter
  }

  @spec create(map, map) ::
          {:ok, StripeCustomer.t}
          | {:error, Ecto.Changeset.t}
          | {:error, Stripe.Error.t}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  @doc """
  Creates a new `Stripe.Customer` record on Stripe API, as well as an associated local
  `StripeCustomer` single records only via `StripeCardToken` an action

  ## Example

    iex> user_id = FlakeId.get()
    iex> user_attrs = %{"user_id" => user_id}
    iex> attrs = %{email: "v.kobzan@gmail.com", name: "Vlad Kobzan", phone: "563-917-8432", source: "tok_1HKo5YJ2Ju0cX1cPOS2VVTHB"}
    iex> {:ok, customer} = create(attrs, user_attrs)

  """
  def create(attrs, user_attrs) do
    querty =
      try do
        Queries.by_count(StripeCustomer, StripeCardToken, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    with {:ok, %Stripe.Customer{} = customer} = Stripe.Customer.create(attrs),
         {:ok, params} <- StripePlatformCustomerAdapter.to_params(customer, user_attrs)
    do
      case Repo.aggregate(querty, :count, :id) < 1 do
        false -> %StripeCustomer{}
        true ->
          %StripeCustomer{}
          |> StripeCustomer.changeset(params)
          |> Repo.insert
      end
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end

  @doc """
  Delete customer

  When User is deleted, we must delete:
  Stripe API - Stripe.Customer,
  Stripy DB  - StripeCustomer, StripeCardToken, StripeCharge StripeRrefund

  ## Example

      iex> id = "cus_IMlbpTTiZ8thiF"
      iex> {:ok, deleted} = delete(id)

  """
  @spec delete(String.t) ::
          {:ok, StripeCustomer.t} |
          {:error, Ecto.Changeset.t} |
          {:error, Stripe.Error.t} |
          {:error, :platform_not_ready} |
          {:error, :not_found}
  def delete(id) do
    with struct <- Repo.get_by(StripeCustomer, %{id_from_stripe: id}),
         {:ok, _data} <- Stripe.Customer.delete(id),
         {:ok, deleted} <- Payments.delete_stripe_customer(struct)
    do
      {:ok, deleted}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end

  @doc """
  If updated User's fields `[:email, :first_name, :last_name, :middle_name, :phone]`,
  we should updated `Stripe.Customer` and  StripeCustomer`.

  ## Example

      iex> id = "cus_IMlbpTTiZ8thiF"
      iex> attrs = %{email: "edward@yahoo.com", name: "Edward Witten", phone: "555-555-5555"}
      iex> {:ok, updated} = update(id, attrs)

  """
  @spec update(String.t, map) ::
          {:ok, StripeCustomer.t} |
          {:error, Ecto.Changeset.t} |
          {:error, Stripe.Error.t} |
          {:error, :platform_not_ready} |
          {:error, :not_found}
  def update(id, attrs) do
    with struct <- Repo.get_by(StripeCustomer, %{id_from_stripe: id}),
         {:ok, _data} <- Stripe.Customer.update(id, attrs),
         {:ok, updated} <- Payments.update_stripe_customer(struct, attrs)
    do
      {:ok, updated}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end
end

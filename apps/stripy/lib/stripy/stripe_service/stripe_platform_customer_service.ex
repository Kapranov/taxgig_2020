defmodule Stripy.StripeService.StripePlatformCustomerService do
  @moduledoc """
  """

  alias Stripy.{
    Payments.StripeCardToken,
    Payments.StripeCustomer,
    Queries,
    Repo,
    StripeService.Adapters.StripePlatformCustomerAdapter
  }

  @api Application.get_env(:stripy, :stripe)

  @spec create(map, map) :: {:ok, StripeCustomer.t} |
                            {:error, Ecto.Changeset.t} |
                            {:error, Stripe.Error.t} |
                            {:error, :platform_not_ready} |
                            {:error, :not_found}
  @doc """
  Creates a new `Stripe.Customer` record on Stripe API, as well as an associated local
  `StripeCustomer` single records only via `StripeCardToken` an action

  ## Example

    iex> user_id = FlakeId.get()
    iex> user_attrs = %{"user_id" => user_id}
    iex> attrs = ${email: "v.kobzan@gmail.com", name: "Vlad Kobzan", phone: "563-917-8432", source: "tok_1HKo5YJ2Ju0cX1cPOS2VVTHB"}
    iex> {:ok, customer} = Stripe.Customer.create(attrs)
    iex> {:ok, result} = StripePlatformCustomerAdapter.to_params(customer, user_attrs)

  """
  def create(attrs, user_attrs) do
    querty =
      try do
        Queries.by_count(StripeCustomer, StripeCardToken, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    with {:ok, %Stripe.Customer{} = customer} = @api.Customer.create(attrs),
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
end

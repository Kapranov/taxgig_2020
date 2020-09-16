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

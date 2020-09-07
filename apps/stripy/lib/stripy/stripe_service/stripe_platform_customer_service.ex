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
        false -> {:error, %Ecto.Changeset{}}
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

# create customer
#
# attributes = %{"user_id" => user_id}
# {:ok, created_token} = Stripe.Token.create(%{card: card_attrs})
# source = created_token.id
# email = User.find_by(email: "kapranov.lugatex@gmail.com").email
# phone = User.find_by(email: "kapranov.lugatex@gmail.com").phone
# attributes = %{email: email, name: "Oleg G.Kapranov", phone: "999-999-9999", source: source}
# attributes = %{email: email, name: "Oleg G.Kapranov", phone: "999-999-9999", source: card.token}
# {:ok, created_cust} = Stripe.Customer.create(customer_attrs)
# {:ok, result} = Stripy.StripeService.Adapters.StripePlatformCustomerAdapter.to_params(created_cust, attributes)
#
# get and update StripeCardToken
# data1 = Stripy.Payments.get_stripe_card_token!(card.id)
# data2 = %{id_from_customer: customer.stripe_customer_id}
# Stripy.Payments.update_stripe_card_token(data1, data2)

#  def create(%{"stripe_token" => stripe_token, "user_id" => user_id} = attributes) do
#    with %StripeCustomer{} = customer <- StripeCustomer |> Repo.get_by(user_id: user_id),
#         {:ok, %Stripe.Card{} = card} <- @api.Card.create(%{customer: customer.stripe_customer_id, source: stripe_token}),
#         {:ok, params} <- StripePlatformCardAdapter.to_params(card, attributes)
#    do
#      %StripeCardToken{}
#      |> StripeCardToken.changeset(params)
#      |> Repo.insert
#    else
#      nil -> {:error, :not_found}
#      failure -> failure
#    end
#  end
# with
#   %StripeCustomer{} = customer <- StripeCustomer |> Repo.get_by(user_id: user_id),
#   {:ok, %Stripe.Card{} = card} <- @api.Card.create(%{customer: customer.stripe_customer_id, source: stripe_token}),
#   {:ok, params} <- StripePlatformCardAdapter.to_params(card, attributes)
# do
# end
# {:ok, %Stripe.Token{} = card} = @api.Token.create(%{card: card_attrs})

# card_attrs = %{number: 4242424242424242, exp_month: 8, exp_year: 2021, cvc: 314, name: name}
end

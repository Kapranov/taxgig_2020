defmodule Stripy.StripeService.StripePlatformCardService do
  @moduledoc """
  Used to perform actions on StripeCardToken records, while propagating to
  and from associated Stripe.Card records
  """

  alias Stripy.{
    Payments.StripeCardToken,
    Payments.StripeCustomer,
    Repo,
    StripeService.Adapters.StripePlatformCardAdapter
  }

  @api Application.get_env(:stripy, :stripe)

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

# attributes = %{"user_id" => user_id}
# card_attrs = %{number: 4242424242424242, exp_month: 8, exp_year: 2021, cvc: 314, name: "John Wick"}
# {:ok, data} = Stripe.Token.create(%{card: card_attrs})
# {:ok, result} = Stripy.StripeService.Adapters.StripePlatformCardTokenAdapter.to_params(data, attributes)
end

defmodule ServerWeb.Seeder.StripePayout do
  @moduledoc """
  Seeds for `Stripe.Payout` context.
  """

  @doc """
  frontend - [:amount, :currency, destination]
  backend  - [:account]

  user = CoreRepo.get_by(User, %{email: "op@taxgig.com"})
  user_attrs = %{"user_id" => user.id}
  account =  StripyRepo.get_by(StripeAccount, %{user_id: user_attrs["user_id"]}).id_from_stripe
  destination = StripyRepo.get_by(StripeCardToken, %{user_id: user_attrs["user_id"]})

  ## Example

  """
  def create do
#    # minimal amount to payout 10000 => $100.00
#    curl https://api.stripe.com/v1/payouts \
#    -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
#    -H "Stripe-Account: acct_1HPssUC7lbhZAQNr" \
#    -d amount=1100 \
#    -d currency=usd \
#    -d destination=ba_1HQ9pXC7lbhZAQNrtbuVcKUa
#    -d destination=card_1HQ9pXC7lbhZAQNrtbuVcKUa
  end
end

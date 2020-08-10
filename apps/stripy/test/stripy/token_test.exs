defmodule Stripy.TokenTest do
  use Stripy.StripeCase, async: true

  @card {
    number: "4242424242424242",
    exp_month: 11,
    exp_year: 2024,
    cvc: "123"
  }

  describe "create/2" do
    test "creates a card token" do
      assert {:ok, %Stripe.Token{}} = Stripe.Token.create(%{card: @card})
      assert_stripe_requested(:post, "/v1/tokens")
    end
  end
end

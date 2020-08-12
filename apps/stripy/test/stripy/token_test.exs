defmodule Stripy.TokenTest do
  use Stripy.StripeCase, async: true

  @card %{
    number: "4242424242424242",
    exp_month: 11,
    exp_year: 2024,
    cvc: "123"
  }

  @time_now DateTime.now!("Etc/UTC")
  @datetime DateTime.to_unix(@time_now)

  describe "create/2" do
    test "creates a card token" do
      assert {:ok, data} = Stripe.Token.create(%{card: @card})
      assert data.bank_account == nil
      assert data.bank_account == nil
      assert data.client_ip    == "159.224.174.183"
      assert data.created
      assert data.id           =~ "tok_1H"
      assert data.livemode     == false
      assert data.object       == "token"
      assert data.type         == "card"
      assert data.used         == false

      assert data.card.account                  == nil
      assert data.card.address_city             == nil
      assert data.card.address_country          == nil
      assert data.card.address_line1            == nil
      assert data.card.address_line1_check      == nil
      assert data.card.address_line2            == nil
      assert data.card.address_state            == nil
      assert data.card.address_zip              == nil
      assert data.card.address_zip_check        == nil
      assert data.card.available_payout_methods == nil
      assert data.card.brand                    == "Visa"
      assert data.card.country                  == "US"
      assert data.card.currency                 == nil
      assert data.card.customer                 == nil
      assert data.card.cvc_check                == "unchecked"
      assert data.card.default_for_currency     == nil
      assert data.card.deleted                  == nil
      assert data.card.dynamic_last4            == nil
      assert data.card.exp_month                == 11
      assert data.card.exp_year                 == 2024
      assert data.card.fingerprint              =~ "zLa"
      assert data.card.funding                  == "credit"
      assert data.card.id                       =~ "card_1"
      assert data.card.last4                    == "4242"
      assert data.card.metadata                 == %{}
      assert data.card.name                     == nil
      assert data.card.object                   == "card"
      assert data.card.recipient                == nil
      assert data.card.tokenization_method      == nil
      # assert_stripe_requested(:post, "/v1/tokens")
    end
  end
end

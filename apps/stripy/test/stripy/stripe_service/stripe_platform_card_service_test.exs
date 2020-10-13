defmodule Stripy.StripeService.StripePlatformCardServiceTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformCardTokenAdapter,
    StripeService.StripePlatformCardService,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "create" do
    created_card_token = Helpers.load_fixture("card_token")

    assert {:ok, card_token_attrs} = StripePlatformCardTokenAdapter.to_params(created_card_token, @user_attrs)

    assert card_token_attrs["brand"]            == created_card_token.card.brand
    assert card_token_attrs["client_ip"]        == created_card_token.client_ip
    assert card_token_attrs["created"]          == created_card_token.created
    assert card_token_attrs["cvc_check"]        == created_card_token.card.cvc_check
    assert card_token_attrs["exp_month"]        == created_card_token.card.exp_month
    assert card_token_attrs["exp_year"]         == created_card_token.card.exp_year
    assert card_token_attrs["funding"]          == created_card_token.card.funding
    assert card_token_attrs["id_from_customer"] == created_card_token.card.customer
    assert card_token_attrs["id_from_stripe"]   == created_card_token.card.id
    assert card_token_attrs["last4"]            == created_card_token.card.last4
    assert card_token_attrs["name"]             == created_card_token.card.name
    assert card_token_attrs["token"]            == created_card_token.id
    assert card_token_attrs["used"]             == created_card_token.used
    assert card_token_attrs["user_id"]          == @user_attrs["user_id"]

    assert {:ok, card_token} = StripePlatformCardService.create(card_token_attrs, @user_attrs)

    assert card_token.brand            == card_token_attrs["brand"]
    assert card_token.client_ip        == card_token_attrs["client_ip"]
    assert card_token.created          == card_token_attrs["created"]
    assert card_token.cvc_check        == card_token_attrs["cvc_check"]
    assert card_token.exp_month        == card_token_attrs["exp_month"]
    assert card_token.funding          == card_token_attrs["funding"]
    assert card_token.id_from_customer == card_token_attrs["id_from_customer"]
    assert card_token.id_from_stripe   == card_token_attrs["id_from_stripe"]
    assert card_token.last4            == card_token_attrs["last4"]
    assert card_token.name             == card_token_attrs["name"]
    assert card_token.token            == card_token_attrs["token"]
    assert card_token.used             == card_token_attrs["used"]
    assert card_token.user_id          == card_token_attrs["user_id"]
  end
end

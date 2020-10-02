defmodule Stripy.StripeService.Adapters.StripePlatformCardTokenAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformCardTokenAdapter,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "to_params" do
    created_token = Helpers.load_fixture("card_token")
    assert {:ok, result} = StripePlatformCardTokenAdapter.to_params(created_token, @user_attrs)
    assert result["brand"]            == created_token.card.brand
    assert result["client_ip"]        == created_token.client_ip
    assert result["created"]          == created_token.created
    assert result["cvc_check"]        == created_token.card.cvc_check
    assert result["exp_month"]        == created_token.card.exp_month
    assert result["exp_year"]         == created_token.card.exp_year
    assert result["funding"]          == created_token.card.funding
    assert result["id_from_customer"] == created_token.card.customer
    assert result["id_from_stripe"]   == created_token.card.id
    assert result["last4"]            == created_token.card.last4
    assert result["name"]             == created_token.card.name
    assert result["token"]            == created_token.id
    assert result["used"]             == created_token.used
    assert result["user_id"]          == @user_attrs["user_id"]
  end
end

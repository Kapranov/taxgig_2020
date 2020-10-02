defmodule Stripy.StripeService.Adapters.StripePlatformCardTokenAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformCardTokenAdapter,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "to_params" do
    data = Helpers.load_fixture("card_token")
    assert {:ok, result} = StripePlatformCardTokenAdapter.to_params(data, @user_attrs)
    assert result["brand"]            == data.card.brand
    assert result["client_ip"]        == data.client_ip
    assert result["created"]          == data.created
    assert result["cvc_check"]        == data.card.cvc_check
    assert result["exp_month"]        == data.card.exp_month
    assert result["exp_year"]         == data.card.exp_year
    assert result["funding"]          == data.card.funding
    assert result["id_from_customer"] == data.card.customer
    assert result["id_from_stripe"]   == data.card.id
    assert result["last4"]            == data.card.last4
    assert result["name"]             == data.card.name
    assert result["token"]            == data.id
    assert result["used"]             == data.used
    assert result["user_id"]          == @user_attrs["user_id"]
  end
end

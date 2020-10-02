defmodule Stripy.StripeService.Adapters.StripePlatformAccountAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    MapUtils,
    StripeService.Adapters.StripePlatformAccountAdapter,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "to_params" do
    data = Helpers.load_fixture("account")
    assert {:ok, result} = StripePlatformAccountAdapter.to_params(data, @user_attrs)
    assert result["capabilities"]      == MapUtils.keys_to_string(data.capabilities)
    assert result["charges_enabled"]   == data.charges_enabled
    assert result["country"]           == data.country
    assert result["created"]           == data.created
    assert result["default_currency"]  == data.default_currency
    assert result["details_submitted"] == data.details_submitted
    assert result["email"]             == data.email
    assert result["id_from_stripe"]    == data.id
    assert result["payouts_enabled"]   == data.payouts_enabled
    assert result["tos_acceptance"]    == MapUtils.keys_to_string(data.tos_acceptance)
    assert result["type"]              == data.type
    assert result["user_id"]           == @user_attrs["user_id"]
  end
end

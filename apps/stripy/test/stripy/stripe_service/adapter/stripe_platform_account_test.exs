defmodule Stripy.StripeService.Adapters.StripePlatformAccountAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    MapUtils,
    StripeService.Adapters.StripePlatformAccountAdapter,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "to_params" do
    created_account = Helpers.load_fixture("account")
    assert {:ok, result} = StripePlatformAccountAdapter.to_params(created_account, @user_attrs)
    assert result["capabilities"]      == MapUtils.keys_to_string(created_account.capabilities)
    assert result["charges_enabled"]   == created_account.charges_enabled
    assert result["country"]           == created_account.country
    assert result["created"]           == created_account.created
    assert result["default_currency"]  == created_account.default_currency
    assert result["details_submitted"] == created_account.details_submitted
    assert result["email"]             == created_account.email
    assert result["id_from_stripe"]    == created_account.id
    assert result["payouts_enabled"]   == created_account.payouts_enabled
    assert result["tos_acceptance"]    == MapUtils.keys_to_string(created_account.tos_acceptance)
    assert result["type"]              == created_account.type
    assert result["user_id"]           == @user_attrs["user_id"]
  end
end

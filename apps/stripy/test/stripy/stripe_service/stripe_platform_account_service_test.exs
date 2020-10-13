defmodule Stripy.StripeService.StripePlatformAccountServiceTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    MapUtils,
    StripeService.Adapters.StripePlatformAccountAdapter,
    StripeService.StripePlatformAccountService,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "create" do
    assert created_account = Helpers.load_fixture("account")

    assert {:ok, account_attrs} = StripePlatformAccountAdapter.to_params(created_account, @user_attrs)

    assert account_attrs["business_url"]      == created_account.business_profile.url
    assert account_attrs["capabilities"]      == MapUtils.keys_to_string(created_account.capabilities)
    assert account_attrs["charges_enabled"]   == created_account.charges_enabled
    assert account_attrs["country"]           == created_account.country
    assert account_attrs["created"]           == created_account.created
    assert account_attrs["default_currency"]  == created_account.default_currency
    assert account_attrs["details_submitted"] == created_account.details_submitted
    assert account_attrs["email"]             == created_account.email
    assert account_attrs["id_from_stripe"]    == created_account.id
    assert account_attrs["payouts_enabled"]   == created_account.payouts_enabled
    assert account_attrs["tos_acceptance"]    == MapUtils.keys_to_string(created_account.tos_acceptance)
    assert account_attrs["type"]              == created_account.type
    assert account_attrs["user_id"]           == @user_attrs["user_id"]

    assert {:ok, data} = StripePlatformAccountService.create(account_attrs, @user_attrs)

    assert data.business_url      == account_attrs["business_url"]
    assert data.capabilities      == account_attrs["capabilities"]
    assert data.charges_enabled   == account_attrs["charges_enabled"]
    assert data.country           == account_attrs["country"]
    assert data.created           == account_attrs["created"]
    assert data.default_currency  == account_attrs["default_currency"]
    assert data.details_submitted == account_attrs["details_submitted"]
    assert data.email             == account_attrs["email"]
    assert data.id_from_stripe    == account_attrs["id_from_stripe"]
    assert data.payouts_enabled   == account_attrs["payouts_enabled"]
    assert data.tos_acceptance    == account_attrs["tos_acceptance"]
    assert data.type              == account_attrs["type"]
    assert data.user_id           == account_attrs["user_id"]
  end
end

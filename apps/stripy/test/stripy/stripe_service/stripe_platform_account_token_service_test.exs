defmodule Stripy.StripeService.StripePlatformAccountTokenServiceTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformAccountTokenAdapter,
    StripeService.StripePlatformAccountTokenService,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "create" do
    created_account_token = Helpers.load_fixture("account_token")

    assert {:ok, account_token_attrs} = StripePlatformAccountTokenAdapter.to_params(created_account_token, @user_attrs)

    assert account_token_attrs["client_ip"]      == created_account_token.client_ip
    assert account_token_attrs["created"]        == created_account_token.created
    assert account_token_attrs["id_from_stripe"] == created_account_token.id
    assert account_token_attrs["used"]           == created_account_token.used
    assert account_token_attrs["user_id"]        == @user_attrs["user_id"]

    assert {:ok, data} = StripePlatformAccountTokenService.create(account_token_attrs, @user_attrs)

    assert data.client_ip      == account_token_attrs["client_ip"]
    assert data.created        == account_token_attrs["created"]
    assert data.id_from_stripe == account_token_attrs["id_from_stripe"]
    assert data.used           == account_token_attrs["used"]
    assert data.user_id        == account_token_attrs["user_id"]
  end
end

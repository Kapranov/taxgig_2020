defmodule Stripy.StripeService.Adapters.StripePlatformAccountTokenAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformAccountTokenAdapter,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "to_params" do
    created_account_token = Helpers.load_fixture("account_token")
    assert {:ok, result} = StripePlatformAccountTokenAdapter.to_params(created_account_token, @user_attrs)
    assert result["client_ip"]      == created_account_token.client_ip
    assert result["created"]        == created_account_token.created
    assert result["id_from_stripe"] == created_account_token.id
    assert result["used"]           == created_account_token.used
    assert result["user_id"]        == @user_attrs["user_id"]
  end
end

defmodule Stripy.StripeService.Adapters.StripePlatformAccountTokenAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformAccountTokenAdapter,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "to_params" do
    data = Helpers.load_fixture("account_token")
    assert {:ok, result} = StripePlatformAccountTokenAdapter.to_params(data, @user_attrs)
    assert result["client_ip"]      == data.client_ip
    assert result["created"]        == data.created
    assert result["id_from_stripe"] == data.id
    assert result["used"]           == data.used
    assert result["user_id"]        == @user_attrs["user_id"]
  end
end

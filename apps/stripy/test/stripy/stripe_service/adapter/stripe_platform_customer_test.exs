defmodule Stripy.StripeService.Adapters.StripePlatformCustomerAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformCustomerAdapter,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "to_params" do
    data = Helpers.load_fixture("customer")
    assert {:ok, result} = StripePlatformCustomerAdapter.to_params(data, @user_attrs)
    assert result["balance"]        == data.balance
    assert result["created"]        == data.created
    assert result["currency"]       == data.currency
    assert result["email"]          == data.email
    assert result["id_from_stripe"] == data.id
    assert result["name"]           == data.name
    assert result["phone"]          == data.phone
    assert result["user_id"]        == @user_attrs["user_id"]
  end
end

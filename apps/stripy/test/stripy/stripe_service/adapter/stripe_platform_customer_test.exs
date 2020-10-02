defmodule Stripy.StripeService.Adapters.StripePlatformCustomerAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeTesting.Helpers,
    StripeService.Adapters.StripePlatformCustomerAdapter
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "to_params" do
    created_customer = Helpers.load_fixture("customer")
    assert {:ok, result} = StripePlatformCustomerAdapter.to_params(created_customer, @user_attrs)
    assert result["balance"]        == created_customer.balance
    assert result["created"]        == created_customer.created
    assert result["currency"]       == created_customer.currency
    assert result["email"]          == created_customer.email
    assert result["id_from_stripe"] == created_customer.id
    assert result["name"]           == created_customer.name
    assert result["phone"]          == created_customer.phone
    assert result["user_id"]        == @user_attrs["user_id"]
  end
end

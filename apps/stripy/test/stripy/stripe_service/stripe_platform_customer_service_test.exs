defmodule Stripy.StripeService.StripePlatformCustomerServiceTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformCustomerAdapter,
    StripeService.StripePlatformCustomerService,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "create" do
    created_customer = Helpers.load_fixture("customer")

    assert {:ok, customer_attrs} = StripePlatformCustomerAdapter.to_params(created_customer, @user_attrs)

    assert customer_attrs["balance"]        == created_customer.balance
    assert customer_attrs["created"]        == created_customer.created
    assert customer_attrs["currency"]       == created_customer.currency
    assert customer_attrs["email"]          == created_customer.email
    assert customer_attrs["id_from_stripe"] == created_customer.id
    assert customer_attrs["name"]           == created_customer.name
    assert customer_attrs["phone"]          == created_customer.phone
    assert customer_attrs["user_id"]        == @user_attrs["user_id"]

    assert {:ok, customer} = StripePlatformCustomerService.create(customer_attrs, @user_attrs)

    assert customer.balance        == customer_attrs["balance"]
    assert customer.created        == customer_attrs["created"]
    assert customer.currency       == customer_attrs["currency"]
    assert customer.email          == customer_attrs["email"]
    assert customer.id_from_stripe == customer_attrs["id_from_stripe"]
    assert customer.name           == customer_attrs["name"]
    assert customer.phone          == customer_attrs["phone"]
    assert customer.user_id        == customer_attrs["user_id"]
  end
end

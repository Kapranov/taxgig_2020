defmodule Stripy.StripeService.StripePlatformRefundServiceTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformRefundAdapter,
    StripeService.StripePlatformRefundService,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "create" do
    created_refund = Helpers.load_fixture("refund")

    assert {:ok, refund_attrs} = StripePlatformRefundAdapter.to_params(created_refund, @user_attrs)
    
    assert refund_attrs["amount"]              == created_refund.amount
    assert refund_attrs["balance_transaction"] == created_refund.balance_transaction
    assert refund_attrs["created"]             == created_refund.created
    assert refund_attrs["currency"]            == created_refund.currency
    assert refund_attrs["id_from_charge"]      == created_refund.charge
    assert refund_attrs["id_from_stripe"]      == created_refund.id
    assert refund_attrs["status"]              == created_refund.status

    assert {:ok, refund} = StripePlatformRefundService.create(refund_attrs, @user_attrs)

    assert refund.amount              == refund_attrs["amount"]
    assert refund.balance_transaction == refund_attrs["balance_transaction"]
    assert refund.created             == refund_attrs["created"]
    assert refund.currency            == refund_attrs["currency"]
    assert refund.id_from_charge      == refund_attrs["id_from_charge"]
    assert refund.id_from_stripe      == refund_attrs["id_from_stripe"]
    assert refund.status              == refund_attrs["status"]
  end
end

defmodule Stripy.StripeService.Adapters.StripePlatformChargeAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    MapUtils,
    StripeService.Adapters.StripePlatformChargeAdapter,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "to_params" do
    created_charge = Helpers.load_fixture("charge")
    assert {:ok, result} = StripePlatformChargeAdapter.to_params(created_charge, @user_attrs)
    assert result["amount"]           == created_charge.amount
    assert result["amount_refunded"]  == created_charge.amount_refunded
    assert result["captured"]         == created_charge.captured
    assert result["created"]          == created_charge.created
    assert result["currency"]         == created_charge.currency
    assert result["description"]      == created_charge.description
    assert result["failure_code"]     == created_charge.failure_code
    assert result["failure_message"]  == created_charge.failure_message
    assert result["fraud_details"]    == created_charge.fraud_details
    assert result["id_from_customer"] == created_charge.customer
    assert result["id_from_stripe"]   == created_charge.id
    assert result["outcome"]          == MapUtils.keys_to_string(created_charge.outcome)
    assert result["receipt_url"]      == created_charge.receipt_url
    assert result["status"]           == created_charge.status
    assert result["user_id"]          == @user_attrs["user_id"]
  end
end

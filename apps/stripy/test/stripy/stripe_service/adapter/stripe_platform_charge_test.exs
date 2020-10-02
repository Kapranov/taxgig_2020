defmodule Stripy.StripeService.Adapters.StripePlatformChargeAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    MapUtils,
    StripeService.Adapters.StripePlatformChargeAdapter,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "to_params" do
    data = Helpers.load_fixture("charge")
    assert {:ok, result} = StripePlatformChargeAdapter.to_params(data, @user_attrs)
    assert result["amount"]           == data.amount
    assert result["amount_refunded"]  == data.amount_refunded
    assert result["captured"]         == data.captured
    assert result["created"]          == data.created
    assert result["currency"]         == data.currency
    assert result["description"]      == data.description
    assert result["failure_code"]     == data.failure_code
    assert result["failure_message"]  == data.failure_message
    assert result["fraud_details"]    == data.fraud_details
    assert result["id_from_customer"] == data.customer
    assert result["id_from_stripe"]   == data.id
    assert result["outcome"]          == MapUtils.keys_to_string(data.outcome)
    assert result["receipt_url"]      == data.receipt_url
    assert result["status"]           == data.status
    assert result["user_id"]          == @user_attrs["user_id"]
  end
end

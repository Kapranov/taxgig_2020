defmodule Stripy.StripeService.StripePlatformChargeServiceTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    MapUtils,
    StripeService.Adapters.StripePlatformChargeAdapter,
    StripeService.StripePlatformChargeService,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get()}

  test "create" do
    created_charge = Helpers.load_fixture("charge")

    assert {:ok, charge_attrs} = StripePlatformChargeAdapter.to_params(created_charge, @user_attrs)

    assert charge_attrs["amount"]           == created_charge.amount
    assert charge_attrs["amount_refunded"]  == created_charge.amount_refunded
    assert charge_attrs["captured"]         == created_charge.captured
    assert charge_attrs["created"]          == created_charge.created
    assert charge_attrs["currency"]         == created_charge.currency
    assert charge_attrs["description"]      == created_charge.description
    assert charge_attrs["failure_code"]     == created_charge.failure_code
    assert charge_attrs["failure_message"]  == created_charge.failure_message
    assert charge_attrs["fraud_details"]    == created_charge.fraud_details
    assert charge_attrs["id_from_customer"] == created_charge.customer
    assert charge_attrs["id_from_stripe"]   == created_charge.id
    assert charge_attrs["outcome"]          == MapUtils.keys_to_string(created_charge.outcome)
    assert charge_attrs["receipt_url"]      == created_charge.receipt_url
    assert charge_attrs["status"]           == created_charge.status
    assert charge_attrs["user_id"]          == @user_attrs["user_id"]
  end
end

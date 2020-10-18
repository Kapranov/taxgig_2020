defmodule Stripy.StripeService.StripePlatformChargeServiceTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    MapUtils,
    StripeService.Adapters.StripePlatformChargeAdapter,
    StripeService.StripePlatformChargeService,
    StripeTesting.Helpers
  }

  @attrs %{"user_id" => FlakeId.get, "id_from_card" => "card_1032D82eZvKYlo2C8vPJ6A5c"}

  test "create" do
    created_charge = Helpers.load_fixture("charge")

    assert {:ok, charge_attrs} = StripePlatformChargeAdapter.to_params(created_charge, @attrs)

    assert charge_attrs["amount"]           == created_charge.amount
    assert charge_attrs["amount_refunded"]  == created_charge.amount_refunded
    assert charge_attrs["captured"]         == created_charge.captured
    assert charge_attrs["created"]          == created_charge.created
    assert charge_attrs["currency"]         == created_charge.currency
    assert charge_attrs["description"]      == created_charge.description
    assert charge_attrs["failure_code"]     == created_charge.failure_code
    assert charge_attrs["failure_message"]  == created_charge.failure_message
    assert charge_attrs["fraud_details"]    == created_charge.fraud_details
    assert charge_attrs["id_from_card"]     == @attrs["id_from_card"]
    assert charge_attrs["id_from_customer"] == created_charge.customer
    assert charge_attrs["id_from_stripe"]   == created_charge.id
    assert charge_attrs["outcome"]          == MapUtils.keys_to_string(created_charge.outcome)
    assert charge_attrs["receipt_url"]      == created_charge.receipt_url
    assert charge_attrs["status"]           == created_charge.status
    assert charge_attrs["user_id"]          == @attrs["user_id"]

    assert {:ok, data} = StripePlatformChargeService.create(charge_attrs, @attrs)
    
    assert data.amount           == charge_attrs["amount"]
    assert data.amount_refunded  == charge_attrs["amount_refunded"]
    assert data.captured         == charge_attrs["captured"]
    assert data.created          == charge_attrs["created"]
    assert data.currency         == charge_attrs["currency"]
    assert data.description      == charge_attrs["description"]
    assert data.failure_code     == charge_attrs["failure_code"]
    assert data.failure_message  == charge_attrs["failure_message"]
    assert data.fraud_details    == charge_attrs["fraud_details"]
    assert data.id_from_card     == charge_attrs["id_from_card"]
    assert data.id_from_customer == charge_attrs["id_from_customer"]
    assert data.id_from_stripe   == charge_attrs["id_from_stripe"]
    assert data.outcome          == charge_attrs["outcome"]
    assert data.receipt_url      == charge_attrs["receipt_url"]
    assert data.status           == charge_attrs["status"]
    assert data.user_id          == charge_attrs["user_id"]
  end
end

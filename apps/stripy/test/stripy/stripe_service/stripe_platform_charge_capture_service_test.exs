defmodule Stripy.StripeService.StripePlatformChargeCaptureServiceTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformChargeCaptureAdapter,
    StripeService.StripePlatformChargeService,
    StripeTesting.Helpers
  }

  @charge_attrs %{
    "id_from_card" => FlakeId.get,
    "user_id" => FlakeId.get
  }

  test "create" do
    created_charge = Helpers.load_fixture("charge")
    assert {:ok, charge} = StripePlatformChargeService.create(created_charge, @charge_attrs)

    created_charge_capture = Helpers.load_fixture("charge_capture")

    assert {:ok, charge_capture_attrs} = StripePlatformChargeCaptureAdapter.to_params(created_charge_capture)

    assert charge_capture_attrs["amount"]          == created_charge_capture.amount
    assert charge_capture_attrs["captured"]        == created_charge_capture.captured
    assert charge_capture_attrs["created"]         == created_charge_capture.created
    assert charge_capture_attrs["failure_code"]    == created_charge_capture.failure_code
    assert charge_capture_attrs["failure_message"] == created_charge_capture.failure_message
    assert charge_capture_attrs["fraud_details"]   == created_charge_capture.fraud_details
    assert charge_capture_attrs["id_from_stripe"]  == created_charge_capture.id
    assert charge_capture_attrs["status"]          == created_charge_capture.status
  end
end

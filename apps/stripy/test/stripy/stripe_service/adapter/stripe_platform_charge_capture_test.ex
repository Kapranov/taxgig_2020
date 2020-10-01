defmodule Stripy.StripeService.Adapters.StripePlatformChargeCaptureAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformChargeCaptureAdapter,
    StripeTesting.Helpers
  }

  test "to_params" do
    created_charge_capture = Helpers.load_fixture("charge_capture")
    assert {:ok, result} = StripePlatformChargeCaptureAdapter.to_params(created_charge_capture)
    assert result["amount"]          == created_charge_capture.amount
    assert result["captured"]        == created_charge_capture.captured
    assert result["created"]         == created_charge_capture.created
    assert result["failure_code"]    == created_charge_capture.failure_code
    assert result["failure_message"] == created_charge_capture.failure_message
    assert result["fraud_details"]   == created_charge_capture.fraud_details
    assert result["id_from_stripe"]  == created_charge_capture.id
    assert result["status"]          == created_charge_capture.status
  end
end

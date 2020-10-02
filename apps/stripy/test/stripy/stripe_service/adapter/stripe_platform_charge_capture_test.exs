defmodule Stripy.StripeService.Adapters.StripePlatformChargeCaptureAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformChargeCaptureAdapter,
    StripeTesting.Helpers
  }

  test "to_params" do
    data = Helpers.load_fixture("charge_capture")
    assert {:ok, result} = StripePlatformChargeCaptureAdapter.to_params(data)
    assert result["amount"]          == data.amount
    assert result["captured"]        == data.captured
    assert result["created"]         == data.created
    assert result["failure_code"]    == data.failure_code
    assert result["failure_message"] == data.failure_message
    assert result["fraud_details"]   == data.fraud_details
    assert result["id_from_stripe"]  == data.id
    assert result["status"]          == data.status
  end
end

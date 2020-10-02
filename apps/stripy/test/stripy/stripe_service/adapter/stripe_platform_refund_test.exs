defmodule Stripy.StripeService.Adapters.StripePlatformRefundAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformRefundAdapter,
    StripeTesting.Helpers
  }

  test "to_params" do
    data = Helpers.load_fixture("refund")
    assert {:ok, result} = StripePlatformRefundAdapter.to_params(data, %{})
    assert result["amount"]              == data.amount
    assert result["balance_transaction"] == data.balance_transaction
    assert result["created"]             == data.created
    assert result["currency"]            == data.currency
    assert result["id_from_charge"]      == data.charge
    assert result["id_from_stripe"]      == data.id
    assert result["status"]              == data.status
  end
end

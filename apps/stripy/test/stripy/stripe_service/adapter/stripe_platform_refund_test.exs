defmodule Stripy.StripeService.Adapters.StripePlatformRefundAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformRefundAdapter,
    StripeTesting.Helpers
  }

  test "to_params" do
    created_refund = Helpers.load_fixture("refund")
    assert {:ok, result} = StripePlatformRefundAdapter.to_params(created_refund, %{})
    assert result["amount"]              == created_refund.amount
    assert result["balance_transaction"] == created_refund.balance_transaction
    assert result["created"]             == created_refund.created
    assert result["currency"]            == created_refund.currency
    assert result["id_from_charge"]      == created_refund.charge
    assert result["id_from_stripe"]      == created_refund.id
    assert result["status"]              == created_refund.status
  end
end

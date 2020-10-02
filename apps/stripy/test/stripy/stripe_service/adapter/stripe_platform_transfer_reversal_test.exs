defmodule Stripy.StripeService.Adaptes.StripePlatformTransferReversalAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformTransferReversalAdapter,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "to_params" do
    data = Helpers.load_fixture("transfer_reversal")
    assert {:ok, result} = StripePlatformTransferReversalAdapter.to_params(data, @user_attrs)
    assert result["amount"]                     == data.amount
    assert result["balance_transaction"]        == data.balance_transaction
    assert result["created"]                    == data.created
    assert result["currency"]                   == data.currency
    assert result["destination_payment_refund"] == data.destination_payment_refund
    assert result["id_from_stripe"]             == data.id
    assert result["id_from_transfer"]           == data.transfer
    assert result["user_id"]                    == @user_attrs["user_id"]
  end
end

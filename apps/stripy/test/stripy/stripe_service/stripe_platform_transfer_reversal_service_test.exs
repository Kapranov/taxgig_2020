defmodule Stripy.StripeService.StripePlatformTransferReversalServiceTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformTransferReversalAdapter,
    StripeService.StripePlatformTransferReversalService,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "create" do
  	created_transfer = Helpers.load_fixture("transfer")
    created_transfer_reversal = Helpers.load_fixture("transfer_reversal")

    assert {:ok, transfer_reversal_attrs} = StripePlatformTransferReversalAdapter.to_params(created_transfer_reversal, @user_attrs)

    assert transfer_reversal_attrs["amount"]                     == created_transfer_reversal.amount
    assert transfer_reversal_attrs["balance_transaction"]        == created_transfer_reversal.balance_transaction
    assert transfer_reversal_attrs["created"]                    == created_transfer_reversal.created
    assert transfer_reversal_attrs["currency"]                   == created_transfer_reversal.currency
    assert transfer_reversal_attrs["destination_payment_refund"] == created_transfer_reversal.destination_payment_refund
    assert transfer_reversal_attrs["id_from_stripe"]             == created_transfer_reversal.id
    assert transfer_reversal_attrs["id_from_transfer"]           == created_transfer_reversal.transfer
    assert transfer_reversal_attrs["user_id"]                    == @user_attrs["user_id"]

    assert {:ok, transfer_reversal} = StripePlatformTransferReversalService.create(created_transfer.id, transfer_reversal_attrs, @user_attrs)

    assert transfer_reversal.amount                     == transfer_reversal_attrs["amount"]
    assert transfer_reversal.balance_transaction        == transfer_reversal_attrs["balance_transaction"]
    assert transfer_reversal.created                    == transfer_reversal_attrs["created"]
    assert transfer_reversal.currency                   == transfer_reversal_attrs["currency"]
    assert transfer_reversal.destination_payment_refund == transfer_reversal_attrs["destination_payment_refund"]
    assert transfer_reversal.id_from_stripe             == transfer_reversal_attrs["id_from_stripe"]
    assert transfer_reversal.id_from_transfer           == transfer_reversal_attrs["id_from_transfer"]
    assert transfer_reversal.user_id                    == transfer_reversal_attrs["user_id"]
  end
end

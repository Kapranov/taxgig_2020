defmodule Stripy.StripeService.StripePlatformTransferServiceTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformTransferAdapter,
    StripeService.StripePlatformTransferService,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "create" do
    created_transfer = Helpers.load_fixture("transfer")

    assert {:ok, transfer_attrs} = StripePlatformTransferAdapter.to_params(created_transfer, @user_attrs)

    assert transfer_attrs["amount"]              == created_transfer.amount
    assert transfer_attrs["amount_reversed"]     == created_transfer.amount_reversed
    assert transfer_attrs["balance_transaction"] == created_transfer.balance_transaction
    assert transfer_attrs["created"]             == created_transfer.created
    assert transfer_attrs["currency"]            == created_transfer.currency
    assert transfer_attrs["destination"]         == created_transfer.destination
    assert transfer_attrs["destination_payment"] == created_transfer.destination_payment
    assert transfer_attrs["id_from_stripe"]      == created_transfer.id
    assert transfer_attrs["reversed"]            == created_transfer.reversed
    assert transfer_attrs["source_type"]         == created_transfer.source_type
    assert transfer_attrs["user_id"]             == @user_attrs["user_id"]

    assert {:ok, transfer} = StripePlatformTransferService.create(transfer_attrs, @user_attrs)

    assert transfer.amount              == transfer_attrs["amount"]
    assert transfer.amount_reversed     == transfer_attrs["amount_reversed"]
    assert transfer.balance_transaction == transfer_attrs["balance_transaction"]
    assert transfer.created             == transfer_attrs["created"]
    assert transfer.currency            == transfer_attrs["currency"]
    assert transfer.destination         == transfer_attrs["destination"]
    assert transfer.destination_payment == transfer_attrs["destination_payment"]
    assert transfer.id_from_stripe      == transfer_attrs["id_from_stripe"]
    assert transfer.reversed            == transfer_attrs["reversed"]
    assert transfer.source_type         == transfer_attrs["source_type"]
    assert transfer.user_id             == transfer_attrs["user_id"]
  end
end

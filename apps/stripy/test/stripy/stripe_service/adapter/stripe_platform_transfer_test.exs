defmodule Stripy.StripeService.Adaptes.StripePlatformTransferAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformTransferAdapter,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "to_params" do
    data = Helpers.load_fixture("transfer")
    assert {:ok, result} = StripePlatformTransferAdapter.to_params(data, @user_attrs)
    assert result["amount"]              == data.amount
    assert result["amount_reversed"]     == data.amount_reversed
    assert result["balance_transaction"] == data.balance_transaction
    assert result["created"]             == data.created
    assert result["currency"]            == data.currency
    assert result["destination"]         == data.destination
    assert result["destination_payment"] == data.destination_payment
    assert result["id_from_stripe"]      == data.id
    assert result["reversed"]            == data.reversed
    assert result["source_type"]         == data.source_type
    assert result["user_id"]             == @user_attrs["user_id"]
  end
end

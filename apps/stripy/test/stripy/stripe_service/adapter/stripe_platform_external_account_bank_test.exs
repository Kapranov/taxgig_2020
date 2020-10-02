defmodule Stripy.StripeService.Adapters.StripePlatformExternalAccountBankAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformExternalAccountBankAdapter,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "to_params" do
    data = Helpers.load_fixture("external_account_bank")
    assert {:ok, result} = StripePlatformExternalAccountBankAdapter.to_params(data, @user_attrs)
    assert result["account_holder_name"] == data.account_holder_name
    assert result["account_holder_type"] == data.account_holder_type
    assert result["bank_name"]           == data.bank_name
    assert result["country"]             == data.country
    assert result["currency"]            == data.currency
    assert result["fingerprint"]         == data.fingerprint
    assert result["id_from_account"]     == data.account
    assert result["id_from_stripe"]      == data.id
    assert result["last4"]               == data.last4
    assert result["routing_number"]      == data.routing_number
    assert result["status"]              == data.status
    assert result["user_id"]             == @user_attrs["user_id"]
  end
end

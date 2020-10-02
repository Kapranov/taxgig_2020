defmodule Stripy.StripeService.Adapters.StripePlatformBankAccountTokenAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformBankAccountTokenAdapter,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "to_params" do
    data = Helpers.load_fixture("bank_account_token")
    assert {:ok, result} = StripePlatformBankAccountTokenAdapter.to_params(data, @user_attrs)
    assert result["account_holder_name"]  == data.bank_account.account_holder_name
    assert result["account_holder_type"]  == data.bank_account.account_holder_type
    assert result["bank_name"]            == data.bank_account.bank_name
    assert result["client_ip"]            == data.client_ip
    assert result["country"]              == data.bank_account.country
    assert result["created"]              == data.created
    assert result["currency"]             == data.bank_account.currency
    assert result["fingerprint"]          == data.bank_account.fingerprint
    assert result["id_from_bank_account"] == data.bank_account.id
    assert result["last4"]                == data.bank_account.last4
    assert result["routing_number"]       == data.bank_account.routing_number
    assert result["status"]               == data.bank_account.status
    assert result["used"]                 == data.used
    assert result["user_id"]              == @user_attrs["user_id"]
  end
end

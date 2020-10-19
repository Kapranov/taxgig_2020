defmodule Stripy.StripeService.StripePlatformExternalAccountBankServiceTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformExternalAccountBankAdapter,
    StripeService.StripePlatformExternalAccountBankService,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "" do
    created_external_account_bank = Helpers.load_fixture("external_account_bank")

    assert {:ok, external_account_bank_attrs} = StripePlatformExternalAccountBankAdapter.to_params(created_external_account_bank, @user_attrs)

    assert external_account_bank_attrs["account_holder_name"] == created_external_account_bank.account_holder_name
    assert external_account_bank_attrs["account_holder_type"] == created_external_account_bank.account_holder_type
    assert external_account_bank_attrs["bank_name"]           == created_external_account_bank.bank_name
    assert external_account_bank_attrs["country"]             == created_external_account_bank.country
    assert external_account_bank_attrs["currency"]            == created_external_account_bank.currency
    assert external_account_bank_attrs["fingerprint"]         == created_external_account_bank.fingerprint
    assert external_account_bank_attrs["id_from_account"]     == created_external_account_bank.account
    assert external_account_bank_attrs["id_from_stripe"]      == created_external_account_bank.id
    assert external_account_bank_attrs["last4"]               == created_external_account_bank.last4
    assert external_account_bank_attrs["routing_number"]      == created_external_account_bank.routing_number
    assert external_account_bank_attrs["status"]              == created_external_account_bank.status
    assert external_account_bank_attrs["user_id"]             == @user_attrs["user_id"]

    assert {:ok, external_account_bank} = StripePlatformExternalAccountBankService.create(external_account_bank_attrs, @user_attrs)

    assert external_account_bank.account_holder_name == external_account_bank_attrs["account_holder_name"]
    assert external_account_bank.account_holder_type == external_account_bank_attrs["account_holder_type"]
    assert external_account_bank.bank_name           == external_account_bank_attrs["bank_name"]
    assert external_account_bank.country             == external_account_bank_attrs["country"]
    assert external_account_bank.currency            == external_account_bank_attrs["currency"]
    assert external_account_bank.fingerprint         == external_account_bank_attrs["fingerprint"]
    assert external_account_bank.id_from_account     == external_account_bank_attrs["id_from_account"]
    assert external_account_bank.id_from_stripe      == external_account_bank_attrs["id_from_stripe"]
    assert external_account_bank.last4               == external_account_bank_attrs["last4"]
    assert external_account_bank.routing_number      == external_account_bank_attrs["routing_number"]
    assert external_account_bank.status              == external_account_bank_attrs["status"]
    assert external_account_bank.user_id             == external_account_bank_attrs["user_id"]
  end
end

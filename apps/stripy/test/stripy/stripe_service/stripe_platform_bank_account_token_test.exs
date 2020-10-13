defmodule Stripy.StripeService.StripePlatformBankAccountTokenServiceTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformBankAccountTokenAdapter,
    StripeService.StripePlatformBankAccountTokenService,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get()}

  test "create" do
    created_bank_account_token = Helpers.load_fixture("bank_account_token")

    assert {:ok, bank_account_token_attrs} =
             StripePlatformBankAccountTokenAdapter.to_params(
               created_bank_account_token,
               @user_attrs
             )

    assert bank_account_token_attrs["account_holder_name"]  == created_bank_account_token.bank_account.account_holder_name
    assert bank_account_token_attrs["account_holder_type"]  == created_bank_account_token.bank_account.account_holder_type
    assert bank_account_token_attrs["bank_name"]            == created_bank_account_token.bank_account.bank_name
    assert bank_account_token_attrs["client_ip"]            == created_bank_account_token.client_ip
    assert bank_account_token_attrs["country"]              == created_bank_account_token.bank_account.country
    assert bank_account_token_attrs["created"]              == created_bank_account_token.created
    assert bank_account_token_attrs["currency"]             == created_bank_account_token.bank_account.currency
    assert bank_account_token_attrs["fingerprint"]          == created_bank_account_token.bank_account.fingerprint
    assert bank_account_token_attrs["id_from_bank_account"] == created_bank_account_token.bank_account.id
    assert bank_account_token_attrs["last4"]                == created_bank_account_token.bank_account.last4
    assert bank_account_token_attrs["routing_number"]       == created_bank_account_token.bank_account.routing_number
    assert bank_account_token_attrs["status"]               == created_bank_account_token.bank_account.status
    assert bank_account_token_attrs["used"]                 == created_bank_account_token.used
    assert bank_account_token_attrs["user_id"]              == @user_attrs["user_id"]

    assert {:ok, bank_account_token} = StripePlatformBankAccountTokenService.create(bank_account_token_attrs, @user_attrs)

    assert bank_account_token.account_holder_name  == bank_account_token_attrs["account_holder_name"]
    assert bank_account_token.account_holder_type  == bank_account_token_attrs["account_holder_type"]
    assert bank_account_token.bank_name            == bank_account_token_attrs["bank_name"]
    assert bank_account_token.client_ip            == bank_account_token_attrs["client_ip"]
    assert bank_account_token.country              == bank_account_token_attrs["country"]
    assert bank_account_token.created              == bank_account_token_attrs["created"]
    assert bank_account_token.currency             == bank_account_token_attrs["currency"]
    assert bank_account_token.fingerprint          == bank_account_token_attrs["fingerprint"]
    assert bank_account_token.id_from_bank_account == bank_account_token_attrs["id_from_bank_account"]
    assert bank_account_token.last4                == bank_account_token_attrs["last4"]
    assert bank_account_token.routing_number       == bank_account_token_attrs["routing_number"]
    assert bank_account_token.status               == bank_account_token_attrs["status"]
    assert bank_account_token.used                 == bank_account_token_attrs["used"]
    assert bank_account_token.user_id              == bank_account_token_attrs["user_id"]
  end
end

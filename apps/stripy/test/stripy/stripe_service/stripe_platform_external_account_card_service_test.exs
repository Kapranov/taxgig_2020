defmodule Stripy.StripeService.StripePlatformExternalAccountCardServiceTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformExternalAccountCardAdapter,
    StripeService.StripePlatformExternalAccountCardService,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "create" do
    created_external_account_card = Helpers.load_fixture("external_account_card")

    assert {:ok, external_account_card_attrs} = StripePlatformExternalAccountCardAdapter.to_params(created_external_account_card, @user_attrs)

    assert external_account_card_attrs["brand"]                == created_external_account_card.brand
    assert external_account_card_attrs["country"]              == created_external_account_card.country
    assert external_account_card_attrs["currency"]             == created_external_account_card.currency
    assert external_account_card_attrs["cvc_check"]            == created_external_account_card.cvc_check
    assert external_account_card_attrs["default_for_currency"] == created_external_account_card.default_for_currency
    assert external_account_card_attrs["exp_month"]            == created_external_account_card.exp_month
    assert external_account_card_attrs["exp_year"]             == created_external_account_card.exp_year
    assert external_account_card_attrs["fingerprint"]          == created_external_account_card.fingerprint
    assert external_account_card_attrs["funding"]              == created_external_account_card.funding
    assert external_account_card_attrs["id_from_account"]      == created_external_account_card.account
    assert external_account_card_attrs["id_from_stripe"]       == created_external_account_card.id
    assert external_account_card_attrs["last4"]                == created_external_account_card.last4
    assert external_account_card_attrs["name"]                 == created_external_account_card.name
    assert external_account_card_attrs["user_id"]              == @user_attrs["user_id"]

    {:ok, external_account_card} = StripePlatformExternalAccountCardService.create(external_account_card_attrs, @user_attrs)

    assert external_account_card.brand                == external_account_card_attrs["brand"]
    assert external_account_card.country              == external_account_card_attrs["country"]
    assert external_account_card.currency             == external_account_card_attrs["currency"]
    assert external_account_card.cvc_check            == external_account_card_attrs["cvc_check"]
    assert external_account_card.default_for_currency == external_account_card_attrs["default_for_currency"]
    assert external_account_card.exp_month            == external_account_card_attrs["exp_month"]
    assert external_account_card.exp_year             == external_account_card_attrs["exp_year"]
    assert external_account_card.fingerprint          == external_account_card_attrs["fingerprint"]
    assert external_account_card.funding              == external_account_card_attrs["funding"]
    assert external_account_card.id_from_account      == external_account_card_attrs["id_from_account"]
    assert external_account_card.id_from_stripe       == external_account_card_attrs["id_from_stripe"]
    assert external_account_card.last4                == external_account_card_attrs["last4"]
    assert external_account_card.name                 == external_account_card_attrs["name"]
    assert external_account_card.user_id              == external_account_card_attrs["user_id"]
  end
end

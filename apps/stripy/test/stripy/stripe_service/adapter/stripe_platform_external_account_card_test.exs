defmodule Stripy.StripeService.Adapters.StripePlatformExternalAccountCardAdapterTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    StripeService.Adapters.StripePlatformExternalAccountCardAdapter,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}

  test "to_params" do
    data = Helpers.load_fixture("external_account_card")
    assert {:ok, result} = StripePlatformExternalAccountCardAdapter.to_params(data, @user_attrs)
    assert result["brand"]                == data.brand
    assert result["country"]              == data.country
    assert result["currency"]             == data.currency
    assert result["cvc_check"]            == data.cvc_check
    assert result["default_for_currency"] == data.default_for_currency
    assert result["exp_month"]            == data.exp_month
    assert result["exp_year"]             == data.exp_year
    assert result["fingerprint"]          == data.fingerprint
    assert result["funding"]              == data.funding
    assert result["id_from_account"]      == data.account
    assert result["id_from_stripe"]       == data.id
    assert result["last4"]                == data.last4
    assert result["name"]                 == data.name
    assert result["user_id"]              == @user_attrs["user_id"]
  end
end

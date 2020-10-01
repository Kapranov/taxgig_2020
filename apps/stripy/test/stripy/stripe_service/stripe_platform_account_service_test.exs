#defmodule Stripy.StripeServices.StripePlatformAccountServiceTest do
#  use Stripy.StripeCase, async: true
#
#  alias Stripy.StripeService.StripePlatformAccountService
#
#  test "is creatable" do
#    user_attrs = %{"user_id" => FlakeId.get()}
#
#    account_attrs = %{
#      account_token: "ct_1HPsraLhtqtNnMebPsawyFas",
#      business_profile: %{
#        mcc: 8931,
#        url: "https://taxgig.com"
#      },
#      capabilities: %{
#        card_payments: %{
#          requested: true
#        },
#        transfers: %{
#          requested: true
#        }
#      },
#      settings: %{
#        payouts: %{
#          schedule: %{
#            interval: "manual"
#          }
#        }
#      }
#    }
#
#    assert {:ok, _} = StripePlatformAccountService.create(account_attrs, user_attrs)
#  end
#end

defmodule Stripy.StripeServices.StripePlatformAccountServiceTest do
  use Stripy.StripeCase, async: true

  alias Stripy.{
    MapUtils,
    StripeService.Adapters.StripePlatformAccountAdapter,
    StripeService.StripePlatformAccountService,
    StripeTesting.Helpers
  }

  @user_attrs %{"user_id" => FlakeId.get}
  @account_attrs %{
    account_token: "ct_1HPsraLhtqtNnMebPsawyFas",
    business_profile: %{
      mcc: 8931,
      url: "https://taxgig.com"
    },
    capabilities: %{
      card_payments: %{
        requested: true
      },
      transfers: %{
        requested: true
      }
    },
    settings: %{
      payouts: %{
        schedule: %{
          interval: "manual"
        }
      }
    }
  }

  test "create" do
    assert created_account = Helpers.load_fixture("account")
    assert {:ok, account_attrs} = StripePlatformAccountAdapter.to_params(created_account, @user_attrs)
    assert account_attrs["capabilities"]      == MapUtils.keys_to_string(created_account.capabilities)
    assert account_attrs["charges_enabled"]   == created_account.charges_enabled
    assert account_attrs["country"]           == created_account.country
    assert account_attrs["created"]           == created_account.created
    assert account_attrs["default_currency"]  == created_account.default_currency
    assert account_attrs["details_submitted"] == created_account.details_submitted
    assert account_attrs["email"]             == created_account.email
    assert account_attrs["id_from_stripe"]    == created_account.id
    assert account_attrs["payouts_enabled"]   == created_account.payouts_enabled
    assert account_attrs["tos_acceptance"]    == MapUtils.keys_to_string(created_account.tos_acceptance)
    assert account_attrs["type"]              == created_account.type
    assert account_attrs["user_id"]           == @user_attrs["user_id"]
    # assert {:ok, data} = StripePlatformAccountService.create(account_attrs, @user_attrs)
    # assert {:ok, data} = StripePlatformAccountService.create(@account_attrs, @user_attrs)
    # assert data == %{}
  end
end

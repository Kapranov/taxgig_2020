defmodule Stripy.StripeServices.StripePlatformAccountServiceTest do
  use Stripy.StripeCase, async: true

  alias Stripy.StripeService.StripePlatformAccountService

  test "is creatable" do
    user_attrs = %{"user_id" => FlakeId.get()}

    account_attrs = %{
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

    assert {:ok, _} = StripePlatformAccountService.create(account_attrs, user_attrs)
  end
end

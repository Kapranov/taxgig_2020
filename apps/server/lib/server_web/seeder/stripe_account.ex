defmodule ServerWeb.Seeder.StripeAccount do
  @moduledoc """
  Seeds for `Stripy.StripeAccount` context.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Queries
  }

  alias Stripy.{
    Payments.StripeAccount,
    Payments.StripeAccountToken,
    StripeService.StripePlatformAccountService
  }

  alias Core.Repo, as: CoreRepo
  alias Stripy.Repo, as: StripyRepo

  @country "US"
  @mcc 8931
  @requested true
  @settings "manual"
  @type_field "custom"
  @url "https://taxgig.com"

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeAccount)
  end

  @doc """
  Used to create a remote `Stripe.Account` record as well as
  an associated local `StripeAccount` record.
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_account()
  end

  @spec seed_stripe_account() :: [Ecto.Schema.t()]
  defp seed_stripe_account do
    user = CoreRepo.get_by(User, %{email: "op@taxgig.com"})
    user_attrs = %{"user_id" => user.id}
    token = StripyRepo.get_by(StripeAccountToken, %{user_id: user_attrs["user_id"]})

    attrs = %{
      type: @type_field,
      country: @country,
      email: user.email,
      account_token: token.id_from_stripe,
      business_profile: %{
        mcc: @mcc,
        url: @url
      },
      capabilities: %{
        card_payments: %{
          requested: @requested
        },
        transfers: %{
          requested: @requested
        }
      },
      settings: %{
        payouts: %{
          schedule: %{
            interval: @settings
          }
        }
      }
    }

    if is_nil(token.id_from_stripe) do
      {:error, %Ecto.Changeset{}}
    else
      platform_account(attrs, user_attrs)
    end
  end

  @spec platform_account(map, map) :: {:ok, StripeAccount.t} |
                                      {:error, Ecto.Changeset.t} |
                                      {:error, :not_found}
  defp platform_account(attrs, user_attrs) do
    querty =
      try do
        Queries.by_value(StripeAccount, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    case StripyRepo.aggregate(querty, :count, :id) < 10 do
      true ->
        case Accounts.by_role(user_attrs["user_id"]) do
          false -> {:error, %Ecto.Changeset{}}
          true ->
            with {:ok,  %StripeAccount{} = data} <- StripePlatformAccountService.create(attrs, user_attrs) do
              {:ok, data}
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
        end
      false -> {:error, %Ecto.Changeset{}}
    end
  end
end

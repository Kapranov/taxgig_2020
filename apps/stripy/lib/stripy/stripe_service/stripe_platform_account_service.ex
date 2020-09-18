defmodule Stripy.StripeService.StripePlatformAccountService do
  @moduledoc """
  Used to perform actions on StripeAccount records, while propagating to
  and from associated Stripe.StripeAccount records
  """

  alias Stripy.{
    Payments,
    Payments.StripeAccount,
    StripeService.Adapters.StripePlatformAccountAdapter,
    Queries,
    Repo
  }

  @api Application.get_env(:stripy, :stripe)

  @doc """
  Creates a new `Stripe.Account` record on Stripe API, as well as an associated local
  `StripeAccount` record

  ## Example

      iex> user_id = "9yk8z0djhUG2r9LMK8"
      iex> user_attrs = %{"user_id" => user_id}
      iex> account_attrs = %{
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
      iex> {:ok, account} = Stripe.Account.create(account_attrs)
      iex> {:ok, result} = StripePlatformAccountAdapter.to_params(account, user_attrs)

  """
  @spec create(map, map) ::
          {:ok, StripeAccount.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(account_attrs, user_attrs) do
    querty =
      try do
        Queries.by_count(StripeAccount, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    with {:ok, %Stripe.Account{} = account} = @api.Account.create(account_attrs),
         {:ok, params} <- StripePlatformAccountAdapter.to_params(account, user_attrs)
    do
      case Repo.aggregate(querty, :count, :id) < 1 do
        false -> {:error, %Ecto.Changeset{}}
        true ->
          case Payments.create_stripe_account(params) do
            {:error, error} -> {:error, error}
            {:ok, data} -> {:ok, data}
          end
      end
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end
end

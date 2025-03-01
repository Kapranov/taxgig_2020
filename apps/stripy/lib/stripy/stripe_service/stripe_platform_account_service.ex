defmodule Stripy.StripeService.StripePlatformAccountService do
  @moduledoc """
  Work with Stripe Connect account objects. Used to perform
  actions on StripeAccount records, while propagating to and
  from associated Stripe.StripeAccount records.

  You can:

  - Retrieve your own account
  - Retrieve an account with a specified `id`

  This module does not yet support managed accounts.

  Stripe API reference: https://stripe.com/docs/api/accounts
  """

  alias Stripy.{
    Payments,
    Payments.StripeAccount,
    Queries,
    Repo,
    StripeService.Adapters.StripePlatformAccountAdapter
  }

  @doc """
  Creates a new `Stripe.Account` record on Stripe API,
  as well as an associated local `StripeAccount` record

  With `Connect`, you can create Stripe accounts for your users.

  fronend - [
    :type,
    :country,
    :email,
    business_profile: [:mcc, :url],
    capabilities: %{
      card_payments: [:requested]
      transfers: [:requested]
    }
    settings: %{
      payouts: %{
        schedule: [:interval]
      }
    }
  ]
  backend - [:account_token]

  1. If create a new `StripeAccount` this performs only one records and for role's pro.
  2. if has one record return error
  3. If `StripeAccount` creation fails return an error


  ## Example

      iex> user_id = FlakeId.get()
      iex> user_attrs = %{"user_id" => user_id}
      iex> attrs = %{
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
      iex> {:ok, account} = create(attrs, user_attrs)

  """
  @spec create(map, map) ::
          {:ok, StripeAccount.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
  def create(attrs, user_attrs) do
    querty = Queries.by_count(StripeAccount, :user_id, user_attrs["user_id"])

    case Repo.aggregate(querty, :count, :id) == 0 do
      false -> {:error, %Ecto.Changeset{}}
      true ->
        case Stripe.Account.create(attrs) do
          {:ok, account} ->
            with {:ok, params} <- StripePlatformAccountAdapter.to_params(account, user_attrs),
                 {:ok, struct} <- Payments.create_stripe_account(params)
            do
              {:ok, struct}
            else
              failure -> failure
            end
          failure -> failure
        end
    end
  end

  @doc """
  If updated User's fields `[:email]`,
  we should updated `Stripe.Account` and  StripeAccount`.

  ## Example

      iex> id = "acct_1HmmYOQ1ofBpQHz3"
      iex> attrs = %{email: "edward@yahoo.com"}
      iex> {:ok, updated} = update(id, attrs)

  """
  @spec update(String.t, map) ::
          {:ok, StripeAccount.t}
          | {:error, Ecto.Changeset.t}
          | {:error, Stripe.Error.t}
          | nil
  def update(id, attrs) do
    case Repo.get_by(StripeAccount, %{id_from_stripe: id}) do
      nil -> nil
      struct ->
        with {:ok, _data} <- Stripe.Account.update(id, attrs),
             {:ok, updated} <- Payments.update_stripe_account(struct, attrs)
        do
          {:ok, updated}
        else
          failure -> failure
        end
    end
  end

  @doc """
  When User is deleted, we must delete:
  Stripe API - Stripe.Account,
  Stripy DB  - StripeAccount,
               StripeAccountToken,
               StripeBankAccountToken,
               StripeExternalAccountBank,
               StripeExternalAccountCard,
               StripeCardToken,
               StripeTransfer,
               StripeTransferReversal

  ## Example

      iex> id = "acct_1HmmYOQ1ofBpQHz3"
      iex> {:ok, deleted} = delete(id)

  """
  @spec delete(String.t) ::
          {:ok, StripeAccount.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | nil
  def delete(id) do
    case Repo.get_by(StripeAccount, %{id_from_stripe: id}) do
      nil -> nil
      struct ->
        with {:ok, _data} <- Stripe.Account.delete(struct.id_from_stripe),
             {:ok, deleted} <- Payments.delete_stripe_account(struct)
        do
          {:ok, deleted}
        else
          failure -> failure
        end
    end
  end
end

defmodule ServerWeb.Seeder.StripeExternalAccountBank do
  @moduledoc """
  Seeds for `Stripy.StripeExternalAccountBank` context.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Queries
  }

  alias Stripy.{
    Payments.StripeAccount,
    Payments.StripeBankAccountToken,
    Payments.StripeExternalAccountBank,
    Payments.StripeExternalAccountCard,
    StripeService.StripePlatformExternalAccountBankService
  }

  alias Core.Repo, as: CoreRepo
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeExternalAccountBank)
  end

  @doc """
  Used to create a remote `Stripe.ExternalAccount` record as well as
  an associated local `StripeExternalAccountBank` record.

  When you create a new bank account, you must specify a Custom account to create it on.
  If the bank account's owner has no other external account in the bank account's currency,
  the new bank account will become the default for that currency. However, if the owner
  already has a bank account for that currency, the new account will become the default
  only if the `default_for_currency` parameter is set to `true`.

  fronend - []
  backend - [:account, :token]

  1. if none or not more 10 records, it will created only `StripeExternalAccountBank`
     Afterwards, update attr's `token` for `StripeBankAccountToken` this performs only for pro.
  2. If `StripeExternalAccountBank` creation fails, return an error
  3. If `StripeExternalAccountBank` creation succeeds, return created `StripeExternalAccountBank`
  6. If create 11 the record for `StripeExternalAccountBank` return error
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_external_account_bank()
  end

  @spec seed_stripe_external_account_bank() :: [Ecto.Schema.t()]
  defp seed_stripe_external_account_bank do
    user = CoreRepo.get_by(User, %{email: "op@taxgig.com"})
    user_attrs = %{"user_id" => user.id}
    account = StripyRepo.get_by(StripeAccount, %{user_id: user_attrs["user_id"]})
    token = StripyRepo.get_by(StripeBankAccountToken, %{user_id: user_attrs["user_id"]})

    attrs = %{
      account: account.id_from_stripe,
      token: token.id_from_stripe
    }

    platform_external_account_bank(attrs, user_attrs)
  end

  @spec platform_external_account_bank(map, map) ::
          {:ok, StripeExternalAccountBank.t}
          | {:error, Ecto.Changeset.t}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  defp platform_external_account_bank(attrs, user_attrs) do
    count_bank =
      try do
        Queries.by_value(StripeExternalAccountBank, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    count_card =
      try do
        Queries.by_value(StripeExternalAccountCard, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    case Accounts.by_role(user_attrs["user_id"]) do
      true ->
        if (StripyRepo.aggregate(count_bank, :count, :id) + StripyRepo.aggregate(count_card, :count, :id)) < 10 do
          with {:ok, %StripeExternalAccountBank{} = data} <- StripePlatformExternalAccountBankService.create(attrs, user_attrs) do
            {:ok, data}
          else
            nil -> {:error, :not_found}
            failure -> failure
          end
        else
          {:error, %Ecto.Changeset{}}
        end
      false -> {:error, %Ecto.Changeset{}}
    end
  end
end

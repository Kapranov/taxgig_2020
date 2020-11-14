defmodule Stripy.StripeService.StripePlatformExternalAccountBankService do
  @moduledoc """
  Used to perform actions on Stripe.ExternalAccount records, while propagating to
  and from associated StripeExternalAccountBank records

  Stripe API reference: https://stripe.com/docs/api#external_accounts
  """

  alias Stripy.{
    Payments,
    Payments.StripeExternalAccountBank,
    Payments.StripeExternalAccountCard,
    Queries,
    Repo,
    StripeService.Adapters.StripePlatformExternalAccountBankAdapter
  }

  @doc """
  Creates a new `Stripe.ExternalAccount` record on Stripe API, as well as an associated local
  `StripeExternalAccountBank` record

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

  ## Example

      iex> user_id = FlakeId.get()
      iex> user_attrs = %{"user_id" => user_id}
      iex> attrs = %{
        account: "acct_1HPssUC7lbhZAQNr",
        token: btok_1HQ9bjLhtqtNnMebggNERNkG
      }
      iex> {:ok, external_account_bank} = create(attrs, user_attrs)
  """
  @spec create(map, map) ::
          {:ok, StripeExternalAccountBank.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(attrs, user_attrs) do
    querty =
      try do
        Queries.by_count(StripeExternalAccountCard, StripeExternalAccountBank, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    with {:ok, %Stripe.BankAccount{} = external_account_bank} = Stripe.ExternalAccount.create(attrs),
         {:ok, params} <- StripePlatformExternalAccountBankAdapter.to_params(external_account_bank, user_attrs)
    do
      case Repo.aggregate(querty, :count, :id) < 10 do
        false -> {:error, %Ecto.Changeset{}}
        true ->
          case Payments.create_stripe_external_account_bank(params) do
            {:error, error} -> {:error, error}
            {:ok, data} -> {:ok, data}
          end
      end
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end

  @doc """
  Delete a bank account

  ## Example

      iex> attrs = %{account: "acct_1HmmYOQ1ofBpQHz3"}
      iex> id = "ba_1HmsI52eZvKYlo2CGd9dkJKV"
      iex> {:ok, deleted} = delete(id, attrs)

  """
  @spec delete(String.t, %{account: String.t}) ::
          {:ok, StripeExternalAccountBank.t} |
          {:error, Ecto.Changeset.t} |
          {:error, Stripe.Error.t} |
          {:error, :platform_not_ready} |
          {:error, :not_found}
  def delete(id, attrs) do
    with struct <- Repo.get_by(StripeExternalAccountBank, %{id_from_stripe: id}),
         {:ok, _data} <- Stripe.ExternalAccount.delete(id, attrs),
         {:ok, deleted} <- Payments.delete_stripe_external_account_bank(struct)
    do
      {:ok, deleted}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end

  @doc """
  List all bank accounts

  ## Example

      iex> attrs = %{account: "acct_1HmmYOQ1ofBpQHz3"}
      iex> {:ok, data} = list(:bank_account, attrs)

  """
  @spec list(atom, %{account: String.t}) ::
          {:ok, Stripe.List.t} |
          {:error, Ecto.Changeset.t} |
          {:error, Stripe.Error.t} |
          {:error, :platform_not_ready} |
          {:error, :not_found}
  def list(:bank_account, attrs) do
    with {:ok, %Stripe.List{data: data}} <- Stripe.ExternalAccount.list(:bank_account, attrs) do
      {:ok, data}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end
end

defmodule Stripy.StripeService.StripePlatformExternalAccountBankService do
  @moduledoc """
  Used to perform actions on Stripe.ExternalAccount records, while propagating to
  and from associated StripeExternalAccountBank records

  Stripe API reference: https://stripe.com/docs/api#external_accounts
  """

  alias Stripy.{
    Payments,
    Payments.StripeExternalAccountBank,
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
  def create(attrs, user_attrs) do
    case Stripe.ExternalAccount.create(attrs) do
      {:ok, external_account_bank} ->
        with {:ok, params} <- StripePlatformExternalAccountBankAdapter.to_params(external_account_bank, user_attrs),
             {:ok, struct} <- Payments.create_stripe_external_account_bank(params)
        do
          {:ok, struct}
        else
          failure -> failure
        end
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
          nil
  def delete(id, attrs) do
    case Repo.get_by(StripeExternalAccountBank, %{id_from_stripe: id}) do
      nil -> nil
      struct ->
        with {:ok, _data} <- Stripe.ExternalAccount.delete(id, attrs),
             {:ok, deleted} <- Payments.delete_stripe_external_account_bank(struct)
        do
          {:ok, deleted}
        else
          failure -> failure
        end
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
          {:ok, []} |
          {:error, Stripe.Error.t}
  def list(:bank_account, attrs) do
    with {:ok, %Stripe.List{data: data}} <- Stripe.ExternalAccount.list(:bank_account, attrs) do
      {:ok, data}
    else
      failure -> failure
    end
  end
end

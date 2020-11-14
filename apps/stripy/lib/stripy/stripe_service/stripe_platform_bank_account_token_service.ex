defmodule Stripy.StripeService.StripePlatformBankAccountTokenService do
  @moduledoc """
  Used to perform actions on StripeBankAccountToken records, while propagating to
  and from associated StripeBankAccountToken records

  Stripe API reference: https://stripe.com/docs/api/tokens
  """

  alias Stripy.{
    Payments,
    Payments.StripeBankAccountToken,
    Queries,
    Repo,
    StripeService.Adapters.StripePlatformBankAccountTokenAdapter
  }

  @doc """
  Creates a new `Stripe.Token` record on Stripe API, as well as an associated local
  `StripeBankAccountToken` record

  Creates a single-use token that represents a bank account’s details. This token can be used
  with any API method in place of a bank account dictionary. This token can be used only once,
  by attaching it to a Custom account.

  fronend - [:account_holder_name, :account_holder_type, :account_number, :country, :currency, :routing_number]
  backend - []

  1. If no record yet, then we perform create`StripeBankAccountToken` and `StripeExternalAccountBank`.
     Afterwards, update attr's `id_from_stripe` insert `xxx` for `StripeBankAccountToken`
     this performs for one and not more 10 record and only for pro.
  2. If `StripeBankAccountToken` creation fails, don't create `StripeExternalAccountBank` and return an error
  3. If `StripeBankAccountToken` creation succeeds, return created `StripeBankAccountToken`
  4. If create 11 and more bank_accounts for `StripeBankAccountToken` return error


  ## Example

      iex> user_id = FlakeId.get()
      iex> user_attrs = %{"user_id" => user_id}
      iex> attrs = %{
        bank_account: %{
          account_holder_name: "Jenny Rosen",
          account_holder_type: "individual",
          account_number: 000123456789,
          country: "US",
          currency: "usd",
          routing_number: 110000000
        }
      }
      iex> {:ok, bank_account_token} = create(attrs, user_attrs)

  """
  @spec create(map, map) ::
          {:ok, StripeBankAccountToken.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(attrs, user_attrs) do
    querty =
      try do
        Queries.by_count(StripeBankAccountToken, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    with {:ok, %Stripe.Token{} = bank_account_token} = Stripe.Token.create(%{bank_account: attrs}),
         {:ok, params} <- StripePlatformBankAccountTokenAdapter.to_params(bank_account_token, user_attrs)
    do
      case Repo.aggregate(querty, :count, :id) < 10 do
        false -> {:error, %Ecto.Changeset{}}
        true ->
          case Payments.create_stripe_bank_account_token(params) do
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
  Delete StripeBankAccountToken

  ## Example

      iex> id = "ct_1HmiqgLhtqtNnMebvcO8EfQh"
      iex> {:ok, deleted} = delete(id)

  """
  @spec delete(String.t) ::
          {:ok, StripeBankAccountToken.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def delete(id) do
    with struct <- Repo.get_by(StripeBankAccountToken, %{id_from_stripe: id}),
         {:ok, deleted} <- Payments.delete_stripe_bank_account_token(struct)
    do
      {:ok, deleted}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end
end

defmodule Stripy.StripeService.StripePlatformExternalAccountBankService do
  @moduledoc """
  Used to perform actions on Stripe.ExternalAccount records, while propagating to
  and from associated StripeExternalAccountBank records
  """

  alias Stripy.{
    Payments,
    Payments.StripeExternalAccountCard,
    Payments.StripeExternalAccountBank,
    Queries,
    Repo,
    StripeService.Adapters.StripePlatformExternalAccountBankAdapter
  }

  @api Application.get_env(:stripy, :stripe)

  @doc """
  Creates a new `Stripe.ExternalAccount` record on Stripe API, as well as an associated local
  `StripeExternalAccountBank` record

  ## Example

      iex> user_id = FlakeId.get()
      iex> user_attrs = %{"user_id" => user_id}
      iex> external_account_bank_attrs = %{
        account: "acct_1HPssUC7lbhZAQNr",
        external_account: btok_1HQ9bjLhtqtNnMebggNERNkG
      }
      iex> {:ok, bank_account} = Stripe.ExternalAccount.create(external_account_bank_attrs)
      iex> {:ok, result} = StripePlatformExternalAccountBankAdapter.to_params(bank_account, user_attrs)

  """
  @spec create(map, map) ::
          {:ok, StripeExternalAccountBank.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(external_account_bank_attrs, user_attrs) do
    querty =
      try do
        Queries.by_count(StripeExternalAccountCard, StripeExternalAccountBank, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    with {:ok, %Stripe.BankAccount{} = bank_account} = @api.ExternalAccount.create(external_account_bank_attrs),
         {:ok, params} <- StripePlatformExternalAccountBankAdapter.to_params(bank_account, user_attrs)
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
end

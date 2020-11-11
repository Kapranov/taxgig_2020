defmodule Stripy.StripeService.StripePlatformExternalAccountCardService do
  @moduledoc """
  Used to perform actions on Stripe.ExternalAccount records, while propagating to
  and from associated StripeExternalAccountCard records

  Stripe API reference: https://stripe.com/docs/api#external_accounts
  """

  alias Stripy.{
    Payments,
    Payments.StripeExternalAccountCard,
    Queries,
    Repo,
    StripeService.Adapters.StripePlatformExternalAccountCardAdapter
  }

  @api Application.get_env(:stripy, :stripe)

  @doc """
  Creates a new `Stripe.ExternalAccount` record on Stripe API, as well as an associated local
  `StripeExternalAccountCard` record

  ## Example

      iex> user_id = FlakeId.get()
      iex> user_attrs = %{"user_id" => user_id}
      iex> attrs = %{
        account: "acct_1HPssUC7lbhZAQNr",
        token: "tok_1HQ9DtLhtqtNnMebLXlD2TAas"
      }
      iex> {:ok, external_account_card} = Stripe.ExternalAccount.create(attrs)
      iex> {:ok, result} = StripePlatformAccountAdapter.to_params(external_account_card, user_attrs)

  """
  @spec create(map, map) ::
          {:ok, StripeExternalAccountCard.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(attrs, user_attrs) do
    querty =
      try do
        Queries.by_count(StripeExternalAccountCard, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    with {:ok, %Stripe.Card{} = card} <- @api.ExternalAccount.create(attrs),
         {:ok, params} <- StripePlatformExternalAccountCardAdapter.to_params(card, user_attrs)
    do
      case Repo.aggregate(querty, :count, :id) < 10 do
        false -> {:error, %Ecto.Changeset{}}
        true ->
          case Payments.create_stripe_external_account_card(params) do
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
  Delete external_account_cards from an account.
  """
  def delete do
#    curl https://api.stripe.com/v1/accounts/acct_1032D82eZvKYlo2C/external_accounts/card_1HmKej2eZvKYlo2Cfy7AJPAW \
#    -u sk_test_4eC39HqLyjWDarjtT1zdp7dc: \
#    -X DELETE
  end

  @doc """
  """
  def list do
#    curl https://api.stripe.com/v1/accounts/acct_1032D82eZvKYlo2C/external_accounts \
#    -u sk_test_4eC39HqLyjWDarjtT1zdp7dc: \
#    -d limit=10 \
#    -G
  end
end

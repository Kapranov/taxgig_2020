defmodule Stripy.StripeService.StripePlatformExternalAccountCardService do
  @moduledoc """
  Used to perform actions on Stripe.ExternalAccount records, while propagating to
  and from associated StripeExternalAccountCard records
  """

  alias Stripy.{
    Payments,
    Payments.StripeExternalAccountCard,
    Payments.StripeExternalAccountBank,
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
      iex> external_account_card_attrs = %{
        account: "acct_1HPssUC7lbhZAQNr",
        external_account: "tok_1HQ9DtLhtqtNnMebLXlD2TAas"
      }
      iex> {:ok, card} = Stripe.ExternalAccount.create(external_account_card_attrs)
      iex> {:ok, result} = StripePlatformAccountAdapter.to_params(card, user_attrs)

  """
  @spec create(map, map) ::
          {:ok, StripeExternalAccountCard.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(external_account_card_attrs, user_attrs) do
    querty =
      try do
        Queries.by_count(StripeExternalAccountCard, StripeExternalAccountBank, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    with {:ok, %Stripe.Card{} = card} = @api.ExternalAccount.create(external_account_card_attrs),
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
end

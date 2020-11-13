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
      iex> {:ok, external_account_card} = create(attrs, user_attrs)

  """
  @spec create(%{account: String.t(), token: String.t()}, %{"user_id" => String.t}) ::
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
  Delete a card

  ## Example

      iex> attrs = %{account: "acct_1HmmYOQ1ofBpQHz3"}
      iex> id = "card_1HmsI22eZvKYlo2C7epYolsb"
      iex> {:ok, deleted} = delete(id, attrs)

  """
  @spec delete(String.t, %{account: String.t}) ::
          {:ok, StripeExternalAccountCard.t} |
          {:error, Ecto.Changeset.t} |
          {:error, Stripe.Error.t} |
          {:error, :platform_not_ready} |
          {:error, :not_found}
  def delete(id, attrs) do
    with struct <- Repo.get_by(StripeExternalAccountCard, %{id_from_stripe: id}),
         {:ok, _data} <- @api.ExternalAccount.delete(id, attrs),
         {:ok, deleted} <- Payments.delete_stripe_external_account_card(struct)
    do
      {:ok, deleted}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end

  @doc """
  List all cards

  ## Example

      iex> attrs = %{account: "acct_1HmmYOQ1ofBpQHz3"}
      iex> {:ok, data} = list(:card, attrs)

  """
  @spec list(atom, %{account: String.t}) ::
          {:ok, Stripe.List.t} |
          {:error, Ecto.Changeset.t} |
          {:error, Stripe.Error.t} |
          {:error, :platform_not_ready} |
          {:error, :not_found}
  def list(:card, attrs) do
    with {:ok, %@api.List{data: data}} <- @api.ExternalAccount.list(:card, attrs) do
      {:ok, data}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end
end

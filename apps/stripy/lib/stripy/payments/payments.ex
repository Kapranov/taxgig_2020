defmodule Stripy.Payments do
  @moduledoc """
  The Payments for context.
  """

  import Ecto.Query, warn: false

  # alias Ecto.Multi

  alias Stripy.{
    Payments.StripeCardToken,
    Repo
  }

  @doc """
  Gets a single StripeCardToken.

  Raises `Ecto.NoResultsError` if the StripeCardToken does not exist.

  ## Examples

      iex> get_stripe_card_token!(123)
      %StripeCardToken{}

      iex> get_stripe_card_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stripe_card_token!(id), do: Repo.get!(StripeCardToken, id)

  @doc """
  Gets a single StripeCardToken's User_id by their UserId.
  Raises `Ecto.NoResultsError` if the StripeCardToken's UserId does not exist.

  ## Example

      iex> get_cards_find_by_user_id('123')
      %StripeCardToken{}

      iex> get_cards_find_by_user_id('not a name')
      ** (Ecto.NoResultsError)
  """
  def get_cards_find_by_user_id(user_id) do
    card = from p in StripeCardToken, where: p.user_id == ^user_id

    case user_id do
      nil -> nil
      _ -> Repo.all(card)
    end
  end

  @doc """
  Creates a StripeCardToken.

  ## Examples

      iex> create_stripe_card_token(%{field: value})
      {:ok, %StripeCardToken{}}

      iex> create_stripe_card_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stripe_card_token(attrs) do
    %StripeCardToken{}
    |> StripeCardToken.changeset(attrs)
    |> Repo.insert()
  end

#  @doc """
#  Multi for Complex Database Transactions `StripeCardToken`
#  and then `StripeCustomer`.
#
#  1. Try creating a `StripeCardToken`
#  2. If `StripeCardToken` creation fails, return an error
#  3. If `StripeCardToken` creation succeeds, try creating `StripeCustomer`
#  4. If `StripeCustomer` creation fails, delete the `StripeCardToken` and return an error
#  5. If `StripeCustomer` creation succeeds, return the while records
#  """
#  def create_multi_card_token_customer(attrs) do
#    card_token_changeset =
#      StripeCardToken.changeset(%StripeCardToken{}, attrs)
#
#    email =
#      attrs["user_id"]
#      |> Accounts.find_by_email
#
#    token = attrs["card_token"]
#
#    {:ok, customer} = Stripe.Customer.create(%{source: token})
#
#    customer_attrs = %{stripe_customer_id: customer.id}
#
#    Multi.new
#    |> Multi.insert(:stripe_card_token, card_token_changeset)
#    |> Multi.run(:stripe_customer, fn _, %{stripe_card_token: stripe_card_token} ->
#      stripe_customer_changeset =
#        %StripeCustomer{
#          user_id: stripe_card_token.user_id,
#          account_balance: customer.account_balance,
#          created: customer.created,
#          currency: customer.currency,
#          delinquent: customer.delinquent,
#          description: customer.description,
#          email: email,
#          livemode: customer.livemode
#        }
#        |> StripeCustomer.changeset(customer_attrs)
#      Repo.insert(stripe_customer_changeset)
#    end)
#    |> Repo.transaction()
#  end

  @doc """
  Deletes a StripeCardToken.

  ## Examples

      iex> delete_stripe_card_token(stripe_card_token)
      {:ok, %StripeCardToken{}}

      iex> delete_stripe_card_token(stripe_card_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stripe_card_token(%StripeCardToken{} = struct), do: Repo.delete(struct)
end

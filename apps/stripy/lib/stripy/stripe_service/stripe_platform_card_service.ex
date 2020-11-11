defmodule Stripy.StripeService.StripePlatformCardService do
  @moduledoc """
  Used to perform actions on StripeCardToken records, while propagating to
  and from associated Stripe.Card records

  You can:
  - Create a token for a Connect customer with a card
  - Create a token with all options - Only for Unit Tests with Stripe
  - Delete card
  - List card

  Stripe API reference:
  https://stripe.com/docs/api/tokens
  https://stripe.com/docs/api/cards/create
  https://stripe.com/docs/api/cards/list
  https://stripe.com/docs/api/cards/delete
  """

  alias Stripy.{
    Payments,
    Payments.StripeCardToken,
    Queries,
    Repo,
    StripeService.Adapters.StripePlatformCardTokenAdapter
  }

  @api Application.get_env(:stripy, :stripe)

  @doc """
  Creates a new `Stripe.Token` record on Stripe API, as well as an associated local
  `StripeCardToken` record

  Creates a single use token that wraps the details of a credit card. This
  token can be used in place of a credit card dictionary with any API method.
  These tokens can only be used once: by creating a new charge object, or
  attaching them to a customer.

  card_attrs1  = %{number: 4242424242424242, exp_month: 8, exp_year: 2021, cvc: 314, name: "Oleg G.Kapranov"}
  card_attrs2  = %{number: 4000056655665556, exp_month: 9, exp_year: 2026, cvc: 111, name: "Oleg G.Kapranov"}
  card_attrs3  = %{number: 5555555555554444, exp_month: 8, exp_year: 2025, cvc: 222, name: "Oleg G.Kapranov"}
  card_attrs4  = %{number: 5200828282828210, exp_month: 7, exp_year: 2022, cvc: 333, name: "Oleg G.Kapranov"}
  card_attrs5  = %{number: 5105105105105100, exp_month: 6, exp_year: 2023, cvc: 444, name: "Oleg G.Kapranov"}
  card_attrs6  = %{number: 2223003122003222, exp_month: 5, exp_year: 2022, cvc: 555, name: "Oleg G.Kapranov"}
  card_attrs7  = %{number: 6011111111111117, exp_month: 4, exp_year: 2024, cvc: 666, name: "Oleg G.Kapranov"}
  card_attrs8  = %{number: 3056930009020004, exp_month: 3, exp_year: 2025, cvc: 777, name: "Oleg G.Kapranov"}
  card_attrs9  = %{number: 3566002020360505, exp_month: 2, exp_year: 2022, cvc: 888, name: "Oleg G.Kapranov"}
  card_attrs10 = %{number: 6200000000000005, exp_month: 1, exp_year: 2023, cvc: 999, name: "Oleg G.Kapranov"}
  card_attrs11 = %{number: 378282246310005,  exp_month: 1, exp_year: 2021, cvc: 111, name: "Oleg G.Kapranov"}

  #  def create_invites(invite_attrs, user) do
  #    invite_attrs
  #    |> Enum.with_index()
  #    |> Enum.reduce(Ecto.Multi.new(), fn {attrs, idx}, multi ->
  #      invite_changeset = %Invite{creator_id: user.id} |> Invite.changeset(attrs)
  #      Ecto.Multi.insert(multi, {:invite, idx}, invite_changeset)
  #    end)
  #    |> Repo.transaction()
  #  end

  #  user = Repo.get_by(User, %{email: "v.kobzan@gmail.com"})
  #  user_attrs = %{"user_id" => user.id}
  #  user_full_name = Accounts.by_full_name(user.id)
  #  attrs = %{ cvc: 314, exp_month: 8, exp_year: 2021, name: user_full_name, number: 4242424242424242 }
  #  {:ok, %Stripe.Token{} = card} = Stripe.Token.create(%{card: attrs})
  #  {:ok, card_params} = Stripy.StripeService.Adapters.StripePlatformCardTokenAdapter.to_params(card, user_attrs)
  #  card_token_changeset = Stripy.Payments.StripeCardToken.changeset(%Stripy.Payments.StripeCardToken{}, card_params)
  #  customer_attrs = %{email: user.email, name: user_full_name, phone: user.phone, source: card_params["token"]}
  #  {:ok, %Stripe.Customer{} = customer} = Stripe.Customer.create(customer_attrs)
  #  {:ok, customer_params} <- Stripy.StripeService.Adapters.StripePlatformCustomerAdapter.to_params(customer, user_attrs)
  #  customer_changeset = Stripy.Payments.StripeCustomer.changeset(%Stripy.Payments.StripeCustomer{}, customer_params)
  #  updated_card_params = params |> Map.put("id_from_customer", customer_params["id_from_stripe"])
  #  updated_changeset = Stripy.Payments.StripeCardToken.changeset(updated_card_params)
  #
  #  Ecto.Multi.new
  #  |> Ecto.Multi.insert(:stripe_card_tokens, updated_changeset)
  #  |> Ecto.Multi.insert(:stripe_customers, customer_changeset)
  #  |> Stripy.Repo.transaction()
  #
  #  accounts = [%User{id: user.id, email: user.email}]
  #  Enum.reduce(accounts, Ecto.Multi.new(), fn account, multi ->
  #    Ecto.Multi.update(multi, {:user, account.id}, User.changeset(account, %{email: account.email}))
  #    |> Repo.transaction()
  #  end)
  #
  #  picture_changeset = picture |> Picture.changeset(attrs)
  #  Multi.new() |> Multi.update(:update, picture_changeset) |> Repo.transaction()

  ## Example

    iex> user_id = FlakeId.get()
    iex> attrs = %{number: 4242424242424242, exp_month: 8, exp_year: 2021, cvc: 314, name: "Oleg G.Kapranov"}
    iex> user_attrs = %{"user_id" => user_id}
    iex> {:ok, created} = create_token(attrs, user_attrs)

  """
  @spec create_token(map, map) ::
          {:ok, StripeCardToken.t}
          | {:error, Ecto.Changeset.t}
          | {:error, Stripe.Error.t}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create_token(attrs, user_attrs) do
    querty =
      try do
        Queries.by_count(StripeCardToken, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    with {:ok, %Stripe.Token{} = card} = @api.Token.create(%{card: attrs}),
         {:ok, params} <- StripePlatformCardTokenAdapter.to_params(card, user_attrs)
    do
      case Repo.aggregate(querty, :count, :id) < 10 do
        false -> {:error, %Ecto.Changeset{}}
        true ->
          case Payments.create_stripe_card_token(params) do
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
  Creates a new `Stripe.Card` record on Stripe API, as well as an associated local
  `StripeCardToken` record for adding new cards to owner's customer

  ## Example

    iex> attrs = %{customer: "cus_Hz0iaxWhaRWm6b", source: "tok_1HjqhhLhtqtNnMebVf19F2kQ"}
    iex> {:ok, created} = create_card(attrs)

  """
  @spec create_card(%{customer: String.t(), source: String.t()}) ::
          {:ok, map} |
          {:error, Ecto.Changeset.t} |
          {:error, Stripe.Error.t} |
          {:error, :platform_not_ready} |
          {:error, :not_found}
  def create_card(attrs) do
    with {:ok, %@api.Card{} = data} <- @api.Card.create(attrs) do
      {:ok, data}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end

  @doc """
  Delete cards from a customer

  ## Example

      iex> attrs = %{customer: "cus_IMlbpTTiZ8thiF"}
      iex> id_from_card = "card_1Hm24VLhtqtNnMebiqbcchQf"
      iex> {:ok, deleted} = delete_card(id_from_card, attrs)

  """
  @spec delete_card(String.t, %{customer: String.t}) ::
          {:ok, map} |
          {:error, Ecto.Changeset.t} |
          {:error, Stripe.Error.t} |
          {:error, :platform_not_ready} |
          {:error, :not_found}
  def delete_card(id, attrs) do
    with struct <- Repo.get_by(StripeCardToken, %{id_from_stripe: id}),
         {:ok, _data} <- @api.Card.delete(id, attrs),
         {:ok, deleted} <- Payments.delete_stripe_card_token(struct)
    do
      {:ok, deleted}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end

  @doc """
  Return a list of the cards belonging to a customer.

  ## Example

      iex> attrs = %{customer: "cus_IMlbpTTiZ8thiF"}
      iex> {:ok, data} = list_card(attrs)

  """
  @spec list_card(%{customer: String.t}) ::
          {:ok, map} |
          {:error, Ecto.Changeset.t} |
          {:error, Stripe.Error.t} |
          {:error, :platform_not_ready} |
          {:error, :not_found}
  def list_card(attrs) do
    with {:ok, %Stripe.List{data: data}} <- Stripe.Card.list(attrs) do
      {:ok, data}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end
end

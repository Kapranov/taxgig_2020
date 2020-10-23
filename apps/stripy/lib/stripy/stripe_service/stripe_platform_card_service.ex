defmodule Stripy.StripeService.StripePlatformCardService do
  @moduledoc """
  Used to perform actions on StripeCardToken records, while propagating to
  and from associated Stripe.Card records
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

  ## Example

    iex> user_id = FlakeId.get()
    iex> user_attrs = %{"user_id" => user_id}
    iex> card_attrs = %{number: 4242424242424242, exp_month: 8, exp_year: 2021, cvc: 314, name: "Oleg G.Kapranov"}
    iex> {:ok, created} = Stripe.Token.create(%{card: card_attrs})
    iex> {:ok, result} = StripePlatformCardTokenAdapter.to_params(created, user_attrs)

  """
  @spec create(map, map) :: {:ok, StripeCardToken.t} |
                            {:error, Ecto.Changeset.t} |
                            {:error, Stripe.Error.t} |
                            {:error, :platform_not_ready} |
                            {:error, :not_found}
  def create(card_attrs, user_attrs) do
    querty =
      try do
        Queries.by_count(StripeCardToken, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    with {:ok, %Stripe.Token{} = card} = @api.Token.create(%{card: card_attrs}),
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
end

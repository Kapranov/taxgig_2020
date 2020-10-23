defmodule ServerWeb.Seeder.StripeCard do
  @moduledoc """
  Seeds for `Stripy.StripeCardToken` context.
  """

  alias Core.{
    Accounts,
    Accounts.User
  }

  alias Core.Queries
  alias Core.Repo, as: CoreRepo

  alias Stripy.{
    Payments,
    Payments.StripeCardToken,
    Payments.StripeCustomer,
    StripeService.StripePlatformCardService,
    StripeService.StripePlatformCustomerService
  }

  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeCardToken)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_card_token()
  end

  @spec seed_stripe_card_token() :: [Ecto.Schema.t()]
  def seed_stripe_card_token do
    user1 = CoreRepo.get_by(User, %{email: "v.kobzan@gmail.com"})
    user2 = CoreRepo.get_by(User, %{email: "o.puryshev@gmail.com"})
    user3 = CoreRepo.get_by(User, %{email: "op@taxgig.com"})

    user1_full_name = Accounts.by_full_name(user1.id)
    user2_full_name = Accounts.by_full_name(user2.id)
    user3_full_name = Accounts.by_full_name(user3.id)

    card01_attrs = %{ cvc: 314, exp_month: 8, exp_year: 2021, name: user1_full_name, number: 4242424242424242 }
    card02_attrs = %{ cvc: 365, exp_month: 3, exp_year: 2022, name: user2_full_name, number: 4242424242424242 }
    card03_attrs = %{ cvc: 311, exp_month: 6, exp_year: 2026, name: user2_full_name, number: 4000056655665556 }
    card04_attrs = %{ cvc: 322, exp_month: 5, exp_year: 2021, name: user2_full_name, number: 6011981111111113 }
    card05_attrs = %{ cvc: 333, exp_month: 1, exp_year: 2029, name: user2_full_name, number: 5200828282828210 }
    card06_attrs = %{ cvc: 344, exp_month: 4, exp_year: 2028, name: user2_full_name, number: 4000056755665555 }
    card07_attrs = %{ cvc: 355, exp_month: 7, exp_year: 2022, name: user2_full_name, number: 4000056655665572 }
    card08_attrs = %{ cvc: 366, exp_month: 9, exp_year: 2023, name: user2_full_name, number: 4000051240000005 }
    card09_attrs = %{ cvc: 377, exp_month: 2, exp_year: 2024, name: user2_full_name, number: 4000051240000021 }
    card10_attrs = %{ cvc: 388, exp_month: 5, exp_year: 2025, name: user2_full_name, number: 4000051240000039 }
    card11_attrs = %{ cvc: 399, exp_month: 9, exp_year: 2026, name: user2_full_name, number: 5510121240000006}
    card12_attrs = %{ cvc: 319, exp_month: 5, exp_year: 2021, name: user3_full_name, number: 4000056655665556 }

    [
      platform_card(card01_attrs, %{"user_id" => user1.id}),
      platform_card(card02_attrs, %{"user_id" => user2.id}),
      platform_card(card03_attrs, %{"user_id" => user2.id}),
      platform_card(card04_attrs, %{"user_id" => user2.id}),
      platform_card(card05_attrs, %{"user_id" => user2.id}),
      platform_card(card06_attrs, %{"user_id" => user2.id}),
      platform_card(card07_attrs, %{"user_id" => user2.id}),
      platform_card(card08_attrs, %{"user_id" => user2.id}),
      platform_card(card09_attrs, %{"user_id" => user2.id}),
      platform_card(card10_attrs, %{"user_id" => user2.id}),
      platform_card(card11_attrs, %{"user_id" => user2.id}),
      platform_card(card12_attrs, %{"user_id" => user3.id})
    ]
  end


  @doc """
  Multi for Complex Database Transactions `StripeCardToken` and then `StripeCustomer`

  1. If none record, it will created a`StripeCardToken` and `StripeCustomer` after
     that updated attr's `id_from_customer` in `StripeCardToken`
  2. if has one record, it will created only a new `StripeCardToken`
  3. If `StripeCardToken` creation fails, return an error
  4. If `StripeCardToken` creation succeeds, try creating `StripeCustomer` and updated `StripeCardToken` with `id_from_customer`
  5. If `StripeCustomer` creation fails, delete the `StripeCardToken` and return an error
  6. If `StripeCustomer` creation succeeds, return the while records
  """
  @spec platform_card(map, map) :: {:ok, StripeCustomer.t} |
                                              {:ok, StripeCardToken.t} |
                                              {:error, Ecto.Changeset.t} |
                                              {:error, :not_found}
  def platform_card(card_attrs, user_attrs) do
    querty =
      try do
        Queries.by_value(StripeCardToken, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    case CoreRepo.aggregate(querty, :count, :id) do
      0 ->
        with {:ok, card} <- StripePlatformCardService.create(card_attrs, user_attrs),
             user <- CoreRepo.get_by(User, id: user_attrs["user_id"]),
             full_name <- Accounts.by_full_name(user.id),
             {:ok, customer} <- StripePlatformCustomerService.create(%{email: user.email, name: full_name, phone: user.phone, source: card.token}, user_attrs)
        do
          {:ok, %StripeCardToken{}} = Payments.update_stripe_card_token(card, %{id_from_customer: customer.id_from_stripe})
        else
          nil -> {:error, :not_found}
          failure -> failure
        end
      n ->
        case n < 10 do
          true ->
            with {:ok, card} <- StripePlatformCardService.create(card_attrs, user_attrs),
                 id_from_customer <- StripyRepo.get_by(Payments.StripeCustomer, %{user_id: user_attrs["user_id"]}).id_from_stripe
            do
              {:ok, %StripeCardToken{}} = Payments.update_stripe_card_token(card, %{id_from_customer: id_from_customer})
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
          false -> {:error, %Ecto.Changeset{}}
        end
    end
  end
end

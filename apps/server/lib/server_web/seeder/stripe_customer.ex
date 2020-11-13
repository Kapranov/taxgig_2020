defmodule ServerWeb.Seeder.StripeCustomer do
  @moduledoc """
  Seeds for `Stripy.StripeCustomer` context.
  """

  import Ecto.Query

  alias Core.{
    Accounts,
    Accounts.User,
    Queries
  }

  alias Stripy.{
    Payments.StripeCardToken,
    Payments.StripeCustomer,
    StripeService.StripePlatformCustomerService
  }

  alias Core.Repo, as: CoreRepo
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeCustomer)
  end

  @doc """
  Create `StripeCustomer` for role false
  One record only for all cards.

  fronend - []
  backend - [:email, :name, :phone, :source]

  ## Example

  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_customer()
  end

  @spec seed_stripe_customer() :: [Ecto.Schema.t()]
  defp seed_stripe_customer do
    user1 = CoreRepo.get_by(User, %{email: "v.kobzan@gmail.com"})
    user2 = CoreRepo.get_by(User, %{email: "o.puryshev@gmail.com"})
    token1 = StripyRepo.all(from p in StripeCardToken, where: p.user_id == ^user1.id, select: p.token) |> List.last
    token2 = StripyRepo.all(from p in StripeCardToken, where: p.user_id == ^user2.id, select: p.token) |> List.last
    attrs_cus1 = %{email: user1.email, name: Accounts.by_full_name(user1.id), phone: user1.phone, source: token1}
    attrs_cus2 = %{email: user2.email, name: Accounts.by_full_name(user2.id), phone: user2.phone, source: token2}

    [
      platform_customer(attrs_cus1, %{"user_id" => user1.id}),
      platform_customer(attrs_cus2, %{"user_id" => user2.id})
    ]
  end

  @spec platform_customer(map, map) ::
          {:ok, StripeCustomer.t}
          | {:error, Ecto.Changeset.t}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  defp platform_customer(attrs, user_attrs) do
    querty =
      try do
        Queries.by_value(StripeCustomer, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    case Accounts.by_role(user_attrs["user_id"]) do
      true -> {:error, %Ecto.Changeset{}}
      false ->
        case CoreRepo.aggregate(querty, :count, :id) < 1 do
          false -> {:error, %Ecto.Changeset{}}
          true ->
            with {:ok, customer} <- StripePlatformCustomerService.create(attrs, user_attrs) do
              {:ok, customer}
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
        end
    end
  end
end

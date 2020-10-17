defmodule Core.Seeder.Contracts do
  @moduledoc """
  Seeds for `Core.Contracts` context.
  """

  alias Core.{
    Accounts.User,
    Contracts.Addon,
    Contracts.Offer,
    Repo
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(Addon)
    Repo.delete_all(Offer)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_addon()
    seed_offer()
  end

  @spec seed_addon() :: nil | Ecto.Schema.t()
  defp seed_addon do
    case Repo.aggregate(Addon, :count, :id) > 0 do
      true -> nil
      false -> insert_addon()
    end
  end

  @spec seed_offer() :: nil | Ecto.Schema.t()
  defp seed_offer do
    case Repo.aggregate(Offer, :count, :id) > 0 do
      true -> nil
      false -> insert_offer()
    end
  end

  @spec insert_addon() :: Ecto.Schema.t()
  defp insert_addon do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {user, tp1, tp2, tp3, pro1, pro2, pro3} = {
      Enum.at(user_ids, 0),
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    [
      Repo.insert!(%Addon{
        addon_price: random_integer(),
        status: random_status(),
        user_id: user
      }),
      Repo.insert!(%Addon{
        addon_price: random_integer(),
        status: random_status(),
        user_id: tp1
      }),
      Repo.insert!(%Addon{
        addon_price: random_integer(),
        status: random_status(),
        user_id: tp2
      }),
      Repo.insert!(%Addon{
        addon_price: random_integer(),
        status: random_status(),
        user_id: tp3
      }),
      Repo.insert!(%Addon{
        addon_price: random_integer(),
        status: random_status(),
        user_id: pro1
      }),
      Repo.insert!(%Addon{
        addon_price: random_integer(),
        status: random_status(),
        user_id: pro2
      }),
      Repo.insert!(%Addon{
        addon_price: random_integer(),
        status: random_status(),
        user_id: pro3
      })
    ]
  end

  @spec insert_offer() :: Ecto.Schema.t()
  defp insert_offer do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {user, tp1, tp2, tp3, pro1, pro2, pro3} = {
      Enum.at(user_ids, 0),
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    [
      Repo.insert!(%Offer{
        offer_price: random_integer(),
        status: random_status(),
        user_id: user
      }),
      Repo.insert!(%Offer{
        offer_price: random_integer(),
        status: random_status(),
        user_id: tp1
      }),
      Repo.insert!(%Offer{
        offer_price: random_integer(),
        status: random_status(),
        user_id: tp2
      }),
      Repo.insert!(%Offer{
        offer_price: random_integer(),
        status: random_status(),
        user_id: tp3
      }),
      Repo.insert!(%Offer{
        offer_price: random_integer(),
        status: random_status(),
        user_id: pro1
      }),
      Repo.insert!(%Offer{
        offer_price: random_integer(),
        status: random_status(),
        user_id: pro2
      }),
      Repo.insert!(%Offer{
        offer_price: random_integer(),
        status: random_status(),
        user_id: pro3
      })
    ]
  end

  @spec random_integer() :: integer()
  defp random_integer(n \\ 99) when is_integer(n) do
    Enum.random(1..n)
  end

  @spec random_status :: [String.t()]
  defp random_status do
    names = [
      "Sent",
      "Accepted",
      "Declined"
    ]

    numbers = 1..1
    number = Enum.random(numbers)

    [result] =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()

    result
  end
end

defmodule Core.Seeder.Updated.Contracts do
  @moduledoc """
  An update are seeds whole the contracts.
  """

  alias Core.{
    Contracts,
    Contracts.Addon,
    Contracts.Offer,
    Repo
  }

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_addon()
    update_offer()
  end

  @spec update_addon() :: Ecto.Schema.t()
  defp update_addon do
    addon_ids = Enum.map(Repo.all(Addon), fn(data) -> data end)

    {
      addon1,
      addon2,
      addon3,
      addon4,
      addon5,
      addon6,
      addon7
    } = {
      Enum.at(addon_ids, 0),
      Enum.at(addon_ids, 1),
      Enum.at(addon_ids, 2),
      Enum.at(addon_ids, 3),
      Enum.at(addon_ids, 4),
      Enum.at(addon_ids, 5),
      Enum.at(addon_ids, 6)
    }

    [
      Contracts.update_addon(addon1, %{
        addon_price: random_integer(),
        status: random_status()
      }),
      Contracts.update_addon(addon2, %{
        addon_price: random_integer(),
        status: random_status()
      }),
      Contracts.update_addon(addon3, %{
        addon_price: random_integer(),
        status: random_status()
      }),
      Contracts.update_addon(addon4, %{
        addon_price: random_integer(),
        status: random_status()
      }),
      Contracts.update_addon(addon5, %{
        addon_price: random_integer(),
        status: random_status()
      }),
      Contracts.update_addon(addon6, %{
        addon_price: random_integer(),
        status: random_status()
      }),
      Contracts.update_addon(addon7, %{
        addon_price: random_integer(),
        status: random_status()
      })
    ]
  end

  @spec update_offer() :: Ecto.Schema.t()
  defp update_offer do
    offer_ids = Enum.map(Repo.all(Offer), fn(data) -> data end)

    {
      offer1,
      offer2,
      offer3,
      offer4,
      offer5,
      offer6,
      offer7
    } = {
      Enum.at(offer_ids, 0),
      Enum.at(offer_ids, 1),
      Enum.at(offer_ids, 2),
      Enum.at(offer_ids, 3),
      Enum.at(offer_ids, 4),
      Enum.at(offer_ids, 5),
      Enum.at(offer_ids, 6)
    }

    [
      Contracts.update_offer(offer1, %{
        offer_price: random_integer(),
        status: random_status()
      }),
      Contracts.update_offer(offer2, %{
        offer_price: random_integer(),
        status: random_status()
      }),
      Contracts.update_offer(offer3, %{
        offer_price: random_integer(),
        status: random_status()
      }),
      Contracts.update_offer(offer4, %{
        offer_price: random_integer(),
        status: random_status()
      }),
      Contracts.update_offer(offer5, %{
        offer_price: random_integer(),
        status: random_status()
      }),
      Contracts.update_offer(offer6, %{
        offer_price: random_integer(),
        status: random_status()
      }),
      Contracts.update_offer(offer7, %{
        offer_price: random_integer(),
        status: random_status()
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

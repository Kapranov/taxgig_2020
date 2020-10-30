defmodule Core.Seeder.Contracts do
  @moduledoc """
  Seeds for `Core.Contracts` context.
  """

  alias Core.{
    Accounts.User,
    Contracts.Addon,
    Contracts.Offer,
    Contracts.Project,
    Contracts.ServiceReview,
    Repo
  }

  alias Faker.Lorem

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(Addon)
    Repo.delete_all(Offer)
    Repo.delete_all(ServiceReview)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_addon()
    seed_offer()
    seed_project()
    seed_service_review()
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

  @spec seed_project() :: nil | Ecto.Schema.t()
  defp seed_project do
    case Repo.aggregate(Project, :count, :id) > 0 do
      true -> nil
      false -> insert_project()
    end
  end

  @spec seed_service_review() :: nil | Ecto.Schema.t()
  defp seed_service_review do
    case Repo.aggregate(ServiceReview, :count, :id) > 0 do
      true -> nil
      false -> insert_service_review()
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

  @spec insert_project() :: Ecto.Schema.t()
  defp insert_project do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {tp1, tp2, tp3, pro1, pro2, pro3} = {
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    addon_ids = Enum.map(Repo.all(Addon), fn(data) -> data end)

    {
      addon2,
      addon3,
      addon4
    } = {
      Enum.at(addon_ids, 1),
      Enum.at(addon_ids, 2),
      Enum.at(addon_ids, 3)
    }

    offer_ids = Enum.map(Repo.all(Offer), fn(data) -> data end)

    {
      offer2,
      offer3,
      offer4
    } = {
      Enum.at(offer_ids, 1),
      Enum.at(offer_ids, 2),
      Enum.at(offer_ids, 3)
    }

    [
      Repo.insert!(%Project{
        addon_id: addon2.id,
        assigned_pro: pro1,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer2.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get(),
        user_id: tp1
      }),
      Repo.insert!(%Project{
        addon_id: addon2.id,
        assigned_pro: pro2,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer2.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get(),
        user_id: tp1
      }),
      Repo.insert!(%Project{
        addon_id: addon2.id,
        assigned_pro: pro3,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer2.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get(),
        user_id: tp1
      }),
      Repo.insert!(%Project{
        addon_id: addon3.id,
        assigned_pro: pro1,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer3.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get(),
        user_id: tp2
      }),
      Repo.insert!(%Project{
        addon_id: addon3.id,
        assigned_pro: pro2,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer3.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get(),
        user_id: tp2
      }),
      Repo.insert!(%Project{
        addon_id: addon3.id,
        assigned_pro: pro3,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer3.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get(),
        user_id: tp2
      }),
      Repo.insert!(%Project{
        addon_id: addon4.id,
        assigned_pro: pro1,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer4.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get(),
        user_id: tp3
      }),
      Repo.insert!(%Project{
        addon_id: addon4.id,
        assigned_pro: pro2,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer4.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get(),
        user_id: tp3
      }),
      Repo.insert!(%Project{
        addon_id: addon4.id,
        assigned_pro: pro3,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer4.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get(),
        user_id: tp3
      })
    ]
  end

  @spec insert_service_review() :: Ecto.Schema.t()
  defp insert_service_review do
    [
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_float(),
        pro_response: Lorem.sentence(),
        professionalism: random_integer(),
        work_quality: random_integer()
      })
    ]
  end

  @spec random_boolean() :: boolean()
  defp random_boolean do
    data = ~W(true false)a
    Enum.random(data)
  end

  @spec random_integer() :: integer()
  defp random_integer(n \\ 99) when is_integer(n) do
    Enum.random(1..n)
  end

  @spec random_float() :: float()
  def random_float do
    :random.uniform() * 100
    |> Float.round(2)
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

  @spec random_project_status :: [String.t()]
  defp random_project_status do
    names = [
      "Canceled",
      "Done",
      "In Progress",
      "In Transition",
      "New"
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

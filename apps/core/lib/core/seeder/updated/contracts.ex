defmodule Core.Seeder.Updated.Contracts do
  @moduledoc """
  An update are seeds whole the contracts.
  """

  alias Core.{
    Accounts.User,
    Contracts,
    Contracts.Addon,
    Contracts.Offer,
    Contracts.Project,
    Contracts.ServiceReview,
    Repo
  }

  alias Faker.Lorem

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_addon()
    update_offer()
    update_project()
    update_service_review()
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

  @spec update_project() :: Ecto.Schema.t()
  defp update_project do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {pro1, pro2, pro3} = {
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    project_ids = Enum.map(Repo.all(Project), fn(data) -> data end)

    {
      project1,
      project2,
      project3,
      project4,
      project5,
      project6,
      project7,
      project8,
      project9
    } = {
      Enum.at(project_ids, 0),
      Enum.at(project_ids, 1),
      Enum.at(project_ids, 2),
      Enum.at(project_ids, 3),
      Enum.at(project_ids, 4),
      Enum.at(project_ids, 5),
      Enum.at(project_ids, 6),
      Enum.at(project_ids, 7),
      Enum.at(project_ids, 8)
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
      Contracts.update_project(project1, %{
        addon_id: addon2.id,
        assigned_pro: pro2,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer2.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get()
      }),
      Contracts.update_project(project2, %{
        addon_id: addon2.id,
        assigned_pro: pro3,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer2.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get()
      }),
      Contracts.update_project(project3, %{
        addon_id: addon2.id,
        assigned_pro: pro1,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer2.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get()
      }),
      Contracts.update_project(project4, %{
        addon_id: addon3.id,
        assigned_pro: pro2,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer3.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get()
      }),
      Contracts.update_project(project5, %{
        addon_id: addon3.id,
        assigned_pro: pro3,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer3.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get()
      }),
      Contracts.update_project(project6, %{
        addon_id: addon3.id,
        assigned_pro: pro1,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer3.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get()
      }),
      Contracts.update_project(project7, %{
        addon_id: addon4.id,
        assigned_pro: pro2,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer4.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get()
      }),
      Contracts.update_project(project8, %{
        addon_id: addon4.id,
        assigned_pro: pro3,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer4.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get()
      }),
      Contracts.update_project(project9, %{
        addon_id: addon4.id,
        assigned_pro: pro1,
        end_time: Date.utc_today(),
        instant_matched: random_boolean(),
        offer_id: offer4.id,
        project_price: random_integer(),
        status: random_project_status(),
        stripe_card_token_id: FlakeId.get()
      })
    ]
  end

  @spec update_service_review() :: Ecto.Schema.t()
  defp update_service_review do
    service_review_ids =
      Enum.map(Repo.all(ServiceReview), fn(data) -> data end)

    { srv1 } = { Enum.at(service_review_ids, 0) }

    [
      Contracts.update_service_review(srv1, %{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_float(),
        pro_response: Lorem.sentence(),
        professionalism: random_integer(),
        work_quality: random_integer()
      })
    ]
  end

  @spec random_integer() :: integer()
  defp random_integer(n \\ 99) when is_integer(n) do
    Enum.random(1..n)
  end

  @spec random_boolean() :: boolean()
  defp random_boolean do
    data = ~W(true false)a
    Enum.random(data)
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

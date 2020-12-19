defmodule Core.Seeder.Updated.Contracts do
  @moduledoc """
  An update are seeds whole the contracts.
  """

  alias Core.{
    Accounts.User,
    Contracts,
    Contracts.Addon,
    Contracts.Offer,
    Contracts.PotentialClient,
    Contracts.Project,
    Contracts.ServiceReview,
    Repo
  }

  alias Faker.Lorem

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_service_review()
    update_project()
    update_potential_client()
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
      addon7,
      addon8,
      addon9
    } = {
      Enum.at(addon_ids, 0),
      Enum.at(addon_ids, 1),
      Enum.at(addon_ids, 2),
      Enum.at(addon_ids, 3),
      Enum.at(addon_ids, 4),
      Enum.at(addon_ids, 5),
      Enum.at(addon_ids, 6),
      Enum.at(addon_ids, 7),
      Enum.at(addon_ids, 8)
    }

    [
      Contracts.update_addon(addon1, %{
        price: random_integer(),
        status: random_status()
      }),
      Contracts.update_addon(addon2, %{
        price: random_integer(),
        status: random_status()
      }),
      Contracts.update_addon(addon3, %{
        price: random_integer(),
        status: random_status()
      }),
      Contracts.update_addon(addon4, %{
        price: random_integer(),
        status: random_status()
      }),
      Contracts.update_addon(addon5, %{
        price: random_integer(),
        status: random_status()
      }),
      Contracts.update_addon(addon6, %{
        price: random_integer(),
        status: random_status()
      }),
      Contracts.update_addon(addon7, %{
        price: random_integer(),
        status: random_status()
      }),
      Contracts.update_addon(addon8, %{
        price: random_integer(),
        status: random_status()
      }),
      Contracts.update_addon(addon9, %{
        price: random_integer(),
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
      offer7,
      offer8,
      offer9
    } = {
      Enum.at(offer_ids, 0),
      Enum.at(offer_ids, 1),
      Enum.at(offer_ids, 2),
      Enum.at(offer_ids, 3),
      Enum.at(offer_ids, 4),
      Enum.at(offer_ids, 5),
      Enum.at(offer_ids, 6),
      Enum.at(offer_ids, 7),
      Enum.at(offer_ids, 8)
    }

    [
      Contracts.update_offer(offer1, %{
        price: random_integer(),
        status: random_status()
      }),
      Contracts.update_offer(offer2, %{
        price: random_integer(),
        status: random_status()
      }),
      Contracts.update_offer(offer3, %{
        price: random_integer(),
        status: random_status()
      }),
      Contracts.update_offer(offer4, %{
        price: random_integer(),
        status: random_status()
      }),
      Contracts.update_offer(offer5, %{
        price: random_integer(),
        status: random_status()
      }),
      Contracts.update_offer(offer6, %{
        price: random_integer(),
        status: random_status()
      }),
      Contracts.update_offer(offer7, %{
        price: random_integer(),
        status: random_status()
      }),
      Contracts.update_offer(offer8, %{
        price: random_integer(),
        status: random_status()
      }),
      Contracts.update_offer(offer9, %{
        price: random_integer(),
        status: random_status()
      })
    ]
  end

  @spec update_project() :: Ecto.Schema.t()
  defp update_project do
    %User{id: pro1} = Repo.get_by(User, %{email: "support@taxgig.com"})
    %User{id: pro2} = Repo.get_by(User, %{email: "vk@taxgig.com"})
    %User{id: pro3} = Repo.get_by(User, %{email: "op@taxgig.com"})

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

    [
      Contracts.update_project(project1, %{
        addon_price: random_integer(),
        assigned_pro: pro2,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HGMdsre2yNYS1KlMqTP7Hkw",
        id_from_stripe_transfer: "tr_1HFksnldFHW3Alzp8qtrMkub",
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        status: random_project_status()
      }),
      Contracts.update_project(project2, %{
        addon_price: random_integer(),
        assigned_pro: pro3,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HKawbxc7sFA9kmL4DFwmc91",
        id_from_stripe_transfer: "tr_1HALhdvNQlF1M7HyrpAZ6oGM",
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        status: random_project_status()
      }),
      Contracts.update_project(project3, %{
        addon_price: random_integer(),
        assigned_pro: pro1,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HRdjqwMv6AD8CxzLq5htRV7",
        id_from_stripe_transfer: "tr_1HAQmkdvbzas7wE2tR6MA8B9",
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        status: random_project_status()
      }),
      Contracts.update_project(project4, %{
        addon_price: random_integer(),
        assigned_pro: pro2,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HIKf6DQwe3NZ0JklMAS5qhT",
        id_from_stripe_transfer: "tr_1HABkqWel7CvsazKLA8GO3Jm",
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        status: random_project_status()
      }),
      Contracts.update_project(project5, %{
        addon_price: random_integer(),
        assigned_pro: pro3,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HCD5sDQlm7Cxs9Afbzyt4Mw",
        id_from_stripe_transfer: "tr_1HLdf5AlMCV4qwErxt7JAqVi",
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        status: random_project_status()
      }),
      Contracts.update_project(project6, %{
        addon_price: random_integer(),
        assigned_pro: pro1,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HV5Dgqxcd8DF3mSA7Nfkeq1",
        id_from_stripe_transfer: "tr_1HW4Gawqlor6NrQwe0ndf751",
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        status: random_project_status()
      }),
      Contracts.update_project(project7, %{
        addon_price: random_integer(),
        assigned_pro: pro2,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HChtqwe4VnBaZX6Lkqwe1Ju",
        id_from_stripe_transfer: "tr_1HF3jKqWvam8Su1KM7DrAlz9",
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        status: random_project_status()
      }),
      Contracts.update_project(project8, %{
        addon_price: random_integer(),
        assigned_pro: pro3,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HT6kisrtNX3pO5hQmavNXzP",
        id_from_stripe_transfer: "tr_1HX9kquTr0FM2Csqp9MJaYLg",
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        status: random_project_status()
      }),
      Contracts.update_project(project9, %{
        addon_price: random_integer(),
        assigned_pro: pro1,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HNPuaw1bNaSPUWqN8Dp9QxT",
        id_from_stripe_transfer: "tr_1HO8nQ8D5N7f1art7NPaX0Iq",
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        status: random_project_status()
      })
    ]
  end

  @spec update_service_review() :: Ecto.Schema.t()
  defp update_service_review do
    service_review_ids =
      Enum.map(Repo.all(ServiceReview), fn(data) -> data end)

    {
      srv1,
      srv2,
      srv3,
      srv4,
      srv5,
      srv6,
      srv7,
      srv8,
      srv9
    } = {
      Enum.at(service_review_ids, 0),
      Enum.at(service_review_ids, 1),
      Enum.at(service_review_ids, 2),
      Enum.at(service_review_ids, 3),
      Enum.at(service_review_ids, 4),
      Enum.at(service_review_ids, 5),
      Enum.at(service_review_ids, 6),
      Enum.at(service_review_ids, 7),
      Enum.at(service_review_ids, 8)
    }

    [
      Contracts.update_service_review(srv1, %{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        work_quality: random_integer()
      }),
      Contracts.update_service_review(srv2, %{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        work_quality: random_integer()
      }),
      Contracts.update_service_review(srv3, %{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        work_quality: random_integer()
      }),
      Contracts.update_service_review(srv4, %{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        work_quality: random_integer()
      }),
      Contracts.update_service_review(srv5, %{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        work_quality: random_integer()
      }),
      Contracts.update_service_review(srv6, %{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        work_quality: random_integer()
      }),
      Contracts.update_service_review(srv7, %{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        work_quality: random_integer()
      }),
      Contracts.update_service_review(srv8, %{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        work_quality: random_integer()
      }),
      Contracts.update_service_review(srv9, %{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        work_quality: random_integer()
      })
    ]
  end

  @spec update_potential_client() :: Ecto.Schema.t()
  defp update_potential_client do
    potential_client_ids =
      Enum.map(Repo.all(PotentialClient), fn(data) -> data end)

    {
      client1,
      client2,
      client3
    } = {
      Enum.at(potential_client_ids, 0),
      Enum.at(potential_client_ids, 1),
      Enum.at(potential_client_ids, 2)
    }

    project_ids =
      Enum.map(Repo.all(Project), fn(data) -> data.id end)

    [
      Contracts.update_potential_client(client1, %{
        project: random_project(project_ids)
      }),
      Contracts.update_potential_client(client2, %{
        project: random_project(project_ids)
      }),
      Contracts.update_potential_client(client3, %{
        project: random_project(project_ids)
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

  @spec random_project([String.t()]) :: [String.t()]
  defp random_project(ids) do
    numbers = 1..9
    number = Enum.random(numbers)

    result =
      for i <- 1..number, i > 0 do
        Enum.random(ids)
      end
      |> Enum.uniq()

    result
  end
end

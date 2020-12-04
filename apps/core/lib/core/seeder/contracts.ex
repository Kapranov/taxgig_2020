defmodule Core.Seeder.Contracts do
  @moduledoc """
  Seeds for `Core.Contracts` context.
  """

  alias Core.{
    Accounts.User,
    Contracts,
    Contracts.Addon,
    Contracts.Offer,
    Contracts.PotentialClient,
    Contracts.Project,
    Contracts.ServiceReview,
    Repo,
    Services.BookKeeping,
    Services.BusinessTaxReturn,
    Services.IndividualTaxReturn,
    Services.SaleTax
  }

  alias Faker.Lorem

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(Addon)
    Repo.delete_all(Offer)
    Repo.delete_all(PotentialClient)
    Repo.delete_all(Project)
    Repo.delete_all(ServiceReview)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_addon()
    seed_offer()
    seed_service_review()
    seed_project()
    seed_potential_client()
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

  @spec seed_potential_client() :: nil | Ecto.Schema.t()
  defp seed_potential_client do
    case Repo.aggregate(PotentialClient, :count, :id) > 0 do
      true -> nil
      false -> insert_potential_client()
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

    {pro1, pro2, pro3} = {
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    [
      Repo.insert!(%Addon{
        price: random_integer(),
        status: random_status(),
        user_id: pro1
      }),
      Repo.insert!(%Addon{
        price: random_integer(),
        status: random_status(),
        user_id: pro1
      }),
      Repo.insert!(%Addon{
        price: random_integer(),
        status: random_status(),
        user_id: pro1
      }),
      Repo.insert!(%Addon{
        price: random_integer(),
        status: random_status(),
        user_id: pro2
      }),
      Repo.insert!(%Addon{
        price: random_integer(),
        status: random_status(),
        user_id: pro2
      }),
      Repo.insert!(%Addon{
        price: random_integer(),
        status: random_status(),
        user_id: pro2
      }),
      Repo.insert!(%Addon{
        price: random_integer(),
        status: random_status(),
        user_id: pro3
      }),
      Repo.insert!(%Addon{
        price: random_integer(),
        status: random_status(),
        user_id: pro3
      }),
      Repo.insert!(%Addon{
        price: random_integer(),
        status: random_status(),
        user_id: pro3
      })
    ]
  end

  @spec insert_offer() :: Ecto.Schema.t()
  defp insert_offer do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {pro1, pro2, pro3} = {
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    [
      Repo.insert!(%Offer{
        price: random_integer(),
        status: random_status(),
        user_id: pro1
      }),
      Repo.insert!(%Offer{
        price: random_integer(),
        status: random_status(),
        user_id: pro1
      }),
      Repo.insert!(%Offer{
        price: random_integer(),
        status: random_status(),
        user_id: pro1
      }),
      Repo.insert!(%Offer{
        price: random_integer(),
        status: random_status(),
        user_id: pro2
      }),
      Repo.insert!(%Offer{
        price: random_integer(),
        status: random_status(),
        user_id: pro2
      }),
      Repo.insert!(%Offer{
        price: random_integer(),
        status: random_status(),
        user_id: pro2
      }),
      Repo.insert!(%Offer{
        price: random_integer(),
        status: random_status(),
        user_id: pro3
      }),
      Repo.insert!(%Offer{
        price: random_integer(),
        status: random_status(),
        user_id: pro3
      }),
      Repo.insert!(%Offer{
        price: random_integer(),
        status: random_status(),
        user_id: pro3
      })
    ]
  end

  @spec insert_service_review() :: Ecto.Schema.t()
  defp insert_service_review do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {tp1, tp2, tp3} = {
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3)
    }

    [
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_float(),
        pro_response: Lorem.sentence(),
        professionalism: random_integer(),
        user_id: tp1,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_float(),
        pro_response: Lorem.sentence(),
        professionalism: random_integer(),
        user_id: tp1,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_float(),
        pro_response: Lorem.sentence(),
        professionalism: random_integer(),
        user_id: tp1,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_float(),
        pro_response: Lorem.sentence(),
        professionalism: random_integer(),
        user_id: tp2,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_float(),
        pro_response: Lorem.sentence(),
        professionalism: random_integer(),
        user_id: tp2,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_float(),
        pro_response: Lorem.sentence(),
        professionalism: random_integer(),
        user_id: tp2,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_float(),
        pro_response: Lorem.sentence(),
        professionalism: random_integer(),
        user_id: tp3,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_float(),
        pro_response: Lorem.sentence(),
        professionalism: random_integer(),
        user_id: tp3,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_float(),
        pro_response: Lorem.sentence(),
        professionalism: random_integer(),
        user_id: tp3,
        work_quality: random_integer()
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

    tp1_book_keeping = Repo.get_by(BookKeeping, %{user_id: tp1})
    tp2_book_keeping = Repo.get_by(BookKeeping, %{user_id: tp2})

    tp1_business_tax_return = Repo.get_by(BusinessTaxReturn, %{user_id: tp1})
    tp2_business_tax_return = Repo.get_by(BusinessTaxReturn, %{user_id: tp2})
    tp3_business_tax_return = Repo.get_by(BusinessTaxReturn, %{user_id: tp3})

    tp1_individual_tax_return = Repo.get_by(IndividualTaxReturn, %{user_id: tp1})
    tp3_individual_tax_return = Repo.get_by(IndividualTaxReturn, %{user_id: tp3})

    tp2_sale_tax = Repo.get_by(SaleTax, %{user_id: tp2})
    tp3_sale_tax = Repo.get_by(SaleTax, %{user_id: tp3})

    [
      Contracts.create_project(%{
        addon_price: random_integer(),
        assigned_pro: pro1,
        book_keeping_id: tp1_book_keeping.id,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HGMdsre2yNYS1KlMqTP7Hkw",
        id_from_stripe_transfer: "tr_1HFksnldFHW3Alzp8qtrMkub",
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        status: random_project_status(),
        user_id: tp1
      }),
      Contracts.create_project(%{
        addon_price: random_integer(),
        assigned_pro: pro2,
        business_tax_return_id: tp1_business_tax_return.id,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HKawbxc7sFA9kmL4DFwmc91",
        id_from_stripe_transfer: "tr_1HALhdvNQlF1M7HyrpAZ6oGM",
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        status: random_project_status(),
        user_id: tp1
      }),
      Contracts.create_project(%{
        addon_price: random_integer(),
        assigned_pro: pro3,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HRdjqwMv6AD8CxzLq5htRV7",
        id_from_stripe_transfer: "tr_1HAQmkdvbzas7wE2tR6MA8B9",
        individual_tax_return_id: tp1_individual_tax_return.id,
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        status: random_project_status(),
        user_id: tp1
      }),
      Contracts.create_project(%{
        addon_price: random_integer(),
        assigned_pro: pro1,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HIKf6DQwe3NZ0JklMAS5qhT",
        id_from_stripe_transfer: "tr_1HABkqWel7CvsazKLA8GO3Jm",
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        sale_tax_id: tp2_sale_tax.id,
        status: random_project_status(),
        user_id: tp2
      }),
      Contracts.create_project(%{
        addon_price: random_integer(),
        assigned_pro: pro2,
        book_keeping_id: tp2_book_keeping.id,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HCD5sDQlm7Cxs9Afbzyt4Mw",
        id_from_stripe_transfer: "tr_1HLdf5AlMCV4qwErxt7JAqVi",
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        status: random_project_status(),
        user_id: tp2
      }),
      Contracts.create_project(%{
        addon_price: random_integer(),
        assigned_pro: pro3,
        business_tax_return_id: tp2_business_tax_return.id,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HV5Dgqxcd8DF3mSA7Nfkeq1",
        id_from_stripe_transfer: "tr_1HW4Gawqlor6NrQwe0ndf751",
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        status: random_project_status(),
        user_id: tp2
      }),
      Contracts.create_project(%{
        addon_price: random_integer(),
        assigned_pro: pro1,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HChtqwe4VnBaZX6Lkqwe1Ju",
        id_from_stripe_transfer: "tr_1HF3jKqWvam8Su1KM7DrAlz9",
        individual_tax_return_id: tp3_individual_tax_return.id,
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        status: random_project_status(),
        user_id: tp3
      }),
      Contracts.create_project(%{
        addon_price: random_integer(),
        assigned_pro: pro2,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HT6kisrtNX3pO5hQmavNXzP",
        id_from_stripe_transfer: "tr_1HX9kquTr0FM2Csqp9MJaYLg",
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        sale_tax_id: tp3_sale_tax.id,
        status: random_project_status(),
        user_id: tp3
      }),
      Contracts.create_project(%{
        addon_price: random_integer(),
        assigned_pro: pro3,
        business_tax_return_id: tp3_business_tax_return.id,
        end_time: Date.utc_today(),
        id_from_stripe_card: "card_1HNPuaw1bNaSPUWqN8Dp9QxT",
        id_from_stripe_transfer: "tr_1HO8nQ8D5N7f1art7NPaX0Iq",
        instant_matched: random_boolean(),
        offer_price: random_integer(),
        status: random_project_status(),
        user_id: tp3
      })
    ]
  end

  @spec insert_potential_client() :: Ecto.Schema.t()
  defp insert_potential_client do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {pro1, pro2, pro3} = {
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    project_ids =
      Enum.map(Repo.all(Project), fn(data) -> data.id end)

    [
      Repo.insert!(%PotentialClient{
        project: random_project(project_ids),
        user_id: pro1
      }),
      Repo.insert!(%PotentialClient{
        project: random_project(project_ids),
        user_id: pro2
      }),
      Repo.insert!(%PotentialClient{
        project: random_project(project_ids),
        user_id: pro3
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

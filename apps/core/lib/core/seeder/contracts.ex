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

  alias Ecto.Adapters.SQL
  alias Faker.Lorem

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    IO.puts("Deleting old data...\n")
    SQL.query!(Repo, "TRUNCATE addons CASCADE;")
    SQL.query!(Repo, "TRUNCATE offers CASCADE;")
    SQL.query!(Repo, "TRUNCATE potential_clients CASCADE;")
    SQL.query!(Repo, "TRUNCATE projects CASCADE;")
    SQL.query!(Repo, "TRUNCATE service_reviews CASCADE;")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_service_review()
    seed_project()
    seed_potential_client()
    seed_addon()
    seed_offer()
  end

  @spec seed_service_review() :: nil | Ecto.Schema.t()
  defp seed_service_review do
    case Repo.aggregate(ServiceReview, :count, :id) > 0 do
      true -> nil
      false -> insert_service_review()
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

  @spec insert_service_review() :: Ecto.Schema.t()
  defp insert_service_review do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {tp1, tp2, tp3, tp4, tp5} = {
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5)
    }

    [
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        user_id: tp1,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        user_id: tp1,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        user_id: tp1,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        user_id: tp2,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        user_id: tp2,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        user_id: tp2,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        user_id: tp3,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        user_id: tp3,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        user_id: tp3,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        user_id: tp4,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        user_id: tp4,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        user_id: tp4,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        user_id: tp5,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        user_id: tp5,
        work_quality: random_integer()
      }),
      Repo.insert!(%ServiceReview{
        client_comment: Lorem.sentence(),
        communication: random_integer(),
        final_rating: random_integer(),
        professionalism: random_integer(),
        user_id: tp5,
        work_quality: random_integer()
      })
    ]
  end

  @spec insert_project() :: Ecto.Schema.t()
  defp insert_project do
    %User{id: tp1} = Repo.get_by(User, %{email: "kapranov.lugatex@gmail.com"})
    %User{id: tp2} = Repo.get_by(User, %{email: "kapranov.pure@gmail.com"})
    %User{id: tp3} = Repo.get_by(User, %{email: "v.kobzan@gmail.com"})
    %User{id: tp4} = Repo.get_by(User, %{email: "o.puryshev@gmail.com"})
    %User{id: tp5} = Repo.get_by(User, %{email: "vlacho777@gmail.com"})

    service_review_ids =
      Enum.map(Repo.all(ServiceReview), fn(data) -> data.id end)

    {srv1, srv2, srv3, srv4, srv5, srv6, srv7, srv8, srv9, srv10, srv11, srv12, srv13, srv14, srv15} = {
      Enum.at(service_review_ids, 0),
      Enum.at(service_review_ids, 1),
      Enum.at(service_review_ids, 2),
      Enum.at(service_review_ids, 3),
      Enum.at(service_review_ids, 4),
      Enum.at(service_review_ids, 5),
      Enum.at(service_review_ids, 6),
      Enum.at(service_review_ids, 7),
      Enum.at(service_review_ids, 8),
      Enum.at(service_review_ids, 9),
      Enum.at(service_review_ids, 10),
      Enum.at(service_review_ids, 11),
      Enum.at(service_review_ids, 12),
      Enum.at(service_review_ids, 13),
      Enum.at(service_review_ids, 14)
    }

    tp1_book_keeping = Repo.get_by(BookKeeping, %{user_id: tp1})
    tp2_book_keeping = Repo.get_by(BookKeeping, %{user_id: tp2})
    tp4_book_keeping = Repo.get_by(BookKeeping, %{user_id: tp4})
    tp5_book_keeping = Repo.get_by(BookKeeping, %{user_id: tp5})

    tp1_business_tax_return = Repo.get_by(BusinessTaxReturn, %{user_id: tp1})
    tp2_business_tax_return = Repo.get_by(BusinessTaxReturn, %{user_id: tp2})
    tp3_business_tax_return = Repo.get_by(BusinessTaxReturn, %{user_id: tp3})
    tp5_business_tax_return = Repo.get_by(BusinessTaxReturn, %{user_id: tp5})

    tp1_individual_tax_return = Repo.get_by(IndividualTaxReturn, %{user_id: tp1})
    tp3_individual_tax_return = Repo.get_by(IndividualTaxReturn, %{user_id: tp3})
    tp4_individual_tax_return = Repo.get_by(IndividualTaxReturn, %{user_id: tp4})

    tp2_sale_tax = Repo.get_by(SaleTax, %{user_id: tp2})
    tp3_sale_tax = Repo.get_by(SaleTax, %{user_id: tp3})
    tp4_sale_tax = Repo.get_by(SaleTax, %{user_id: tp4})
    tp5_sale_tax = Repo.get_by(SaleTax, %{user_id: tp5})

    [
      Contracts.create_project(%{
        book_keeping_id: tp1_book_keeping.id,
        id_from_stripe_card: "card_1HGMdsre2yNYS1KlMqTP7Hkw",
        id_from_stripe_transfer: "tr_1HFksnldFHW3Alzp8qtrMkub",
        instant_matched: random_boolean(),
        service_review_id: srv1,
        status: random_project_status(),
        user_id: tp1
      }),
      Contracts.create_project(%{
        business_tax_return_id: tp1_business_tax_return.id,
        id_from_stripe_card: "card_1HKawbxc7sFA9kmL4DFwmc91",
        id_from_stripe_transfer: "tr_1HALhdvNQlF1M7HyrpAZ6oGM",
        instant_matched: random_boolean(),
        service_review_id: srv2,
        status: random_project_status(),
        user_id: tp1
      }),
      Contracts.create_project(%{
        id_from_stripe_card: "card_1HRdjqwMv6AD8CxzLq5htRV7",
        id_from_stripe_transfer: "tr_1HAQmkdvbzas7wE2tR6MA8B9",
        individual_tax_return_id: tp1_individual_tax_return.id,
        instant_matched: random_boolean(),
        service_review_id: srv3,
        status: random_project_status(),
        user_id: tp1
      }),
      Contracts.create_project(%{
        id_from_stripe_card: "card_1HIKf6DQwe3NZ0JklMAS5qhT",
        id_from_stripe_transfer: "tr_1HABkqWel7CvsazKLA8GO3Jm",
        instant_matched: random_boolean(),
        sale_tax_id: tp2_sale_tax.id,
        service_review_id: srv4,
        status: random_project_status(),
        user_id: tp2
      }),
      Contracts.create_project(%{
        book_keeping_id: tp2_book_keeping.id,
        id_from_stripe_card: "card_1HCD5sDQlm7Cxs9Afbzyt4Mw",
        id_from_stripe_transfer: "tr_1HLdf5AlMCV4qwErxt7JAqVi",
        instant_matched: random_boolean(),
        service_review_id: srv5,
        status: random_project_status(),
        user_id: tp2
      }),
      Contracts.create_project(%{
        business_tax_return_id: tp2_business_tax_return.id,
        id_from_stripe_card: "card_1HV5Dgqxcd8DF3mSA7Nfkeq1",
        id_from_stripe_transfer: "tr_1HW4Gawqlor6NrQwe0ndf751",
        instant_matched: random_boolean(),
        service_review_id: srv6,
        status: random_project_status(),
        user_id: tp2
      }),
      Contracts.create_project(%{
        id_from_stripe_card: "card_1HChtqwe4VnBaZX6Lkqwe1Ju",
        id_from_stripe_transfer: "tr_1HF3jKqWvam8Su1KM7DrAlz9",
        individual_tax_return_id: tp3_individual_tax_return.id,
        instant_matched: random_boolean(),
        service_review_id: srv7,
        status: random_project_status(),
        user_id: tp3
      }),
      Contracts.create_project(%{
        id_from_stripe_card: "card_1HT6kisrtNX3pO5hQmavNXzP",
        id_from_stripe_transfer: "tr_1HX9kquTr0FM2Csqp9MJaYLg",
        instant_matched: random_boolean(),
        sale_tax_id: tp3_sale_tax.id,
        service_review_id: srv8,
        status: random_project_status(),
        user_id: tp3
      }),
      Contracts.create_project(%{
        business_tax_return_id: tp3_business_tax_return.id,
        id_from_stripe_card: "card_1HNPuaw1bNaSPUWqN8Dp9QxT",
        id_from_stripe_transfer: "tr_1HO8nQ8D5N7f1art7NPaX0Iq",
        instant_matched: random_boolean(),
        offer_price: random_float(),
        service_review_id: srv9,
        status: random_project_status(),
        user_id: tp3
      }),
      Contracts.create_project(%{
        id_from_stripe_card: "card_1HNPuaw1bNaSPUWqN8Dp9QxT",
        id_from_stripe_transfer: "tr_1HO8nQ8D5N7f1art7NPaX0Iq",
        individual_tax_return_id: tp4_individual_tax_return.id,
        instant_matched: random_boolean(),
        service_review_id: srv10,
        status: random_project_status(),
        user_id: tp4
      }),
      Contracts.create_project(%{
        book_keeping_id: tp4_book_keeping.id,
        id_from_stripe_card: "card_1HNPuaw1bNaSPUWqN8Dp9QxT",
        id_from_stripe_transfer: "tr_1HO8nQ8D5N7f1art7NPaX0Iq",
        instant_matched: random_boolean(),
        service_review_id: srv11,
        status: random_project_status(),
        user_id: tp4
      }),
      Contracts.create_project(%{
        id_from_stripe_card: "card_1HNPuaw1bNaSPUWqN8Dp9QxT",
        id_from_stripe_transfer: "tr_1HO8nQ8D5N7f1art7NPaX0Iq",
        instant_matched: random_boolean(),
        sale_tax_id: tp4_sale_tax.id,
        service_review_id: srv12,
        status: random_project_status(),
        user_id: tp4
      }),
      Contracts.create_project(%{
        id_from_stripe_card: "card_1HNPuaw1bNaSPUWqN8Dp9QxT",
        id_from_stripe_transfer: "tr_1HO8nQ8D5N7f1art7NPaX0Iq",
        instant_matched: random_boolean(),
        sale_tax_id: tp5_sale_tax.id,
        service_review_id: srv13,
        status: random_project_status(),
        user_id: tp5
      }),
      Contracts.create_project(%{
        business_tax_return_id: tp5_business_tax_return.id,
        id_from_stripe_card: "card_1HNPuaw1bNaSPUWqN8Dp9QxT",
        id_from_stripe_transfer: "tr_1HO8nQ8D5N7f1art7NPaX0Iq",
        instant_matched: random_boolean(),
        service_review_id: srv14,
        status: random_project_status(),
        user_id: tp5
      }),
      Contracts.create_project(%{
        book_keeping_id: tp5_book_keeping.id,
        id_from_stripe_card: "card_1HNPuaw1bNaSPUWqN8Dp9QxT",
        id_from_stripe_transfer: "tr_1HO8nQ8D5N7f1art7NPaX0Iq",
        instant_matched: random_boolean(),
        service_review_id: srv15,
        status: random_project_status(),
        user_id: tp5
      })
    ]
  end

  @spec insert_potential_client() :: Ecto.Schema.t()
  defp insert_potential_client do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {pro1, pro2, pro3} = {
      Enum.at(user_ids, 6),
      Enum.at(user_ids, 7),
      Enum.at(user_ids, 8)
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

  @spec insert_addon() :: Ecto.Schema.t()
  defp insert_addon do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {pro1, pro2, pro3} = {
      Enum.at(user_ids, 6),
      Enum.at(user_ids, 7),
      Enum.at(user_ids, 8)
    }

    project_ids =
      Enum.map(Repo.all(Project), fn(data) -> data.id end)

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
      Repo.insert!(%Addon{
        price: random_integer(),
        project_id: project1,
        status: random_status(),
        user_id: pro1
      }),
      Repo.insert!(%Addon{
        price: random_integer(),
        project_id: project2,
        status: random_status(),
        user_id: pro1
      }),
      Repo.insert!(%Addon{
        price: random_integer(),
        project_id: project3,
        status: random_status(),
        user_id: pro1
      }),
      Repo.insert!(%Addon{
        price: random_integer(),
        project_id: project4,
        status: random_status(),
        user_id: pro2
      }),
      Repo.insert!(%Addon{
        price: random_integer(),
        project_id: project5,
        status: random_status(),
        user_id: pro2
      }),
      Repo.insert!(%Addon{
        price: random_integer(),
        project_id: project6,
        status: random_status(),
        user_id: pro2
      }),
      Repo.insert!(%Addon{
        price: random_integer(),
        project_id: project7,
        status: random_status(),
        user_id: pro3
      }),
      Repo.insert!(%Addon{
        price: random_integer(),
        project_id: project8,
        status: random_status(),
        user_id: pro3
      }),
      Repo.insert!(%Addon{
        price: random_integer(),
        project_id: project9,
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
      Enum.at(user_ids, 6),
      Enum.at(user_ids, 7),
      Enum.at(user_ids, 8)
    }

    project_ids =
      Enum.map(Repo.all(Project), fn(data) -> data.id end)

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
      Repo.insert!(%Offer{
        price: random_integer(),
        project_id: project1,
        status: random_status(),
        user_id: pro1
      }),
      Repo.insert!(%Offer{
        price: random_integer(),
        project_id: project2,
        status: random_status(),
        user_id: pro1
      }),
      Repo.insert!(%Offer{
        price: random_integer(),
        project_id: project3,
        status: random_status(),
        user_id: pro1
      }),
      Repo.insert!(%Offer{
        price: random_integer(),
        project_id: project4,
        status: random_status(),
        user_id: pro2
      }),
      Repo.insert!(%Offer{
        price: random_integer(),
        project_id: project5,
        status: random_status(),
        user_id: pro2
      }),
      Repo.insert!(%Offer{
        price: random_integer(),
        project_id: project6,
        status: random_status(),
        user_id: pro2
      }),
      Repo.insert!(%Offer{
        price: random_integer(),
        project_id: project7,
        status: random_status(),
        user_id: pro3
      }),
      Repo.insert!(%Offer{
        price: random_integer(),
        project_id: project8,
        status: random_status(),
        user_id: pro3
      }),
      Repo.insert!(%Offer{
        price: random_integer(),
        project_id: project9,
        status: random_status(),
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

  @spec random_project_status :: String.t()
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

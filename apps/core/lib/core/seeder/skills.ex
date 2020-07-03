defmodule Core.Seeder.Skills do
  @moduledoc """
  Seeds for `Core.Skills` context.
  """

  alias Core.{
    Accounts.User,
    Repo,
    Skills.AccountingSoftware,
    Skills.Education,
    Skills.University,
    Skills.WorkExperience
  }

  alias Faker.Lorem

  @root_dir Path.expand("../../../priv/data/", __DIR__)
  @universities "#{@root_dir}/university.json"

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(AccountingSoftware)
    Repo.delete_all(Education)
    Repo.delete_all(University)
    Repo.delete_all(WorkExperience)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_universities()
    seed_accounting_softwares()
    seed_educations()
    seed_work_experiences()
  end

  @spec seed_accounting_softwares() :: nil | Ecto.Schema.t()
  defp seed_accounting_softwares do
    case Repo.aggregate(AccountingSoftware, :count, :id) > 0 do
      true -> nil
      false -> insert_accounting_software()
    end
  end

  @spec seed_educations() :: nil | Ecto.Schema.t()
  defp seed_educations do
    case Repo.aggregate(Education, :count, :id) > 0 do
      true -> nil
      false -> insert_education()
    end
  end

  @spec seed_universities() :: nil | Ecto.Schema.t()
  defp seed_universities do
    case Repo.aggregate(University, :count, :id) > 0 do
      true -> nil
      false -> insert_university()
    end
  end

  @spec seed_work_experiences() :: nil | Ecto.Schema.t()
  defp seed_work_experiences do
    case Repo.aggregate(WorkExperience, :count, :id) > 0 do
      true -> nil
      false -> insert_work_experience()
    end
  end

  defp insert_accounting_software do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data end)

    {
      user1, user2, user3, user4
    } = {
      Enum.at(user_ids, 0),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    Repo.insert!(%AccountingSoftware{
      name: ["Xero HQ", "QuickBooks Live Bookkeeping", "QuickBooks Desktop Premier"],
      user_id: user1.id
    })
    Repo.insert!(%AccountingSoftware{
      name: ["QuickBooks Online", "Xero Practice Manager"],
      user_id: user2.id
    })
    Repo.insert!(%AccountingSoftware{
      name: ["QuickBooks Desktop Pro", "Xero HQ", "QuickBooks Online", "QuickBooks Enterprise"],
      user_id: user3.id
    })
    Repo.insert!(%AccountingSoftware{
      name: ["QuickBooks Desktop Pro", "Xero Cashbook/Ledger", "Xero Workpapers", "Xero HQ", "QuickBooks Online"],
      user_id: user4.id
    })
  end

  defp insert_education do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data end)

    {
      user1, user2, user3, user4
    } = {
      Enum.at(user_ids, 0),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    univer_ids =
      Enum.map(Repo.all(University), fn(data) -> data end)

    {
      univer1, univer2, univer3, univer4
    } = {
      Enum.at(univer_ids, 0),
      Enum.at(univer_ids, 1),
      Enum.at(univer_ids, 2),
      Enum.at(univer_ids, 3)
    }

    Repo.insert!(%Education{
      course: Lorem.word(),
      graduation: Date.utc_today |> Date.add(-66),
      university_id: univer1.id,
      user_id:   user1.id
    })
    Repo.insert!(%Education{
      course: Lorem.word(),
      graduation: Date.utc_today |> Date.add(-389),
      university_id: univer2.id,
      user_id:   user2.id
    })
    Repo.insert!(%Education{
      course: Lorem.word(),
      graduation: Date.utc_today |> Date.add(-845),
      university_id: univer3.id,
      user_id:   user3.id
    })
    Repo.insert!(%Education{
      course: Lorem.word(),
      graduation: Date.utc_today |> Date.add(-999),
      university_id: univer4.id,
      user_id:   user4.id
    })
  end

  defp insert_work_experience do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data end)

    {
      user1, user2, user3, user4
    } = {
      Enum.at(user_ids, 0),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    Repo.insert!(%WorkExperience{
      end_date: Date.utc_today |> Date.add(-1),
      name: Lorem.word(),
      start_date: Date.utc_today |> Date.add(-3),
      user_id: user1.id
    })
    Repo.insert!(%WorkExperience{
      end_date: Date.utc_today |> Date.add(-6),
      name: Lorem.word(),
      start_date: Date.utc_today |> Date.add(-9),
      user_id: user2.id
    })
    Repo.insert!(%WorkExperience{
      end_date: Date.utc_today |> Date.add(-88),
      name: Lorem.word(),
      start_date: Date.utc_today |> Date.add(-99),
      user_id: user3.id
    })
    Repo.insert!(%WorkExperience{
      end_date: Date.utc_today |> Date.add(-18),
      name: Lorem.word(),
      start_date: Date.utc_today |> Date.add(-23),
      user_id: user4.id
    })
  end

  defp insert_university do
    names =
      @universities
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(fn %{"name" => name} ->
         %{name: name}
      end)

    Repo.insert_all(University, names)
  end
end

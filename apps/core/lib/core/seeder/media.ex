defmodule Core.Seeder.Media do
  @moduledoc """
  Seeds for `Core.Media` context.
  """

  alias Core.{
    Accounts.User,
    Contracts.Project,
    Media.Picture,
    Media.ProDoc,
    Media.TpDoc,
    Repo
  }

  alias Ecto.Adapters.SQL

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    IO.puts("Deleting old data...\n")
    SQL.query!(Repo, "TRUNCATE pictures CASCADE;")
    SQL.query!(Repo, "TRUNCATE pro_docs CASCADE;")
    SQL.query!(Repo, "TRUNCATE tp_docs CASCADE;")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_picture()
    seed_pro_doc()
    seed_tp_doc()
  end

  @spec seed_picture() :: nil | Ecto.Schema.t()
  defp seed_picture do
    case Repo.aggregate(Picture, :count, :id) > 0 do
      true -> nil
      false -> insert_picture()
    end
  end

  @spec seed_pro_doc() :: nil | Ecto.Schema.t()
  defp seed_pro_doc do
    case Repo.aggregate(ProDoc, :count, :id) > 0 do
      true -> nil
      false -> insert_pro_doc()
    end
  end

  @spec seed_tp_doc() :: nil | Ecto.Schema.t()
  defp seed_tp_doc do
    case Repo.aggregate(TpDoc, :count, :id) > 0 do
      true -> nil
      false -> insert_tp_doc()
    end
  end

  @spec insert_picture() :: Ecto.Schema.t()
  defp insert_picture do
  end

  @spec insert_pro_doc() :: Ecto.Schema.t()
  defp insert_pro_doc do
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
      Repo.insert!(%ProDoc{
        category: random_category(),
        project_id: random_project(project_ids),
        signature: random_boolean(),
        signed_by_pro: random_boolean(),
        user_id: pro1
      }),
      Repo.insert!(%ProDoc{
        category: random_category(),
        project_id: random_project(project_ids),
        signature: random_boolean(),
        signed_by_pro: random_boolean(),
        user_id: pro2
      }),
      Repo.insert!(%ProDoc{
        category: random_category(),
        project_id: random_project(project_ids),
        signature: random_boolean(),
        signed_by_pro: random_boolean(),
        user_id: pro3
      })
    ]
  end

  @spec insert_tp_doc() :: Ecto.Schema.t()
  defp insert_tp_doc do
    project_ids =
      Enum.map(Repo.all(Project), fn(data) -> data.id end)

    {
      prj1, prj2, prj3, prj4, prj5, prj6, prj7, prj8,
      prj9, prj10, prj11, prj12, prj13, prj14, prj15
    } = {
      Enum.at(project_ids, 0),
      Enum.at(project_ids, 1),
      Enum.at(project_ids, 2),

      Enum.at(project_ids, 3),
      Enum.at(project_ids, 4),
      Enum.at(project_ids, 5),

      Enum.at(project_ids, 6),
      Enum.at(project_ids, 7),
      Enum.at(project_ids, 8),

      Enum.at(project_ids, 9),
      Enum.at(project_ids, 10),
      Enum.at(project_ids, 11),

      Enum.at(project_ids, 12),
      Enum.at(project_ids, 13),
      Enum.at(project_ids, 14)
    }

    [
      Repo.insert!(%TpDoc{
        access_granted: random_boolean(),
        category: random_category(),
        project_id: prj1,
        signed_by_tp: random_boolean()
      }),
      Repo.insert!(%TpDoc{
        access_granted: random_boolean(),
        category: random_category(),
        project_id: prj2,
        signed_by_tp: random_boolean()
      }),
      Repo.insert!(%TpDoc{
        access_granted: random_boolean(),
        category: random_category(),
        project_id: prj3,
        signed_by_tp: random_boolean()
      }),
      Repo.insert!(%TpDoc{
        access_granted: random_boolean(),
        category: random_category(),
        project_id: prj4,
        signed_by_tp: random_boolean()
      }),
      Repo.insert!(%TpDoc{
        access_granted: random_boolean(),
        category: random_category(),
        project_id: prj5,
        signed_by_tp: random_boolean()
      }),
      Repo.insert!(%TpDoc{
        access_granted: random_boolean(),
        category: random_category(),
        project_id: prj6,
        signed_by_tp: random_boolean()
      }),
      Repo.insert!(%TpDoc{
        access_granted: random_boolean(),
        category: random_category(),
        project_id: prj7,
        signed_by_tp: random_boolean()
      }),
      Repo.insert!(%TpDoc{
        access_granted: random_boolean(),
        category: random_category(),
        project_id: prj8,
        signed_by_tp: random_boolean()
      }),
      Repo.insert!(%TpDoc{
        access_granted: random_boolean(),
        category: random_category(),
        project_id: prj9,
        signed_by_tp: random_boolean()
      }),
      Repo.insert!(%TpDoc{
        access_granted: random_boolean(),
        category: random_category(),
        project_id: prj10,
        signed_by_tp: random_boolean()
      }),
      Repo.insert!(%TpDoc{
        access_granted: random_boolean(),
        category: random_category(),
        project_id: prj11,
        signed_by_tp: random_boolean()
      }),
      Repo.insert!(%TpDoc{
        access_granted: random_boolean(),
        category: random_category(),
        project_id: prj12,
        signed_by_tp: random_boolean()
      }),
      Repo.insert!(%TpDoc{
        access_granted: random_boolean(),
        category: random_category(),
        project_id: prj13,
        signed_by_tp: random_boolean()
      }),
      Repo.insert!(%TpDoc{
        access_granted: random_boolean(),
        category: random_category(),
        project_id: prj14,
        signed_by_tp: random_boolean()
      }),
      Repo.insert!(%TpDoc{
        access_granted: random_boolean(),
        category: random_category(),
        project_id: prj15,
        signed_by_tp: random_boolean()
      })
    ]
  end

  @spec random_boolean() :: boolean()
  defp random_boolean do
    data = ~W(true false)a
    Enum.random(data)
  end

  @spec random_category :: String.t()
  defp random_category do
    names = [
      "Files",
      "Final Document"
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

  @spec random_project([String.t()]) :: String.t()
  defp random_project(ids) do
    numbers = 1..1
    number = Enum.random(numbers)

    [result] =
      for i <- 1..number, i > 0 do
        Enum.random(ids)
      end
      |> Enum.uniq()

    result
  end
end

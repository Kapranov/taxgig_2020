defmodule Core.Seeder.Accounts do
  @moduledoc """
  Seeds for `Core.Accounts` context.
  """

  import Ecto.Query

  alias Core.{
    Accounts.Subscriber,
    Accounts.User,
    Localization.Language,
    Repo
  }

  def reset_database! do
    Repo.delete_all(Subscriber)
    Repo.delete_all(User)
  end

  def seed! do
    seed_subscriber()
    seed_user()
    seed_users_languages()
  end

  defp seed_subscriber do
    case Repo.aggregate(Subscriber, :count, :id) > 0 do
      true -> nil
      false -> insert_subscriber()
    end
  end

  defp seed_user do
    case Repo.aggregate(User, :count, :id) > 0 do
      true ->
        Repo.all(
          from u in User,
          where: u.email in [
            "lugatex@yahoo.com",
            "kapranov.lugatex@gmail.com"
          ]
        )
      false -> insert_user()
    end
  end

  defp seed_users_languages do
    language_ids =
      Enum.map(Repo.all(Language), fn(data) -> data end)

    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data end)

    {
      _ara, _ben, _chi, _fra, _ger, _gre, _heb, _hin, _ita,
      jpn, _kor, _pol, _por, _rus, spa, _tur, _ukr, _vie
    } = {
      Enum.at(language_ids, 0),
      Enum.at(language_ids, 1),
      Enum.at(language_ids, 2),
      Enum.at(language_ids, 3),
      Enum.at(language_ids, 4),
      Enum.at(language_ids, 5),
      Enum.at(language_ids, 6),
      Enum.at(language_ids, 7),
      Enum.at(language_ids, 8),
      Enum.at(language_ids, 9),
      Enum.at(language_ids, 10),
      Enum.at(language_ids, 11),
      Enum.at(language_ids, 12),
      Enum.at(language_ids, 13),
      Enum.at(language_ids, 14),
      Enum.at(language_ids, 15),
      Enum.at(language_ids, 16),
      Enum.at(language_ids, 17)
    }

    {user1, user2} = {
      Enum.at(user_ids, 0),
      Enum.at(user_ids, 1)
    }

    preload_user1 = user1 |> Repo.preload([:languages])
    preload_user2 = user2 |> Repo.preload([:languages])

    user_changeset1 = Ecto.Changeset.change(preload_user1)
    user_changeset2 = Ecto.Changeset.change(preload_user2)

    user_lang_changeset1 =
      user_changeset1
      |> Ecto.Changeset.put_assoc(:languages, [jpn])

    user_lang_changeset2 =
      user_changeset2
      |> Ecto.Changeset.put_assoc(:languages, [spa])

    Repo.update!(user_lang_changeset1)
    Repo.update!(user_lang_changeset2)
  end

  defp insert_subscriber do
    [
      Repo.insert!(%Subscriber{
        email: "lugatex@yahoo.com",
        pro_role: false
      }),
      Repo.insert!(%Subscriber{
        email: "kapranov.lugatex@yahoo.com",
        pro_role: true
      })
    ]
  end

  defp insert_user do
    [
      Repo.insert!(%User{
        email: "lugatex@yahoo.com",
        password: "qwerty",
        password_confirmation: "qwerty"
      }),
      Repo.insert!(%User{
        email: "kapranov.lugatex@yahoo.com",
        password: "qwerty",
        password_confirmation: "qwerty"
      })
    ]
  end
end

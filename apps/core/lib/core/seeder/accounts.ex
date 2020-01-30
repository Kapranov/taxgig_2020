defmodule Core.Seeder.Accounts do
  @moduledoc """
  Seeds for `Core.Accounts` context.
  """

  import Ecto.Query

  alias Core.{
    Accounts.Subscriber,
    Accounts.User,
    # Accounts.UserLanguage,
    # Localization.Language,
    Repo
  }

  def reset_database! do
    Repo.delete_all(Subscriber)
    Repo.delete_all(User)
    # Repo.delete_all(UserLanguage)
  end

  def seed! do
    seed_subscriber()
    seed_user()
    # seed_user_language()
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
        email: "kapranov.lugatex@gmail.com",
        password: "qwerty",
        password_confirmation: "qwerty"
      })
    ]
  end

#  defp seed_user_language do
#    lang_ids =
#      Enum.map(Repo.all(Language), fn(data) -> data.id end)
#
#    user_ids =
#      Enum.map(Repo.all(User), fn(data) -> data.id end)
#
#    {
#      _ara, _ben, chi, _fra, _ger, _gre, _heb, _hin, _ita,
#      _jpn, _kor, _pol, _por, _rus, spa, _tur, _ukr, _vie
#    } = {
#      Enum.at(lang_ids, 0),
#      Enum.at(lang_ids, 1),
#      Enum.at(lang_ids, 2),
#      Enum.at(lang_ids, 3),
#      Enum.at(lang_ids, 4),
#      Enum.at(lang_ids, 5),
#      Enum.at(lang_ids, 6),
#      Enum.at(lang_ids, 7),
#      Enum.at(lang_ids, 8),
#      Enum.at(lang_ids, 9),
#      Enum.at(lang_ids, 10),
#      Enum.at(lang_ids, 11),
#      Enum.at(lang_ids, 12),
#      Enum.at(lang_ids, 13),
#      Enum.at(lang_ids, 14),
#      Enum.at(lang_ids, 15),
#      Enum.at(lang_ids, 16),
#      Enum.at(lang_ids, 17)
#    }
#
#    {user1, user2} = {
#      Enum.at(user_ids, 0),
#      Enum.at(user_ids, 1)
#    }
#
#    case Repo.aggregate(UserLanguage, :count, :id) > 0 do
#      true -> nil
#      false ->
#        [
#          Repo.insert!(%UserLanguage{
#            language_id: spa,
#            user_id: user1
#          }),
#          Repo.insert!(%UserLanguage{
#            language_id: chi,
#            user_id: user2
#          })
#        ]
#    end
#  end
end

defmodule Core.Seeder.Accounts do
  @moduledoc """
  Seeds for `Core.Accounts` context.
  """

  import Ecto.Query

  alias Core.{
    Accounts,
    Accounts.Subscriber,
    Accounts.User,
    Repo
  }

  def reset_database! do
    Repo.delete_all(Subscriber)
    Repo.delete_all(User)
  end

  def seed! do
    seed_subscriber()
    seed_user()
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
      Accounts.create_user(%{
        email: "lugatex@yahoo.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        languages: "french, greek, japanese, polish, portuguese"
      }),
      Accounts.create_user(%{
        email: "kapranov.lugatex@gmail.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        languages: "italian, chinese, greek"
      })
    ]
  end
end

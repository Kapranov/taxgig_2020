defmodule Core.Seeder.Accounts do
  @moduledoc """
  Seeds for `Core.Accounts` context.
  """

  import Ecto.Query

  alias Core.{
    Accounts,
    Accounts.Subscriber,
    Accounts.User,
    Localization.Language,
    Repo
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(Subscriber)
    Repo.delete_all(User)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_subscriber()
    seed_user()
    # seed_multi_user()
    seed_users_languages()
    seed_multi_users_languages()
    admin_permission()
  end

  @spec get_tp_user(String.t()) :: %Postgrex.Result{columns: nil, command: Atom.t(), connection_id: integer, messages: [], num_rows: integer, rows: nil}
  def get_tp_user(email) do
    Ecto.Adapters.SQL.query!(Repo, "SELECT id from users WHERE email = $1", [email])
  end

  @spec get_pro_user(String.t()) :: %Postgrex.Result{columns: nil, command: Atom.t(), connection_id: integer, messages: [], num_rows: integer, rows: nil}
  def get_pro_user(email) do
    Ecto.Adapters.SQL.query!(Repo, "SELECT id from users WHERE email = $1", [email])
  end

  @spec admin_permission() :: %Postgrex.Result{columns: nil, command: Atom.t(), connection_id: integer, messages: [], num_rows: integer, rows: nil}
  def admin_permission do
    Ecto.Adapters.SQL.query!(Repo, "UPDATE users SET admin = $2 WHERE email = $1", ["kapranov.pure@gmail.com", true])
  end

  @spec admin_permission(String.t(), boolean()) :: %Postgrex.Result{columns: nil, command: Atom.t(), connection_id: integer, messages: [], num_rows: integer, rows: nil}
  def admin_permission(email, role) when is_bitstring(email) and is_boolean(role) do
    Ecto.Adapters.SQL.query!(Repo, "UPDATE users SET admin = $2 WHERE email = $1", [email, role])
  end

  @spec admin_permission(any(), any()) :: {:error, String.t()}
  def admin_permission(_, _) do
    {:error, "Oops! email and role is an empty"}
  end

  @spec seed_subscriber() :: nil | Ecto.Schema.t()
  defp seed_subscriber do
    case Repo.aggregate(Subscriber, :count, :id) > 0 do
      true -> nil
      false -> insert_subscriber()
    end
  end

  @spec seed_user() :: [Ecto.Schema.t()]
  def seed_user do
    case Repo.aggregate(User, :count, :id) > 0 do
      true ->
        Repo.all(
          from u in User,
          where: u.email in [
            "kapranov.lugatex@gmail.com",
            "kapranov.pure@gmail.com",
            "lugatex@yahoo.com",
            "v.kobzan@gmail.com",
            "o.puryshev@gmail.com",
            "vlacho777@gmail.com",
            "support@taxgig.com",
            "op@taxgig.com",
            "vk@taxgig.com"
          ]
        )
      false ->
        insert_user()
    end
  end

  @spec seed_multi_user() :: [Ecto.Schema.t()]
  def seed_multi_user do
    case Repo.aggregate(User, :count, :id) > 0 do
      true ->
        Repo.all(
          from u in User,
          where: u.email in [
            "kapranov.lugatex@gmail.com",
            "kapranov.pure@gmail.com",
            "lugatex@yahoo.com",
            "v.kobzan@gmail.com",
            "o.puryshev@gmail.com",
            "vlacho777@gmail.com",
            "support@taxgig.com",
            "op@taxgig.com",
            "vk@taxgig.com"
          ]
        )
      false ->
        insert_multi_user()
    end
  end

  @spec seed_users_languages() :: Ecto.Schema.t()
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
      Repo.preload(Enum.at(user_ids, 0), [:languages]),
      Repo.preload(Enum.at(user_ids, 1), [:languages])
    }

    user_changeset1 = Ecto.Changeset.change(user1)
    user_changeset2 = Ecto.Changeset.change(user2)

    user_changeset1
    |> Ecto.Changeset.put_assoc(:languages, [jpn])
    |> Repo.update!()

    user_changeset2
    |> Ecto.Changeset.put_assoc(:languages, [spa])
    |> Repo.update!()
  end

  @spec seed_multi_users_languages() :: Ecto.Schema.t()
  defp seed_multi_users_languages do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data end)

    {user} = { Enum.at(user_ids, 1) }

    language_ids =
      Enum.map(Repo.all(Language), fn(data) -> data end)

    {
      ara, ben, chi, fra, ger, gre, heb, hin, ita,
      jpn, kor, pol, por, rus, spa, tur, ukr, vie
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


    accounts = [%User{id: user.id, email: user.email}]

    lang = "#{ara.name}, #{ben.name}, #{chi.name}, #{fra.name}, #{ger.name},
            #{gre.name}, #{heb.name}, #{hin.name}, #{ita.name}, #{jpn.name},
            #{kor.name}, #{pol.name}, #{por.name}, #{rus.name}, #{spa.name},
            #{tur.name}, #{ukr.name}, #{vie.name}"

    Enum.reduce(accounts, Ecto.Multi.new(), fn account, multi ->
      Ecto.Multi.update(
        multi,
        {:user, account.id},
        User.changeset(
          account,
          %{
            languages: lang,
            email: account.email,
            password: "qwerty",
            password_confirmation: "qwerty"
          }
        )
      )
      |> Repo.transaction()
    end)
  end

  @spec insert_subscriber() :: Ecto.Schema.t()
  defp insert_subscriber do
    [
      Repo.insert!(%Subscriber{
        email: "lugatex@yahoo.com",
        pro_role: false
      }),
      Repo.insert!(%Subscriber{
        email: "kapranov.lugatex@gmail.com",
        pro_role: true
      })
    ]
  end

  @spec insert_user() :: {:ok, any()} | {:error, any()}
  def insert_user do
    [
      Accounts.create_user(%{
        email: "lugatex@yahoo.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        role: true
      }),
      Accounts.create_user(%{
        email: "kapranov.lugatex@gmail.com",
        password: "qwerty",
        password_confirmation: "qwerty"
      }),
      Accounts.create_user(%{
        email: "kapranov.pure@gmail.com",
        password: "nES0p04pVklw",
        password_confirmation: "nES0p04pVklw"
      }),
      Accounts.create_user(%{
        email: "v.kobzan@gmail.com",
        password: "qwerty",
        password_confirmation: "qwerty"
      }),
      Accounts.create_user(%{
        email: "o.puryshev@gmail.com",
        password: "qwerty",
        password_confirmation: "qwerty"
      }),
      Accounts.create_user(%{
        email: "vlacho777@gmail.com",
        password: "qwerty",
        password_confirmation: "qwerty"
      }),
      Accounts.create_user(%{
        email: "support@taxgig.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        role: true
      }),
      Accounts.create_user(%{
        email: "op@taxgig.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        role: true
      }),
      Accounts.create_user(%{
        email: "vk@taxgig.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        role: true
      })
    ]
  end

  @spec insert_multi_user() :: {:ok, any()} | {:error, any()}
  def insert_multi_user do
    [
      Accounts.create_multi_user(%{
        email: "lugatex@yahoo.com",
        password: "qwerty",
        password_confirmation: "qwerty"
      }),
      Accounts.create_multi_user(%{
        email: "kapranov.lugatex@gmail.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        role: true
      }),
      Accounts.create_multi_user(%{
        email: "kapranov.pure@gmail.com",
        password: "nES0p04pVklw",
        password_confirmation: "nES0p04pVklw"
      }),
      Accounts.create_multi_user(%{
        email: "v.kobzan@gmail.com",
        password: "qwerty",
        password_confirmation: "qwerty"
      }),
      Accounts.create_multi_user(%{
        email: "o.puryshev@gmail.com",
        password: "qwerty",
        password_confirmation: "qwerty"
      }),
      Accounts.create_multi_user(%{
        email: "vlacho777@gmail.com",
        password: "qwerty",
        password_confirmation: "qwerty"
      }),
      Accounts.create_multi_user(%{
        email: "support@taxgig.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        role: true
      }),
      Accounts.create_multi_user(%{
        email: "op@taxgig.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        role: true
      }),
      Accounts.create_multi_user(%{
        email: "vk@taxgig.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        role: true
      })
    ]
  end
end

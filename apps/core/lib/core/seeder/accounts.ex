defmodule Core.Seeder.Accounts do
  @moduledoc """
  Seeds for `Core.Accounts` context.
  """

  import Ecto.Query

  alias Core.{
    Accounts,
    Accounts.BanReason,
    Accounts.DeletedUser,
    Accounts.Platform,
    Accounts.ProRating,
    Accounts.Subscriber,
    Accounts.User,
    Localization.Language,
    Repo
  }

  alias Ecto.Adapters.SQL

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    IO.puts("Deleting old data...\n")
    SQL.query!(Repo, "TRUNCATE ban_reasons CASCADE;")
    SQL.query!(Repo, "TRUNCATE deleted_users CASCADE;")
    SQL.query!(Repo, "TRUNCATE platforms CASCADE;")
    SQL.query!(Repo, "TRUNCATE pro_ratings CASCADE;")
    SQL.query!(Repo, "TRUNCATE subscribers CASCADE;")
    SQL.query!(Repo, "TRUNCATE users CASCADE;")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_subscriber()
    seed_user()
    # seed_multi_user()
    seed_users_languages()
    seed_multi_users_languages()
    seed_platform()
    seed_ban_reason()
    seed_pro_rating()
    seed_deleted_user()
    admin_permission()
  end

  @spec get_tp_user(String.t()) :: %Postgrex.Result{columns: nil, command: atom(), connection_id: integer, messages: [], num_rows: integer, rows: nil}
  def get_tp_user(email) do
    Ecto.Adapters.SQL.query!(Repo, "SELECT id from users WHERE email = $1", [email])
  end

  @spec get_pro_user(String.t()) :: %Postgrex.Result{columns: nil, command: atom(), connection_id: integer, messages: [], num_rows: integer, rows: nil}
  def get_pro_user(email) do
    Ecto.Adapters.SQL.query!(Repo, "SELECT id from users WHERE email = $1", [email])
  end

  @spec admin_permission() :: %Postgrex.Result{columns: nil, command: atom(), connection_id: integer, messages: [], num_rows: integer, rows: nil}
  def admin_permission do
    Ecto.Adapters.SQL.query!(Repo, "UPDATE users SET admin = $2 WHERE email = $1", ["kapranov.pure@gmail.com", true])
  end

  @spec admin_permission(String.t(), boolean()) :: %Postgrex.Result{columns: nil, command: atom(), connection_id: integer, messages: [], num_rows: integer, rows: nil}
  def admin_permission(email, role) when is_bitstring(email) and is_boolean(role) do
    Ecto.Adapters.SQL.query!(Repo, "UPDATE users SET admin = $2 WHERE email = $1", [email, role])
  end

  @spec admin_create_ban_reasons :: {:error, String.t()}
  def admin_create_ban_reasons do
    {:error, "Oops! email and role is an empty"}
  end

  @spec admin_create_ban_reasons(any()) :: {:error, String.t()}
  def admin_create_ban_reasons(_) do
    {:error, "Oops! other is an empty"}
  end

  @spec admin_create_ban_reasons(any(), any()) :: {:error, String.t()}
  def admin_create_ban_reasons(_, _) do
    {:error, "Oops! other is an empty"}
  end

  @spec admin_create_ban_reasons(any(), any(), any()) :: {:error, String.t()}
  def admin_create_ban_reasons(_, _, _) do
    {:error, "Oops! other is an empty"}
  end

  @spec admin_create_ban_reasons(String.t(), String.t(), boolean(), String.t()) :: %Postgrex.Result{columns: nil, command: atom(), connection_id: integer, messages: [], num_rows: integer, rows: nil}
  def admin_create_ban_reasons(user_id, reasons, other, other_description) when is_bitstring(user_id) and is_bitstring(reasons) and is_boolean(other) and is_bitstring(other_description) do
    user =
      try do
        Accounts.get_user!(user_id)
      rescue
        Ecto.NoResultsError -> :error
      end

    now = :erlang.system_time(:second) |> DateTime.from_unix!()

    if Accounts.User.superuser?(user) do
      case Repo.aggregate(BanReason, :count, :id) > 0 do
        true -> nil
        false ->
          case other do
            true ->
              Ecto.Adapters.SQL.query!(Repo, "INSERT INTO ban_reasons (other, other_description, inserted_at, updated_at) VALUES ($1, $2, $3, $4)", [other, other_description, now, now])
            false ->
              Ecto.Adapters.SQL.query!(Repo, "INSERT INTO ban_reasons (reasons, other, inserted_at, updated_at) VALUES ($1, $2, $3, $4)", [reasons, other, now, now])
          end
      end
    else
      {:error, "Oops! Permission Denied"}
    end
  end

  @spec admin_create_ban_reasons(any(), any(), any(), any()) :: {:error, String.t()}
  def admin_create_ban_reasons(_, _, _, _) do
    {:error, "Oops! other is an empty"}
  end

  @spec admin_delete_ban_reasons :: {:error, String.t()}
  def admin_delete_ban_reasons do
    {:error, "Oops! Permission denied"}
  end

  @spec admin_delete_ban_reasons(String.t()) :: %Postgrex.Result{columns: nil, command: atom(), connection_id: integer, messages: [], num_rows: integer, rows: nil}
  def admin_delete_ban_reasons(user_id) when is_bitstring(user_id) do
    user =
      try do
        Accounts.get_user!(user_id)
      rescue
        Ecto.NoResultsError -> :error
      end

    if Accounts.User.superuser?(user) do
      case Repo.aggregate(BanReason, :count, :id) > 0 do
        false -> nil
        true ->
          Ecto.Adapters.SQL.query!(Repo, "DELETE FROM ban_reasons", [])
      end
    else
      {:error, "Oops! Permission Denied"}
    end
  end

  @spec admin_delete_ban_reasons(any()) :: {:error, String.t()}
  def admin_delete_ban_reasons(_) do
    {:error, "Oops! Permission denied"}
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
            "o.puryshev@gmail.com",
            "op@taxgig.com",
            "support@taxgig.com",
            "v.kobzan@gmail.com",
            "vk@taxgig.com",
            "vlacho777@gmail.com"
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
    user_ids = Enum.map(Repo.all(User), &(&1))

    {user1, user2} = {
      Repo.preload(Enum.at(user_ids, 0), [:languages]),
      Repo.preload(Enum.at(user_ids, 1), [:languages])
    }

    user_changeset1 = Ecto.Changeset.change(user1)
    user_changeset2 = Ecto.Changeset.change(user2)

    user_changeset1
    |> Ecto.Changeset.put_assoc(:languages, random_languages())
    |> Repo.update!()

    user_changeset2
    |> Ecto.Changeset.put_assoc(:languages, random_languages())
    |> Repo.update!()
  end

  @spec seed_multi_users_languages() :: Ecto.Schema.t()
  defp seed_multi_users_languages do
    user_ids = Enum.map(Repo.all(User), &(&1))
    {user} = { Enum.at(user_ids, 1) }
    accounts = [%User{id: user.id, email: user.email}]

    Enum.reduce(accounts, Ecto.Multi.new(), fn account, multi ->
      Ecto.Multi.update(
        multi,
        {:user, account.id},
        User.changeset(
          account,
          %{
            languages: random_language(),
            email: account.email,
            password: "qwerty",
            password_confirmation: "qwerty"
          }
        )
      )
      |> Repo.transaction()
    end)
  end

  @spec seed_platform() :: nil | Ecto.Schema.t()
  defp seed_platform do
    case Repo.aggregate(Platform, :count, :id) > 0 do
      true -> nil
      false -> insert_platform()
    end
  end

  @spec seed_ban_reason() :: nil | Ecto.Schema.t()
  defp seed_ban_reason do
    case Repo.aggregate(BanReason, :count, :id) > 0 do
      true -> nil
      false -> insert_ban_reason()
    end
  end

  @spec seed_pro_rating() :: nil | Ecto.Schema.t()
  defp seed_pro_rating do
    case Repo.aggregate(ProRating, :count, :id) > 0 do
      true -> nil
      false -> insert_pro_rating()
    end
  end

  @spec seed_deleted_user() :: nil | Ecto.Schema.t()
  defp seed_deleted_user do
    case Repo.aggregate(DeletedUser, :count, :id) > 0 do
      true -> nil
      false -> insert_deleted_user()
    end
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
  defp insert_user do
    [
      Accounts.create_user(%{
        admin: true,
        email: "lugatex@yahoo.com",
        first_name: "Oleg",
        last_name: "Kapranov",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "555-555-5511",
        role: true
      }),
      Accounts.create_user(%{
        email: "kapranov.lugatex@gmail.com",
        first_name: "Oleg",
        last_name: "G.Kapranov",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "555-555-5512"
      }),
      Accounts.create_user(%{
        email: "kapranov.pure@gmail.com",
        first_name: "Oleg",
        last_name: "Kaplanov",
        password: "nES0p04pVklw",
        password_confirmation: "nES0p04pVklw",
        phone: "555-555-5513"
      }),
      Accounts.create_user(%{
        email: "v.kobzan@gmail.com",
        first_name: "Vlad",
        last_name: "Kobzan",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "555-555-5514"
      }),
      Accounts.create_user(%{
        email: "o.puryshev@gmail.com",
        first_name: "Oleh",
        last_name: "Puryshev",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "555-555-5515"
      }),
      Accounts.create_user(%{
        email: "vlacho777@gmail.com",
        first_name: "VVV",
        last_name: "vlacho",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "555-555-5516"
      }),
      Accounts.create_user(%{
        email: "support@taxgig.com",
        first_name: "Joe",
        last_name: "Sleepy",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "555-555-5517",
        role: true
      }),
      Accounts.create_user(%{
        email: "op@taxgig.com",
        first_name: "Op",
        last_name: "Creepy",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "555-555-5518",
        role: true
      }),
      Accounts.create_user(%{
        email: "vk@taxgig.com",
        first_name: "Vk",
        last_name: "Lazy",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "555-555-5519",
        role: true
      })
    ]
  end

  @spec insert_multi_user() :: {:ok, any()} | {:error, any()}
  defp insert_multi_user do
    [
      Accounts.create_multi_user(%{
        email: "lugatex@yahoo.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "555-555-5511",
        role: true
      }),
      Accounts.create_multi_user(%{
        email: "kapranov.lugatex@gmail.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "555-555-5512"
      }),
      Accounts.create_multi_user(%{
        email: "kapranov.pure@gmail.com",
        password: "nES0p04pVklw",
        password_confirmation: "nES0p04pVklw",
        phone: "555-555-5513"
      }),
      Accounts.create_multi_user(%{
        email: "v.kobzan@gmail.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "555-555-5514"
      }),
      Accounts.create_multi_user(%{
        email: "o.puryshev@gmail.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "555-555-5515"
      }),
      Accounts.create_multi_user(%{
        email: "vlacho777@gmail.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "555-555-5516"
      }),
      Accounts.create_multi_user(%{
        email: "support@taxgig.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "555-555-5517",
        role: true
      }),
      Accounts.create_multi_user(%{
        email: "op@taxgig.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "555-555-5518",
        role: true
      }),
      Accounts.create_multi_user(%{
        email: "vk@taxgig.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "555-555-5519",
        role: true
      })
    ]
  end

  @spec insert_platform() :: Ecto.Schema.t()
  defp insert_platform do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {user, tp1, tp2, tp3, tp4, tp5, pro1, pro2, pro3} = {
      Enum.at(user_ids, 0),
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6),
      Enum.at(user_ids, 7),
      Enum.at(user_ids, 8)
    }

    [
      Accounts.create_platform(%{
        client_limit_reach: random_boolean(),
        hero_active: random_boolean(),
        hero_status: random_boolean(),
        is_banned: random_boolean(),
        is_online: random_boolean(),
        is_stuck: random_boolean(),
        payment_active: random_boolean(),
        stuck_stage: random_stuck_stage(),
        user_id: user
      }),
      Accounts.create_platform(%{
        client_limit_reach: random_boolean(),
        hero_active: random_boolean(),
        hero_status: random_boolean(),
        is_banned: random_boolean(),
        is_online: random_boolean(),
        is_stuck: random_boolean(),
        payment_active: random_boolean(),
        stuck_stage: random_stuck_stage(),
        user_id: tp1
      }),
      Accounts.create_platform(%{
        client_limit_reach: random_boolean(),
        hero_active: random_boolean(),
        hero_status: random_boolean(),
        is_banned: random_boolean(),
        is_online: random_boolean(),
        is_stuck: random_boolean(),
        payment_active: random_boolean(),
        stuck_stage: random_stuck_stage(),
        user_id: tp2
      }),
      Accounts.create_platform(%{
        client_limit_reach: random_boolean(),
        hero_active: random_boolean(),
        hero_status: random_boolean(),
        is_banned: random_boolean(),
        is_online: random_boolean(),
        is_stuck: random_boolean(),
        payment_active: random_boolean(),
        stuck_stage: random_stuck_stage(),
        user_id: tp3
      }),
      Accounts.create_platform(%{
        client_limit_reach: random_boolean(),
        hero_active: random_boolean(),
        hero_status: random_boolean(),
        is_banned: random_boolean(),
        is_online: random_boolean(),
        is_stuck: random_boolean(),
        payment_active: random_boolean(),
        stuck_stage: random_stuck_stage(),
        user_id: tp4
      }),
      Accounts.create_platform(%{
        client_limit_reach: random_boolean(),
        hero_active: random_boolean(),
        hero_status: random_boolean(),
        is_banned: random_boolean(),
        is_online: random_boolean(),
        is_stuck: random_boolean(),
        payment_active: random_boolean(),
        stuck_stage: random_stuck_stage(),
        user_id: tp5
      }),
      Accounts.create_platform(%{
        client_limit_reach: random_boolean(),
        hero_active: random_boolean(),
        hero_status: random_boolean(),
        is_banned: random_boolean(),
        is_online: random_boolean(),
        is_stuck: random_boolean(),
        payment_active: random_boolean(),
        stuck_stage: random_stuck_stage(),
        user_id: pro1
      }),
      Accounts.create_platform(%{
        client_limit_reach: random_boolean(),
        hero_active: random_boolean(),
        hero_status: random_boolean(),
        is_banned: random_boolean(),
        is_online: random_boolean(),
        is_stuck: random_boolean(),
        payment_active: random_boolean(),
        stuck_stage: random_stuck_stage(),
        user_id: pro2
      }),
      Accounts.create_platform(%{
        client_limit_reach: random_boolean(),
        hero_active: random_boolean(),
        hero_status: random_boolean(),
        is_banned: random_boolean(),
        is_online: random_boolean(),
        is_stuck: random_boolean(),
        payment_active: random_boolean(),
        stuck_stage: random_stuck_stage(),
        user_id: pro3
      })
    ]
  end

  @spec insert_ban_reason() :: Ecto.Schema.t()
  defp insert_ban_reason do
    platform_ids =
      Enum.map(Repo.all(Platform), fn(data) -> data.id end)

    {
      platform1,
      platform2,
      platform3,
      platform4,
      platform5,
      platform6,
      platform7,
      platform8,
      platform9
    } = {
      Enum.at(platform_ids, 0),
      Enum.at(platform_ids, 1),
      Enum.at(platform_ids, 2),
      Enum.at(platform_ids, 3),
      Enum.at(platform_ids, 4),
      Enum.at(platform_ids, 5),
      Enum.at(platform_ids, 6),
      Enum.at(platform_ids, 7),
      Enum.at(platform_ids, 8)
    }

    admin = Repo.get_by(User, %{email: "lugatex@yahoo.com"})

    [
      Accounts.create_ban_reason(%{
        description: "some text",
        other: random_boolean(),
        reasons: random_reasons(),
        platform_id: platform1,
        user_id: admin.id
      }),
      Accounts.create_ban_reason(%{
        description: "some text",
        other: random_boolean(),
        reasons: random_reasons(),
        platform_id: platform2,
        user_id: admin.id
      }),
      Accounts.create_ban_reason(%{
        description: "some text",
        other: random_boolean(),
        reasons: random_reasons(),
        platform_id: platform3,
        user_id: admin.id
      }),
      Accounts.create_ban_reason(%{
        description: "some text",
        other: random_boolean(),
        reasons: random_reasons(),
        platform_id: platform4,
        user_id: admin.id
      }),
      Accounts.create_ban_reason(%{
        description: "some text",
        other: random_boolean(),
        reasons: random_reasons(),
        platform_id: platform5,
        user_id: admin.id
      }),
      Accounts.create_ban_reason(%{
        description: "some text",
        other: random_boolean(),
        reasons: random_reasons(),
        platform_id: platform6,
        user_id: admin.id
      }),
      Accounts.create_ban_reason(%{
        description: "some text",
        other: random_boolean(),
        reasons: random_reasons(),
        platform_id: platform7,
        user_id: admin.id
      }),
      Accounts.create_ban_reason(%{
        description: "some text",
        other: random_boolean(),
        reasons: random_reasons(),
        platform_id: platform8,
        user_id: admin.id
      }),
      Accounts.create_ban_reason(%{
        description: "some text",
        other: random_boolean(),
        reasons: random_reasons(),
        platform_id: platform9,
        user_id: admin.id
      })
    ]
  end

  @spec insert_pro_rating() :: Ecto.Schema.t()
  defp insert_pro_rating do
    pro1 = Repo.get_by(User, %{email: "support@taxgig.com"})
    pro2 = Repo.get_by(User, %{email: "op@taxgig.com"})
    pro3 = Repo.get_by(User, %{email: "vk@taxgig.com"})

    [
      Accounts.create_pro_rating(%{
        average_communication: random_float(),
        average_professionalism: random_float(),
        average_rating: random_float(),
        average_work_quality: random_float(),
        user_id: pro1.id
      }),
      Accounts.create_pro_rating(%{
        average_communication: random_float(),
        average_professionalism: random_float(),
        average_rating: random_float(),
        average_work_quality: random_float(),
        user_id: pro2.id
      }),
      Accounts.create_pro_rating(%{
        average_communication: random_float(),
        average_professionalism: random_float(),
        average_rating: random_float(),
        average_work_quality: random_float(),
        user_id: pro3.id
      })
    ]
  end

  @spec insert_deleted_user() :: Ecto.Schema.t()
  defp insert_deleted_user do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data end)

    {user, tp1, tp2, tp3, tp4, tp5, pro1, pro2, pro3} = {
      Enum.at(user_ids, 0),
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6),
      Enum.at(user_ids, 7),
      Enum.at(user_ids, 8)
    }

    [
      Repo.insert!(%DeletedUser{
        reason: random_reason(),
        user_id:        user.id
      }),
      Repo.insert!(%DeletedUser{
        reason: random_reason(),
        user_id:         tp1.id
      }),
      Repo.insert!(%DeletedUser{
        reason: random_reason(),
        user_id:         tp2.id
      }),
      Repo.insert!(%DeletedUser{
        reason: random_reason(),
        user_id:         tp3.id
      }),
      Repo.insert!(%DeletedUser{
        reason: random_reason(),
        user_id:         tp4.id
      }),
      Repo.insert!(%DeletedUser{
        reason: random_reason(),
        user_id:         tp5.id
      }),
      Repo.insert!(%DeletedUser{
        reason: random_reason(),
        user_id:        pro1.id
      }),
      Repo.insert!(%DeletedUser{
        reason: random_reason(),
        user_id:        pro2.id
      }),
      Repo.insert!(%DeletedUser{
        reason: random_reason(),
        user_id:        pro3.id
      })
    ]
  end

  @spec random_language() :: String.t()
  defp random_language do
    data =
      Repo.all(Language)
      |> Enum.map(&(&1.name))

    numbers = 1..18
    number = Enum.random(numbers)

    result =
      for i <- 1..number, i > 0 do
        Enum.random(data)
      end
      |> Enum.uniq()
      |> Enum.map(&(&1))
      |> Enum.join(", ")

    result
  end

  @spec random_languages() :: [Language.t()]
  defp random_languages do
    data = Repo.all(Language)

    numbers = 1..18
    number = Enum.random(numbers)

    result =
      for i <- 1..number, i > 0 do
        Enum.random(data)
      end
      |> Enum.uniq()

    result
  end

  @spec random_reason :: [String.t()]
  defp random_reason do
    names = [
      "Another Service",
      "Change Account",
      "Needs",
      "No longer require",
      "Not Easy",
      "Quality",
      "Wrong Account"
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

  @spec random_reasons :: [String.t()]
  defp random_reasons do
    names = [
      "Racism",
      "Intolerance",
      "Violate Terms",
      "Fraud",
      "Spam",
      "Sexism",
      "Harassment"
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

  @spec random_stuck_stage :: [String.t()]
  defp random_stuck_stage do
    names = [
      "Blockscore",
      "PTIN",
      "Stripe"
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

  @spec random_boolean() :: boolean()
  defp random_boolean do
    value = ~W(true false)a
    Enum.random(value)
  end

  @spec random_float() :: float()
  def random_float do
    :rand.uniform() * 100
    |> Float.round(2)
  end
end

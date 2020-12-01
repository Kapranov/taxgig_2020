defmodule Core.Seeder.Updated.Accounts do
  @moduledoc """
  An update are seeds whole an accounts.
  """

  alias Core.{
    Accounts,
    Accounts.BanReason,
    Accounts.DeletedUser,
    Accounts.Platform,
    Accounts.ProRating,
    Accounts.Profile,
    Accounts.User,
    Lookup.UsZipcode,
    Repo
  }

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_user()
    update_profile()
    update_subscriber()
    update_platform()
    update_ban_reason()
    update_pro_rating()
    update_deleted_user()
  end

  @spec update_user() :: Ecto.Schema.t()
  defp update_user do
    user_ids = Enum.map(Repo.all(User), fn(data) -> data end)

    {
      user1,
      user2,
      user3
    } = {
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 5)
    }

    [
      Accounts.update_user(user1, %{
        first_name: "Vlad",
        last_name: "Kobzan",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "563-917-8432"
      }),
      Accounts.update_user(user2, %{
        first_name: "Oleg",
        last_name: "Puryshev",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "917-777-8798"
      }),
      Accounts.update_user(user3, %{
        first_name: "Oleh",
        last_name: "Puryshev",
        middle_name: "Jr.",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "593-657-4343",
        birthday: Timex.to_date({1989, 7, 15}),
        street: "95 Wall St",
        ssn: 987654321
      })
    ]
  end

  @spec update_profile() :: Ecto.Schema.t()
  defp update_profile do
    profile_ids = Enum.map(Repo.all(Profile), fn(data) -> data end)
    zipcode_ids = Enum.map(Repo.all(UsZipcode), fn(data) -> data end)

    { profile7 } = { Enum.at(profile_ids, 7) }
    { record51 } = { Enum.at(zipcode_ids, 51) }

    [
      Accounts.update_profile(profile7, %{
        address: "95 Wall St",
        us_zipcode_id: record51.id
      })
    ]
  end

  @spec update_subscriber() :: Ecto.Schema.t()
  defp update_subscriber do
  end

  @spec update_ban_reason() :: Ecto.Schema.t()
  defp update_ban_reason do
    ban_reason_ids =
      Enum.map(Repo.all(BanReason), fn(data) -> data end)

    {
      br1,
      br2,
      br3,
      br4,
      br5,
      br6,
      br7
    } = {
      Enum.at(ban_reason_ids, 0),
      Enum.at(ban_reason_ids, 1),
      Enum.at(ban_reason_ids, 2),
      Enum.at(ban_reason_ids, 3),
      Enum.at(ban_reason_ids, 4),
      Enum.at(ban_reason_ids, 5),
      Enum.at(ban_reason_ids, 6)
    }

    [
      Accounts.update_ban_reason(br1, %{
        reasons: random_reasons(),
        other: random_boolean(),
        description: "updated some text"
      }),
      Accounts.update_ban_reason(br2, %{
        reasons: random_reasons(),
        other: random_boolean(),
        description: "updated some text"
      }),
      Accounts.update_ban_reason(br3, %{
        reasons: random_reasons(),
        other: random_boolean(),
        description: "updated some text"
      }),
      Accounts.update_ban_reason(br4, %{
        reasons: random_reasons(),
        other: random_boolean(),
        description: "updated some text"
      }),
      Accounts.update_ban_reason(br5, %{
        reasons: random_reasons(),
        other: random_boolean(),
        description: "updated some text"
      }),
      Accounts.update_ban_reason(br6, %{
        reasons: random_reasons(),
        other: random_boolean(),
        description: "updated some text"
      }),
      Accounts.update_ban_reason(br7, %{
        reasons: random_reasons(),
        other: random_boolean(),
        description: "updated some text"
      })
    ]
  end

  @spec update_platform() :: Ecto.Schema.t()
  defp update_platform do
    platform_ids = Enum.map(Repo.all(Platform), fn(data) -> data end)

    {
      platform1,
      platform2,
      platform3,
      platform4,
      platform5,
      platform6,
      platform7
    } = {
      Enum.at(platform_ids, 0),
      Enum.at(platform_ids, 1),
      Enum.at(platform_ids, 2),
      Enum.at(platform_ids, 3),
      Enum.at(platform_ids, 4),
      Enum.at(platform_ids, 5),
      Enum.at(platform_ids, 6)
    }

    [
      Accounts.update_platfrom(platform1, %{
        client_limit_reach: random_boolean(),
        hero_active: random_boolean(),
        hero_status: random_boolean(),
        is_banned: random_boolean(),
        is_online: random_boolean(),
        is_stuck: random_boolean(),
        payment_active: random_boolean(),
        stuck_stage: random_stuck_stage()
      }),
      Accounts.update_platfrom(platform2, %{
        client_limit_reach: random_boolean(),
        hero_active: random_boolean(),
        hero_status: random_boolean(),
        is_banned: random_boolean(),
        is_online: random_boolean(),
        is_stuck: random_boolean(),
        payment_active: random_boolean(),
        stuck_stage: random_stuck_stage()
      }),
      Accounts.update_platfrom(platform3, %{
        client_limit_reach: random_boolean(),
        hero_active: random_boolean(),
        hero_status: random_boolean(),
        is_banned: random_boolean(),
        is_online: random_boolean(),
        is_stuck: random_boolean(),
        payment_active: random_boolean(),
        stuck_stage: random_stuck_stage()
      }),
      Accounts.update_platfrom(platform4, %{
        client_limit_reach: random_boolean(),
        hero_active: random_boolean(),
        hero_status: random_boolean(),
        is_banned: random_boolean(),
        is_online: random_boolean(),
        is_stuck: random_boolean(),
        payment_active: random_boolean(),
        stuck_stage: random_stuck_stage()
      }),
      Accounts.update_platfrom(platform5, %{
        client_limit_reach: random_boolean(),
        hero_active: random_boolean(),
        hero_status: random_boolean(),
        is_banned: random_boolean(),
        is_online: random_boolean(),
        is_stuck: random_boolean(),
        payment_active: random_boolean(),
        stuck_stage: random_stuck_stage()
      }),
      Accounts.update_platfrom(platform6, %{
        client_limit_reach: random_boolean(),
        hero_active: random_boolean(),
        hero_status: random_boolean(),
        is_banned: random_boolean(),
        is_online: random_boolean(),
        is_stuck: random_boolean(),
        payment_active: random_boolean(),
        stuck_stage: random_stuck_stage()
      }),
      Accounts.update_platfrom(platform7, %{
        client_limit_reach: random_boolean(),
        hero_active: random_boolean(),
        hero_status: random_boolean(),
        is_banned: random_boolean(),
        is_online: random_boolean(),
        is_stuck: random_boolean(),
        payment_active: random_boolean(),
        stuck_stage: random_stuck_stage()
      })
    ]
  end

  @spec update_pro_rating() :: Ecto.Schema.t()
  defp update_pro_rating do
    pro_rating_ids = Enum.map(Repo.all(ProRating), fn(data) -> data end)

    {
      pro_rating1,
      pro_rating2,
      pro_rating3,
      pro_rating4,
      pro_rating5,
      pro_rating6,
      pro_rating7,
      pro_rating8,
      pro_rating9
    } = {
      Enum.at(pro_rating_ids, 0),
      Enum.at(pro_rating_ids, 1),
      Enum.at(pro_rating_ids, 2),
      Enum.at(pro_rating_ids, 3),
      Enum.at(pro_rating_ids, 4),
      Enum.at(pro_rating_ids, 5),
      Enum.at(pro_rating_ids, 6),
      Enum.at(pro_rating_ids, 7),
      Enum.at(pro_rating_ids, 8)
    }

    [
      Accounts.update_pro_rating(pro_rating1, %{
        average_communication: random_float(),
        average_professionalism: random_float(),
        average_rating: random_float(),
        average_work_quality: random_float()
      }),
      Accounts.update_pro_rating(pro_rating2, %{
        average_communication: random_float(),
        average_professionalism: random_float(),
        average_rating: random_float(),
        average_work_quality: random_float()
      }),
      Accounts.update_pro_rating(pro_rating3, %{
        average_communication: random_float(),
        average_professionalism: random_float(),
        average_rating: random_float(),
        average_work_quality: random_float()
      }),
      Accounts.update_pro_rating(pro_rating4, %{
        average_communication: random_float(),
        average_professionalism: random_float(),
        average_rating: random_float(),
        average_work_quality: random_float()
      }),
      Accounts.update_pro_rating(pro_rating5, %{
        average_communication: random_float(),
        average_professionalism: random_float(),
        average_rating: random_float(),
        average_work_quality: random_float()
      }),
      Accounts.update_pro_rating(pro_rating6, %{
        average_communication: random_float(),
        average_professionalism: random_float(),
        average_rating: random_float(),
        average_work_quality: random_float()
      }),
      Accounts.update_pro_rating(pro_rating7, %{
        average_communication: random_float(),
        average_professionalism: random_float(),
        average_rating: random_float(),
        average_work_quality: random_float()
      }),
      Accounts.update_pro_rating(pro_rating8, %{
        average_communication: random_float(),
        average_professionalism: random_float(),
        average_rating: random_float(),
        average_work_quality: random_float()
      }),
      Accounts.update_pro_rating(pro_rating9, %{
        average_communication: random_float(),
        average_professionalism: random_float(),
        average_rating: random_float(),
        average_work_quality: random_float()
      })
    ]
  end

  @spec update_deleted_user() :: Ecto.Schema.t()
  defp update_deleted_user do
    deleted_user_ids = Enum.map(Repo.all(DeletedUser), fn(data) -> data end)

    {
      deleted1,
      deleted2,
      deleted3,
      deleted4,
      deleted5,
      deleted6,
      deleted7
    } = {
      Enum.at(deleted_user_ids, 0),
      Enum.at(deleted_user_ids, 1),
      Enum.at(deleted_user_ids, 2),
      Enum.at(deleted_user_ids, 3),
      Enum.at(deleted_user_ids, 4),
      Enum.at(deleted_user_ids, 5),
      Enum.at(deleted_user_ids, 6)
    }

    [
      Accounts.update_deleted_user(deleted1, %{reason: random_reason()}),
      Accounts.update_deleted_user(deleted2, %{reason: random_reason()}),
      Accounts.update_deleted_user(deleted3, %{reason: random_reason()}),
      Accounts.update_deleted_user(deleted4, %{reason: random_reason()}),
      Accounts.update_deleted_user(deleted5, %{reason: random_reason()}),
      Accounts.update_deleted_user(deleted6, %{reason: random_reason()}),
      Accounts.update_deleted_user(deleted7, %{reason: random_reason()})
    ]
  end

  @spec random_reason :: [String.t()]
  defp random_reason do
    names = [
      "another_service",
      "change_account",
      "needs",
      "no_longer_require",
      "not_easy",
      "quality",
      "wrong_account"
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
    :random.uniform() * 100
    |> Float.round(2)
  end
end

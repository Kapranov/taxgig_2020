defmodule Core.Seeder.Updated.Accounts do
  @moduledoc """
  An update are seeds whole an accounts.
  """

  alias Core.{
    Accounts,
    Accounts.BanReason,
    Accounts.Platform,
    Repo
  }

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_profile()
    update_subscriber()
    update_user()
    update_ban_reason()
    update_platform()
  end

  @spec update_profile() :: Ecto.Schema.t()
  defp update_profile do
  end

  @spec update_subscriber() :: Ecto.Schema.t()
  defp update_subscriber do
  end

  @spec update_user() :: Ecto.Schema.t()
  defp update_user do
  end

  @spec update_ban_reason() :: Ecto.Schema.t()
  defp update_ban_reason do
    ban_reason_ids =
      Enum.map(Repo.all(BanReason), fn(data) -> data end)

    {br1} = {Enum.at(ban_reason_ids, 0)}

    Accounts.update_ban_reason(br1, %{
      reasons: random_reasons(),
      other: random_boolean(),
      other_description: "updated some text"
    })
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
end

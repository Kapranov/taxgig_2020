defmodule Core.Seeder.Updated.Accounts do
  @moduledoc """
  An update are seeds whole an accounts.
  """

  alias Core.{
    Accounts,
    Accounts.BanReason,
    Repo
  }

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_profile()
    update_subscriber()
    update_user()
    update_ban_reason()
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

  @spec random_boolean() :: boolean()
  defp random_boolean do
    value = ~W(true false)a
    Enum.random(value)
  end
end

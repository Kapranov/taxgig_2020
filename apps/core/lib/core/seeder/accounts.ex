defmodule Core.Seeder.Accounts do
  @moduledoc """
  Seeds for `Core.Accounts` context.
  """

  alias Core.Accounts.Subscriber
  alias Core.Repo

  def reset_database! do
    Repo.delete_all(Subscriber)
  end

  def seed! do
    seed_subscriber()
  end

  defp seed_subscriber do
    case Repo.aggregate(Subscriber, :count, :id) > 0 do
      true -> nil
      false -> insert_subscriber()
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
end

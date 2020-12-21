defmodule Core.Seeder.Deleted.Accounts do
  @moduledoc """
  Deleted are seeds whole an accounts.
  """

  alias Core.Repo
  alias Ecto.Adapters.SQL

  @spec start!() :: Ecto.Schema.t()
  def start! do
    deleted_deleted_user()
    deleted_platform()
  end

  @spec deleted_deleted_user() :: Ecto.Schema.t()
  defp deleted_deleted_user do
    IO.puts("Deleting data on model's DeletedUser\n")
    SQL.query!(Repo, "TRUNCATE deleted_users CASCADE;")
  end

  @spec deleted_platform() :: Ecto.Schema.t()
  defp deleted_platform do
    IO.puts("Deleting data on model's Platform\n")
    SQL.query!(Repo, "TRUNCATE platforms CASCADE;")
  end
end

defmodule Core.Seeder.Deleted.Accounts do
  @moduledoc """
  Deleted are seeds whole an accounts.
  """

  alias Core.Repo
  alias Ecto.Adapters.SQL

  @spec start!() :: Ecto.Schema.t()
  def start! do
    deleted_deleted_user()
  end

  @spec deleted_deleted_user() :: Ecto.Schema.t()
  defp deleted_deleted_user do
    IO.puts("Deleting data on model's DeletedUser\n")
    SQL.query!(Repo, "TRUNCATE deleted_users CASCADE;")
  end
end

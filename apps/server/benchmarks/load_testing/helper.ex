defmodule Server.LoadTesting.Helper do
  alias Ecto.Adapters.SQL
  alias Core.Repo

  def to_sec(microseconds), do: microseconds / 1_000_000

  def clean_tables do
    IO.puts("Deleting old data...\n")
    SQL.query!(Repo, "TRUNCATE users CASCADE;")
    SQL.query!(Repo, "TRUNCATE subscribers CASCADE;")
  end
end

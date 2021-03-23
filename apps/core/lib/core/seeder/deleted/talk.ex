defmodule Core.Seeder.Deleted.Talk do
  @moduledoc """
  Deleted are seeds whole the talk.
  """

  alias Core.Repo
  alias Ecto.Adapters.SQL

  @spec start!() :: Ecto.Schema.t()
  def start! do
    # deleted_message()
    # deleted_report()
    # deleted_room()
  end

  @spec deleted_message() :: Ecto.Schema.t()
  defp deleted_message do
    IO.puts("Deleting data on model's Message\n")
    SQL.query!(Repo, "TRUNCATE messages CASCADE;")
  end

  @spec deleted_report() :: Ecto.Schema.t()
  defp deleted_report do
    IO.puts("Deleting data on model's Report\n")
    SQL.query!(Repo, "TRUNCATE reports CASCADE;")
  end

  @spec deleted_room() :: Ecto.Schema.t()
  defp deleted_room do
    IO.puts("Deleting data on model's Room\n")
    SQL.query!(Repo, "TRUNCATE rooms CASCADE;")
  end
end

defmodule Core.Seeder.Deleted.Media do
  @moduledoc """
  Deleted are seeds whole a media.
  """

  alias Core.Repo
  alias Ecto.Adapters.SQL

  @spec start!() :: Ecto.Schema.t()
  def start! do
    deleted_picture()
    deleted_pro_doc()
    deleted_tp_doc()
  end

  @spec deleted_picture() :: Ecto.Schema.t()
  defp deleted_picture do
    IO.puts("Deleting data on model's Picture\n")
    SQL.query!(Repo, "TRUNCATE pictures CASCADE;")
  end

  @spec deleted_pro_doc() :: Ecto.Schema.t()
  defp deleted_pro_doc do
    IO.puts("Deleting data on model's ProDoc\n")
    SQL.query!(Repo, "TRUNCATE pro_docs CASCADE;")
  end

  @spec deleted_tp_doc() :: Ecto.Schema.t()
  defp deleted_tp_doc do
    IO.puts("Deleting data on model's TpDoc\n")
    SQL.query!(Repo, "TRUNCATE tp_docs CASCADE;")
  end
end

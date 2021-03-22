defmodule Core.Seeder.Deleted.Accounts do
  @moduledoc """
  Deleted are seeds whole an accounts.
  """

  alias Core.Repo
  alias Ecto.Adapters.SQL

  @spec start!() :: Ecto.Schema.t()
  def start! do
    # deleted_ban_reason()
    # deleted_deleted_user()
    # deleted_platform()
    # deleted_pro_rating()
    # deleted_pro_ratings_project()
  end

  @spec deleted_ban_reason() :: Ecto.Schema.t()
  defp deleted_ban_reason do
    IO.puts("Deleting data on model's BanReason\n")
    SQL.query!(Repo, "TRUNCATE ban_reasons CASCADE;")
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

  @spec deleted_pro_rating() :: Ecto.Schema.t()
  defp deleted_pro_rating do
    IO.puts("Deleting data on model's ProRating\n")
    SQL.query!(Repo, "TRUNCATE pro_ratings CASCADE;")
  end

  @spec deleted_pro_ratings_project() :: Ecto.Schema.t()
  defp deleted_pro_ratings_project do
    IO.puts("Deleting data on model's ProRatingsProject\n")
    SQL.query!(Repo, "TRUNCATE pro_ratings_projects CASCADE;")
  end
end

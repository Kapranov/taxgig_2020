defmodule Core.Seeder.Deleted.Contracts do
  @moduledoc """
  Deleted are seeds whole the contracts.
  """

  alias Core.Repo
  alias Ecto.Adapters.SQL

  @spec start!() :: Ecto.Schema.t()
  def start! do
    deleted_addon()
    deleted_offer()
    deleted_potential_client()
    deleted_service_review()
    deleted_project()
  end

  @spec deleted_addon() :: Ecto.Schema.t()
  defp deleted_addon do
    IO.puts("Deleting data on model's an Addon\n")
    SQL.query!(Repo, "TRUNCATE addons CASCADE;")
  end

  @spec deleted_offer() :: Ecto.Schema.t()
  defp deleted_offer do
    IO.puts("Deleting data on model's an Offer\n")
    SQL.query!(Repo, "TRUNCATE offers CASCADE;")
  end

  @spec deleted_service_review() :: Ecto.Schema.t()
  defp deleted_service_review do
    IO.puts("Deleting data on model's ServiceReview\n")
    # SQL.query!(Repo, "TRUNCATE service_reviews CASCADE;")
  end

  @spec deleted_potential_client() :: Ecto.Schema.t()
  defp deleted_potential_client do
    IO.puts("Deleting data on model's PotentialClient\n")
    SQL.query!(Repo, "TRUNCATE potential_clients CASCADE;")
  end

  @spec deleted_project() :: Ecto.Schema.t()
  defp deleted_project do
    IO.puts("Deleting data on model's Project\n")
    SQL.query!(Repo, "TRUNCATE projects CASCADE;")
  end
end

defmodule Core.Seeder.Deleted.Contracts do
  @moduledoc """
  Deleted are seeds whole the contracts.
  """

  alias Core.Repo
  alias Ecto.Adapters.SQL

  @spec start!() :: Ecto.Schema.t()
  def start! do
    deleted_service_review()
    deleted_offer()
  end

  @spec deleted_service_review() :: Ecto.Schema.t()
  defp deleted_service_review do
    IO.puts("Deleting data on model's ServiceReview\n")
    SQL.query!(Repo, "TRUNCATE service_reviews CASCADE;")
  end

  @spec deleted_offer() :: Ecto.Schema.t()
  defp deleted_offer do
    IO.puts("Deleting data on model's an Offer\n")
    SQL.query!(Repo, "TRUNCATE offers CASCADE;")
  end
end

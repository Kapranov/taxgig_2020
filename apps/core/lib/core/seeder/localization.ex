defmodule Core.Seeder.Localization do
  @moduledoc """
  Seeds for `Core.Localization` context.
  """

  alias Core.{
    Localization.Language,
    Repo
  }

  alias Ecto.Adapters.SQL

  @root_dir Path.expand("../../../priv/data/", __DIR__)
  @languages "#{@root_dir}/languages.json"

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    IO.puts("Deleting old data...\n")
    SQL.query!(Repo, "TRUNCATE languages CASCADE;")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_language()
  end

  @spec seed_language() :: nil | Ecto.Schema.t()
  defp seed_language do
    case Repo.aggregate(Language, :count, :id) > 0 do
      true -> nil
      false -> insert_language()
    end
  end

  @spec insert_language() :: Ecto.Schema.t()
  defp insert_language do
    languages =
      @languages
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(fn %{"abbr" => abbr, "name" => name} ->
         %{abbr: abbr, name: name}
      end)

    Repo.insert_all(Language, languages)
  end
end

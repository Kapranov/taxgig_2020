defmodule Core.Seeder.Localization do
  @moduledoc """
  Seeds for `Core.Localization` context.
  """

  alias Core.{
    Localization.Language,
    Repo
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(Language)
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
    [
      Repo.insert!(%Language{
        abbr: "ara",
        name: "arabic"
      }),
      Repo.insert!(%Language{
        abbr: "ben",
        name: "bengali"
      }),
      Repo.insert!(%Language{
        abbr: "chi",
        name: "chinese"
      }),
      Repo.insert!(%Language{
        abbr: "fra",
        name: "french"
      }),
      Repo.insert!(%Language{
        abbr: "ger",
        name: "german"
      }),
      Repo.insert!(%Language{
        abbr: "gre",
        name: "greek"
      }),
      Repo.insert!(%Language{
        abbr: "heb",
        name: "hebrew"
      }),
      Repo.insert!(%Language{
        abbr: "hin",
        name: "hindi"
      }),
      Repo.insert!(%Language{
        abbr: "ita",
        name: "italian"
      }),
      Repo.insert!(%Language{
        abbr: "jpn",
        name: "japanese"
      }),
      Repo.insert!(%Language{
        abbr: "kor",
        name: "korean"
      }),
      Repo.insert!(%Language{
        abbr: "pol",
        name: "polish"
      }),
      Repo.insert!(%Language{
        abbr: "por",
        name: "portuguese"
      }),
      Repo.insert!(%Language{
        abbr: "rus",
        name: "russian"
      }),
      Repo.insert!(%Language{
        abbr: "spa",
        name: "spanish"
      }),
      Repo.insert!(%Language{
        abbr: "tur",
        name: "turkish"
      }),
      Repo.insert!(%Language{
        abbr: "ukr",
        name: "ukraine"
      }),
      Repo.insert!(%Language{
        abbr: "vie",
        name: "vietnamese"
      })
    ]
  end
end

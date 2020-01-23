defmodule Core.Repo.Migrations.CreatePressArticles do
  use Ecto.Migration

  def change do
    create table(:press_articles, primary_key: false) do
      add :id, :uuid, primary_key: true,
        default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :author, :string
      add :preview_text, :string
      add :title, :string
      add :url, :string

      timestamps(type: :utc_datetime_usec)
    end
  end
end

defmodule Core.Repo.Migrations.CreateLanguages do
  use Ecto.Migration

  def change do
    create table(:languages, primary_key: false) do
      add :id, :uuid, primary_key: true,
        default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :name, :string
      add :abbr, :string

      timestamps(type: :utc_datetime_usec)
    end

    create(unique_index(:languages, [:name]))
  end
end

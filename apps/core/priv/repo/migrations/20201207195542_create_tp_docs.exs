defmodule Core.Repo.Migrations.CreateTpDocs do
  use Ecto.Migration

  def change do
    create table(:tp_docs, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :access_granted, :boolean, null: false
      add :category, :string, null: false
      add :file, :map, null: false, default: Map.new()
      add :project_id, references(:projects, type: :uuid, on_delete: :delete_all), null: false, primary_key: false
      add :signed_by_tp, :boolean, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:tp_docs, [:project_id])
  end
end

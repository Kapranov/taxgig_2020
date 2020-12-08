defmodule Core.Repo.Migrations.CreateProDocs do
  use Ecto.Migration

  def change do
    create table(:pro_docs, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :category, :string, null: false
      add :file, :map, null: false, default: Map.new()
      add :project_id, references(:projects, type: :uuid, on_delete: :delete_all), null: false, primary_key: false
      add :signature, :boolean, null: false
      add :signed_by_pro, :boolean, null: false
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:pro_docs, [:user_id])
    create unique_index(:pro_docs, [:project_id])
  end
end

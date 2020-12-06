defmodule Core.Repo.Migrations.CreateProjectDocs do
  use Ecto.Migration

  def change do
    create table(:project_docs, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :doc_tp, :map, null: true
      add :doc_pro, :map, null: true
      add :project_id, references(:projects, type: :uuid, on_delete: :delete_all), null: false, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create(unique_index(:project_docs, [:project_id], name: :project_docs_project_id_index))
  end
end

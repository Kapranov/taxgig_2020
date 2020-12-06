defmodule Core.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :access_granted, :boolean, null: false
      add :category, :string, null: false
      add :file, :map
      add :format, :string, null: false
      add :name, :string, null: false
      add :project_id, references(:projects, type: :uuid, on_delete: :delete_all), null: false, primary_key: false
      add :signature, :boolean, null: false
      add :signed_by_pro, :boolean, null: false
      add :signed_by_tp, :boolean, null: false
      add :url, :string, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:documents, [:project_id])
  end
end

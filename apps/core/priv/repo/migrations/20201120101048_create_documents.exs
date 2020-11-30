defmodule Core.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:documents, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :access_granted, :boolean
      add :category, :integer
      add :document_link, :string
      add :format, :integer
      add :name, :integer
      add :project_id, references(:projects, type: :uuid, on_delete: :delete_all), null: false, primary_key: false
      add :signature_required_from_client, :boolean
      add :signed_by_client, :boolean
      add :signed_by_pro, :boolean
      add :size, :decimal, default: 0.0
      add :uploader, :map, null: true

      timestamps(type: :utc_datetime_usec)
    end

    create(unique_index(:documents, [:project_id], name: :documents_project_id_index))
  end
end

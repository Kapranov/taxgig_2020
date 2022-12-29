defmodule Core.Repo.Migrations.CreateSignatures do
  use Ecto.Migration

  def change do
    create table(:signatures, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :altitude , :decimal, null: false, default: 0.0
      add :longitude, :decimal, null: false, default: 0.0
      add :pro_doc_id, references(:pro_docs, type: :uuid, on_delete: :delete_all), null: true, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:signatures, [:pro_doc_id])
  end
end

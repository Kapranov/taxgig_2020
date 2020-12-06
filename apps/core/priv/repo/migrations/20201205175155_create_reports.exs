defmodule Core.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :message_id, references(:messages, type: :uuid, on_delete: :delete_all), null: false, primary_key: false
      add :other, :boolean, null: false
      add :other_description, :string, null: true
      add :reasons, :string, null: true

      timestamps(type: :utc_datetime_usec)
    end

    create(unique_index(:reports, [:message_id], name: :reports_message_id_index))
  end
end

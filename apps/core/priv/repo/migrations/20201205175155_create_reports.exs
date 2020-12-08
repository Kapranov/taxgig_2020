defmodule Core.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :description, :string, null: true
      add :messages, {:array, :string}, null: false, default: []
      add :other, :boolean, null: true
      add :reasons, :string, null: true
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:reports, [:user_id])
  end
end

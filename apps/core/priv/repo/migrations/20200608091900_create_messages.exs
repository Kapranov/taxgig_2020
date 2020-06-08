defmodule Core.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :body, :string
      add :room_id, references(:rooms, type: :uuid, on_delete: :delete_all), null: false, primary_key: false
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:messages, [:room_id])
    create index(:messages, [:user_id])
  end
end

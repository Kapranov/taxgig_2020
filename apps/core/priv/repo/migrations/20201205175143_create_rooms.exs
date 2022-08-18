defmodule Core.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :active, :boolean, null: false, default: false
      add :description, :string, null: true
      add :last_msg, :string, null: true
      add :name, :string, size: 120, null: false
      add :participant_id, references(:users, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :project_id, references(:projects, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :topic, :string, size: 120, null: true
      add :unread_msg, :integer, null: true
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: true, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end
  end
end

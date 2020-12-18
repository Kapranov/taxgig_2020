defmodule Core.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :active, :boolean, null: false, default: false
      add :description, :string, null: false
      add :name, :string, size: 30, null: false
      add :topic, :string, size: 120, null: false
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: true, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create(unique_index(:rooms, [:user_id], name: :rooms_user_id_index))
  end
end

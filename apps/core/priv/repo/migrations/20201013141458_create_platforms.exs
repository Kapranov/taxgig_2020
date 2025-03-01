defmodule Core.Repo.Migrations.CreatePlatforms do
  use Ecto.Migration

  def change do
    create table(:platforms, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :client_limit_reach, :boolean, null: true
      add :hero_active, :boolean, null: true
      add :hero_status, :boolean, null: true
      add :is_banned, :boolean, null: false, default: false
      add :is_online, :boolean, null: false, default: false
      add :is_stuck, :boolean, null: false, default: false
      add :payment_active, :boolean,  null: false, default: false
      add :stuck_stage, :string, null: true
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: true, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create(unique_index(:platforms, [:user_id], name: :platforms_user_id_index))
  end
end

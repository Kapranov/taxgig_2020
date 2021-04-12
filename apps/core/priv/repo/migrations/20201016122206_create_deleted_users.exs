defmodule Core.Repo.Migrations.CreateDeletedUsers do
  use Ecto.Migration

  def change do
    create table(:deleted_users, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :reason, :string, null: false
      add :user_id, :uuid, type: FlakeId.Ecto.Type, null: false

      timestamps(type: :utc_datetime_usec)
    end
  end
end

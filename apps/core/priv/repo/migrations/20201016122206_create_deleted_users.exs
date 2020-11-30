defmodule Core.Repo.Migrations.CreateDeletedUsers do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:deleted_users, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :reason, :string, null: false
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create(unique_index(:deleted_users, [:user_id], name: :deleted_users_user_id_index))
  end
end

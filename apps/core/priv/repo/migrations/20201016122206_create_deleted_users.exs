defmodule Core.Repo.Migrations.CreateDeletedUsers do
  use Ecto.Migration

  def change do
    create table(:deleted_users, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :email, :string, null: false
      add :reason, :string, null: false
      add :role, :boolean, null: false
      add :user_id, :uuid, type: FlakeId.Ecto.Type, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create(unique_index(:deleted_users, [:email], name: :deleted_users_email_index))
  end
end

defmodule Core.Repo.Migrations.CreateUsersLanguages do
  use Ecto.Migration

  def change do
    create table(:users_languages, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :language_id, references(:languages, type: :uuid, on_delete: :delete_all), null: false, primary_key: false
      add :user_id,     references(:users,     type: :uuid, on_delete: :delete_all), null: false, primary_key: false
    end

    create index(:users_languages, [:language_id])
    create index(:users_languages, [:user_id])
    create(unique_index(:users_languages, [:user_id, :language_id], name: :user_id_language_id_unique_index))
  end
end

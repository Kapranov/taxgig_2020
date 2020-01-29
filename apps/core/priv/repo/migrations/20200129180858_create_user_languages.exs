defmodule Core.Repo.Migrations.CreateUserLanguages do
  use Ecto.Migration

  def change do
    create table(:user_languages, primary_key: false) do
      add :id, :uuid, primary_key: true,
        default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :language_id, references(:languages, type: :uuid, on_delete: :delete_all), null: false, primary_key: false
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:user_languages, [:language_id])
    create index(:user_languages, [:user_id])
  end
end

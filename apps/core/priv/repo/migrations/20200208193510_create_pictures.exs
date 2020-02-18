defmodule Core.Repo.Migrations.CreatePictures do
  use Ecto.Migration

  def change do
    create table(:pictures, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :file, :map
      add :profile_id, references(:profiles, column: "user_id", type: :uuid, on_delete: :delete_all), null: false, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:pictures, [:profile_id])
  end
end

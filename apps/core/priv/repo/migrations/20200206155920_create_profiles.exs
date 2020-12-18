defmodule Core.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :address, :string, null: true
      add :banner, :string, null: true
      add :description, :string, null: true
      add :logo, :map, null: true
      add :us_zipcode_id, references(:us_zipcodes, type: :uuid, null: true, on_delete: :delete_all)
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: true, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create(unique_index(:profiles, [:user_id], name: :profiles_user_id_index))
  end
end

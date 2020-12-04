defmodule Core.Repo.Migrations.CreateAddons do
  use Ecto.Migration

  def change do
    create table(:addons, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :price, :integer, null: false
      add :project_id, references(:projects, type: :uuid, on_delete: :delete_all), null: false, primary_key: false
      add :status, :string, null: false
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:addons, [:project_id])
    create index(:addons, [:user_id])
  end
end

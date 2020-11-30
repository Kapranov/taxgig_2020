defmodule Core.Repo.Migrations.CreatePotentialClients do
  use Ecto.Migration

  def change do
    create table(:potential_clients, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :project, {:array, :string}, null: false, default: []
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:potential_clients, [:user_id])
    create(unique_index(:potential_clients, [:user_id], name: :user_id_unique_index))
  end
end

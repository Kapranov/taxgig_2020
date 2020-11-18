defmodule Core.Repo.Migrations.CreatePotentialClients do
  use Ecto.Migration

  def change do
    create table(:potential_clients, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :project_id, references(:potential_clients, type: :uuid, on_delete: :delete_all), null: false, primary_key: false
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false, primary_key: false
    end

    create index(:potential_clients, [:project_id])
    create index(:potential_clients, [:user_id])
    create(unique_index(:potential_clients, [:user_id, :project_id], name: :user_id_project_id_unique_index))
  end
end

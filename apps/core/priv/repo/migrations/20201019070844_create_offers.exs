defmodule Core.Repo.Migrations.CreateOffers do
  use Ecto.Migration

  def change do
    create table(:offers, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :price, :integer, null: false
      add :project_id, references(:projects, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :status, :string, null: false, default: "Sent"
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: true, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:offers, [:project_id])
    create index(:offers, [:user_id])
  end
end

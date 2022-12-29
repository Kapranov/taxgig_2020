defmodule Core.Repo.Migrations.CreateNotifies do
  use Ecto.Migration

  def change do
    create table(:notifies, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :is_hidden, :boolean, null: false, default: false
      add :is_read, :boolean, null: false, default: false
      add :project_id, references(:projects, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :room_id, references(:rooms, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :sender_id, references(:users, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :service_review_id, references(:service_reviews, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :template, :integer, null: false
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: true, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:notifies, [:project_id])
    create index(:notifies, [:room_id])
    create index(:notifies, [:service_review_id])
    create index(:notifies, [:user_id])
  end
end

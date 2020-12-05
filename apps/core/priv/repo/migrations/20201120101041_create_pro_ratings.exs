defmodule Core.Repo.Migrations.CreateProRatings do
  use Ecto.Migration

  def change do
    create table(:pro_ratings, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :average_communication, :decimal, null: false
      add :average_professionalism, :decimal, null: false
      add :average_rating, :decimal, null: false
      add :average_work_quality, :decimal, null: false
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:pro_ratings, [:user_id])
  end
end

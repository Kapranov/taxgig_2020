defmodule Core.Repo.Migrations.CreateServiceReviews do
  use Ecto.Migration

  def change do
    create table(:service_reviews, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :client_comment, :string, null: true
      add :communication, :integer, null: false
      add :final_rating, :decimal, null: false
      add :pro_response, :string, null: true
      add :professionalism, :integer, null: false
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :work_quality, :integer, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:service_reviews, [:user_id])
  end
end

defmodule Core.Repo.Migrations.CreateWorkExperiences do
  use Ecto.Migration

  def change do
    create table(:work_experiences, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :end_date, :date, null: true
      add :name, :string, null: true
      add :position, :string, null: true
      add :start_date, :date, ull: true
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: true, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:work_experiences, [:user_id])
  end
end

defmodule Core.Repo.Migrations.CreateEducations do
  use Ecto.Migration

  def change do
    create table(:educations, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :course, :string, default: nil, null: true
      add :graduation, :date, default: nil, null: true
      add :university_id, references(:universities, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: true, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:educations, [:user_id])
    create(unique_index(:educations, [:university_id], name: :universities_user_id_index))
  end
end

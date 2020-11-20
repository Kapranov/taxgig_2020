defmodule Core.Repo.Migrations.CreateProRatingProjects do
  use Ecto.Migration

  def change do
    create table(:pro_rating_projects, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :pro_rating_id, references(:pro_ratings, type: :uuid, on_delete: :delete_all), null: false, primary_key: false
      add :project_id, references(:projects, type: :uuid, on_delete: :delete_all), null: false, primary_key: false
    end

    create index(:pro_rating_projects, [:pro_rating_id])
    create index(:pro_rating_projects, [:project_id])
    create(unique_index(:pro_rating_projects, [:pro_rating_id, :project_id], name: :pro_rating_id_project_id_unique_index))
  end
end

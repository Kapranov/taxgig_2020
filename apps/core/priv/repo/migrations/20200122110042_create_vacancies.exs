defmodule Core.Repo.Migrations.CreateVacancies do
  use Ecto.Migration

  def change do
    create table(:vacancies, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :content, :string
      add :department, :string
      add :title, :string

      timestamps(type: :utc_datetime_usec)
    end
  end
end

defmodule Core.Repo.Migrations.CreateFaqCategories do
  use Ecto.Migration

  def change do
    create table(:faq_categories, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :title, :string

      timestamps(type: :utc_datetime_usec)
    end
  end
end

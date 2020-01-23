defmodule Core.Repo.Migrations.CreateFaqs do
  use Ecto.Migration

  def change do
    create table(:faqs, primary_key: false) do
      add :id, :uuid, primary_key: true,
        default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :content, :string
      add :faq_category_id, references(:faq_categories,
        type: :uuid, on_delete: :delete_all), null: false, primary_key: false
      add :title, :string

      timestamps(type: :utc_datetime_usec)
    end

    create index(:faqs, [:faq_category_id])
  end
end

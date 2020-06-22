defmodule Core.Repo.Migrations.CreateBookKeepingClassifyInventories do
  use Ecto.Migration

  def change do
    create table(:book_keeping_classify_inventories, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :book_keeping_id, references(:book_keepings, type: :uuid, on_delete: :delete_all), null: false, primary_key: false
      add :name, :string, default: nil, null: true

      timestamps(type: :utc_datetime_usec)
    end

    create index(:book_keeping_classify_inventories, [:book_keeping_id])
  end
end

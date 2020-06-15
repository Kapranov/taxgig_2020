defmodule Core.Repo.Migrations.CreateBookKeepings do
  use Ecto.Migration

  def change do
    create table(:book_keepings, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :active, :boolean, default: true, null: false
      add :account_count, :integer, default: nil, null: true
      add :balance_sheet, :boolean, default: nil, null: true
      add :financial_situation, :text, default: nil, null: true
      add :inventory, :boolean, default: nil, null: true
      add :inventory_count, :integer, default: nil, null: true
      add :payroll, :boolean, default: nil, null: true
      add :price_payroll, :integer, default: nil, null: true
      add :tax_return_current, :boolean, default: nil, null: true
      add :tax_year, {:array, :string}, default: nil, null: true
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:book_keepings, [:user_id])
  end
end

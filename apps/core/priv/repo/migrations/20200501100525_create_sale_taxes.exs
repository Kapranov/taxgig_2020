defmodule Core.Repo.Migrations.CreateSaleTaxes do
  use Ecto.Migration

  def change do
    create table(:sale_taxes, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :active, :boolean, default: true, null: false
      add :deadline, :date, default: nil, null: true
      add :financial_situation, :text, default: nil, null: true
      add :price_sale_tax_count, :integer, default: nil, null: true
      add :sale_tax_count, :integer, default: nil, null: true
      add :state, {:array, :string}, default: nil, null: true
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: true, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:sale_taxes, [:user_id])
  end
end

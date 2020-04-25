defmodule Core.Repo.Migrations.CreateIndividualStockTransactionCounts do
  use Ecto.Migration

  def change do
    create table(:individual_stock_transaction_counts, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :individual_tax_return_id, references(:individual_tax_returns, type: :uuid, on_delete: :delete_all), null: false, primary_key: false
      add :name, :string, default: nil, null: true

      timestamps(type: :utc_datetime_usec)
    end

    create index(:individual_stock_transaction_counts, [:individual_tax_return_id])
  end
end

defmodule Core.Repo.Migrations.CreatePlaidTransactions do
  use Ecto.Migration

  def change do
    create table(:plaid_transactions, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :from_plaid_transaction_address, :string, null: true
      add :from_plaid_transaction_amount, :decimal, default: 0.0, null: false
      add :from_plaid_transaction_authorization_date, :date, default: nil, null: true
      add :from_plaid_transaction_category, {:array, :string}, default: nil, null: true
      add :from_plaid_transaction_city, :string, null: true
      add :from_plaid_transaction_country, :string, null: true
      add :from_plaid_transaction_currency, :string, null: true
      add :from_plaid_transaction_merchant_name, :string, null: true
      add :from_plaid_transaction_name, :string, null: false
      add :from_plaid_transaction_postal_code, :string, null: true
      add :from_plaid_transaction_region, :string, null: true
      add :id_from_plaid_transaction, :string, null: false
      add :id_from_plaid_transaction_category, :string, null: true
      add :plaid_account_id, references(:plaid_accounts, type: :uuid, on_delete: :delete_all), null: true, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:plaid_transactions, [:plaid_account_id])
    create(unique_index(:plaid_transactions, [:id_from_plaid_transaction], name: :plaid_transactions_id_from_plaid_transaction_index))
  end
end

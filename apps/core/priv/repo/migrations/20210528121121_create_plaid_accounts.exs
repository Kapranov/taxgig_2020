defmodule Core.Repo.Migrations.CreatePlaidAccounts do
  use Ecto.Migration

  def change do
    create table(:plaid_accounts, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :from_plaid_account_mask, :string, null: true
      add :from_plaid_account_name, :string, null: false
      add :from_plaid_account_official_name, :string, null: true
      add :from_plaid_account_subtype, :string, null: true
      add :from_plaid_account_type, :string, null: false
      add :from_plaid_balance_currency, :string, null: true
      add :from_plaid_balance_current, :decimal, default: 0.0, null: false
      add :from_plaid_total_transaction, :integer, null: false
      add :id_from_plaid_account, :string, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create(unique_index(:plaid_accounts, [:id_from_plaid_account], name: :plaid_accounts_id_from_plaid_account_index))
  end
end

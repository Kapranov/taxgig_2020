defmodule Stripy.Repo.Migrations.CreateStripeBankAccountToken do
  use Ecto.Migration

  def change do
    create table(:stripe_bank_account_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :id_from_stripe, :string, null: false
      add :account_holder_name, :string, null: false
      add :account_holder_type, :string, null: false
      add :bank_name, :string, null: false
      add :client_ip, :string, null: false
      add :country, :string, null: false
      add :created, :integer, null: false
      add :currency, :string, null: false
      add :fingerprint, :string, null: false
      add :id_from_bank_account, :string, null: false
      add :last4, :string, null: false
      add :routing_number, :string, null: false
      add :status, :string, null: false
      add :used, :boolean, null: false
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:stripe_bank_account_tokens, [:user_id])
    create unique_index(:stripe_bank_account_tokens, [:id_from_stripe], name: :stripe_bank_account_tokens_id_from_stripe_index)
    create unique_index(:stripe_bank_account_tokens, [:id_from_bank_account], name: :stripe_bank_account_tokens_id_from_bank_account_index)
  end
end

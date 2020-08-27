defmodule Stripy.Repo.Migrations.CreateStripeBankAccountToken do
  use Ecto.Migration

  def change do
    create table(:stripe_bank_account_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :account_holder_name, :string
      add :account_holder_type, :string
      add :bank_account, :string, null: false
      add :bank_name, :string
      add :bank_token, :string, null: false
      add :country, :string
      add :currency, :string
      add :created, :integer, null: false
      add :fingerprint, :string
      add :last4, :string, null: false
      add :routing_number, :string, null: false
      add :status, :string, null: false
      add :used, :boolean, null: false
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_bank_account_tokens, [:bank_token], name: :stripe_bank_account_tokens_bank_token_index)
  end
end

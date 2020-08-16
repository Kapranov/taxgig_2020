defmodule Stripy.Repo.Migrations.CreateStripeExternalAccountBank do
  use Ecto.Migration

  def change do
    create table(:stripe_external_account_banks, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :id_from_stripe, :string, null: false
      add :account_holder_name, :string
      add :account_holder_type, :string
      add :account_id_from_stripe, :string, null: false
      add :bank_name, :string
      add :country, :string
      add :currency, :string
      add :customer_id, :string, null: false
      add :default_for_currency, :boolean
      add :fingerprint, :string
      add :last4, :string
      add :routing_number, :string
      add :status, :string
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_external_account_banks, [:id_from_stripe], name: :stripe_external_account_banks_id_from_stripe_index)
  end
end

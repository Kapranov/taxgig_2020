defmodule Stripy.Repo.Migrations.CreateStripeExternalAccountCard do
  use Ecto.Migration

  def change do
    create table(:stripe_external_account_cards, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :id_from_stripe, :string, null: false
      add :id_from_account, :string, null: false
      add :brand, :string, null: false
      add :country, :string, null: false
      add :currency, :string, null: false
      add :cvc_check, :string, null: false
      add :default_for_currency, :boolean, null: false
      add :exp_month, :integer, null: false
      add :exp_year, :integer, null: false
      add :fingerprint, :string, null: false
      add :funding, :string, null: false
      add :last4, :string, null: false
      add :name, :string, null: false
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:stripe_external_account_cards, [:id_from_account])
    create index(:stripe_external_account_cards, [:user_id])
    create unique_index(:stripe_external_account_cards, [:id_from_stripe], name: :stripe_external_account_cards_id_from_stripe_index)
  end
end

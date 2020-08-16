defmodule Stripy.Repo.Migrations.CreateStripeExternalAccountCard do
  use Ecto.Migration

  def change do
    create table(:stripe_external_account_cards, primary_key: false) do
      add :id_from_stripe, :string, null: false
      add :account_id_from_stripe, :string, null: false
      add :brand, :string
      add :country, :string
      add :currency, :string
      add :customer_id, :string, null: false
      add :cvc, :integer
      add :cvc_check, :string
      add :default_for_currency, :boolean
      add :dynamic_last4, :string
      add :exp_month, :integer, null: false
      add :exp_year, :integer, null: false
      add :fingerprint, :string
      add :funding, :string
      add :last4, :string
      add :metadata, {:array, :map}
      add :name, :string
      add :number, :string, null: false
      add :tokenization_method, :string
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_external_account_cards, [:id_from_stripe], name: :stripe_external_account_cards_id_from_stripe_index)
  end
end

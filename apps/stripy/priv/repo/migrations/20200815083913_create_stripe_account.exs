defmodule Stripy.Repo.Migrations.CreateStripeAccount do
  use Ecto.Migration

  def change do
    create table(:stripe_accounts, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :id_from_stripe, :string, null: false
      add :business_url, :string, null: false, default: "https://taxgig.com"
      add :capabilities, :map, null: false
      add :charges_enabled, :boolean, null: false
      add :country, :string, null: false, default: "US"
      add :created, :integer, null: false
      add :default_currency, :string, null: false, default: "usd"
      add :details_submitted, :boolean, null: false
      add :email, :string, null: false
      add :payouts_enabled, :boolean, null: false
      add :tos_acceptance, :map, null: false
      add :type, :string, null: false, default: "custom"
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_accounts, [:email], name: :stripe_accounts_email_index)
    create unique_index(:stripe_accounts, [:id_from_stripe], name: :stripe_accounts_id_from_stripe_index)
    create unique_index(:stripe_accounts, [:user_id], name: :stripe_accounts_user_id_index)
  end
end

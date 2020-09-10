defmodule Stripy.Repo.Migrations.CreateStripeAccount do
  use Ecto.Migration

  def change do
    create table(:stripe_accounts, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :id_from_stripe, :string, null: false
      add :business_type, :string, default: "individual"
      add :capabilities, {:array, :map}
      add :charges_enabled, :boolean
      add :country, :string, default: "US"
      add :created, :integer
      add :default_currency, :string, default: "usd"
      add :details_submitted, :boolean
      add :email, :string
      add :payouts_enabled, :boolean
      add :requirements, {:array, :map}
      add :tos_acceptance, {:array, :map}
      add :type, :string, default: "custom"
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_accounts, [:email], name: :stripe_accounts_email_index)
    create unique_index(:stripe_accounts, [:id_from_stripe], name: :stripe_accounts_id_from_stripe_index)
  end
end

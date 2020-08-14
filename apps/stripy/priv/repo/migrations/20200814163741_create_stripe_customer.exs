defmodule Stripy.Repo.Migrations.CreateStripeCustomer do
  use Ecto.Migration

  def change do
    create table(:stripe_customers, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :stripe_customer_id, :string, null: false
      add :account_balance, :integer
      add :address, {:array, :map}
      add :created, :integer
      add :currency, :string
      add :default_source, :string
      add :delinquent, :boolean
      add :description, :string
      add :discount, {:array, :map}
      add :email, :string, null: false
      add :invoice_prefix, :string
      add :invoice_settings, {:array, :map}
      add :livemode, :boolean
      add :metadata, {:array, :map}
      add :name, :string
      add :phone, :string
      add :preferred_locales, {:array, :map}
      add :shipping, {:array, :map}
      add :sources, {:array, :map}
      add :subscriptions, {:array, :map}
      add :tax_exempt, :string
      add :tax_ids, {:array, :map}
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_customers, [:stripe_customer_id], name: :stripe_customers_stripe_customer_id_index)
  end
end

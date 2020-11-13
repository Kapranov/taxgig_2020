defmodule Stripy.Repo.Migrations.CreateStripeCustomer do
  use Ecto.Migration

  def change do
    create table(:stripe_customers, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :id_from_stripe, :string, null: false
      add :balance, :integer, null: false, default: 0
      add :created, :integer, null: false
      add :currency, :string, null: true, default: "usd"
      add :email, :string, null: false
      add :name, :string, null: false
      add :phone, :string, null: false
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_customers, [:email], name: :stripe_customers_email_index)
    create unique_index(:stripe_customers, [:id_from_stripe], name: :stripe_customers_id_from_stripe_index)
    create unique_index(:stripe_customers, [:user_id], name: :stripe_customers_user_id_index)
  end
end

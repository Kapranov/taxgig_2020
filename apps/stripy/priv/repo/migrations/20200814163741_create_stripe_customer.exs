defmodule Stripy.Repo.Migrations.CreateStripeCustomer do
  use Ecto.Migration

  def change do
    create table(:stripe_customers, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :balance, :integer
      add :created, :integer
      add :currency, :string
      add :email, :string, null: false
      add :name, :string
      add :phone, :string
      add :source, {:array, :map}
      add :stripe_customer_id, :string, null: false
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_customers, [:stripe_customer_id], name: :stripe_customers_stripe_customer_id_index)
    create unique_index(:stripe_customers, [:user_id], name: :stripe_customers_user_id_index)
  end
end

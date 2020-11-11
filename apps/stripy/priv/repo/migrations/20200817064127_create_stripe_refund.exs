defmodule Stripy.Repo.Migrations.CreateStripeRefund do
  use Ecto.Migration

  def change do
    create table(:stripe_refunds, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :id_from_charge, :string, null: false
      add :id_from_stripe, :string, null: false
      add :amount, :integer, null: false
      add :balance_transaction, :string, null: false
      add :created, :integer, null: false
      add :currency, :string, null: false
      add :status, :string, null: false
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_refunds, [:balance_transaction], name: :stripe_refunds_balance_transaction_index)
    create unique_index(:stripe_refunds, [:id_from_stripe], name: :stripe_refunds_id_from_stripe_index)
  end
end

defmodule Stripy.Repo.Migrations.CreateStripeTransfer do
  use Ecto.Migration

  def change do
    create table(:stripe_transfers, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :id_from_stripe, :string, null: false
      add :amount, :integer, null: false
      add :amount_reversed, :integer, null: false
      add :balance_transaction, :string, null: false
      add :created, :integer, null: false
      add :currency, :string, null: false, default: "usd"
      add :destination, :string, null: false
      add :destination_payment, :string, null: false
      add :reversed, :boolean, null: false
      add :source_type, :string, null: false
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:stripe_transfers, [:user_id])
    create unique_index(:stripe_transfers, [:id_from_stripe], name: :stripe_transfers_id_from_stripe_index)
  end
end

defmodule Stripy.Repo.Migrations.CreateStripeTransferReversal do
  use Ecto.Migration

  def change do
    create table(:stripe_transfer_reversals, primary_key: false) do
      add :id_from_stripe, :string, null: false
      add :id_from_transfer, :string, null: false
      add :amount, :integer
      add :balance_transaction, :string
      add :created, :integer
      add :currency, :string
      add :destination_payment_refund, :string
      add :transfer, :string
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_transfer_reversals, [:id_from_stripe], name: :stripe_transfer_reversals_id_from_stripe_index)
  end
end

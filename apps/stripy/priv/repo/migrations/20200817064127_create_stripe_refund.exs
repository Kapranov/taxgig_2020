defmodule Stripy.Repo.Migrations.CreateStripeRefund do
  use Ecto.Migration

  def change do
    create table(:stripe_refunds, primary_key: false) do
      add :id_from_stripe, :string, null: false
      add :id_from_charge, :string, null: false
      add :amount, :integer
      add :balance_transaction, :string
      add :created, :integer
      add :currency, :string
      add :metadata, {:array, :map}
      add :payment_intent, :string
      add :reason, :string
      add :receipt_number, :string
      add :refund_application_fee, :boolean
      add :reverse_transfer, :boolean
      add :source_transfer_reversal, :string
      add :status, :string
      add :transfer_reversal, :string
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_refunds, [:id_from_charge], name: :stripe_refunds_id_from_charge_index)
    create unique_index(:stripe_refunds, [:id_from_stripe], name: :stripe_refunds_id_from_stripe_index)
  end
end

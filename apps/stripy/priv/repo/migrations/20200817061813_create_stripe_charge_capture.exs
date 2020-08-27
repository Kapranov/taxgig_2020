defmodule Stripy.Repo.Migrations.CreateStripeChargeCapture do
  use Ecto.Migration

  def change do
    create table(:stripe_charge_captures, primary_key: false) do
      add :id_from_stripe, :string, null: false
      add :id_from_charge, :string, null: false
      add :amount, :integer
      add :amount_refunded, :integer
      add :balance_transaction, :string
      add :billing_details, {:array, :map}
      add :captured, :boolean
      add :currency, :string
      add :description, :string
      add :disputed, :boolean
      add :failure_code, :string
      add :failure_message, :string
      add :invoice, :string
      add :outcome, {:array, :map}
      add :paid, :boolean
      add :payment_method, :string, null: false
      add :payment_method_details, {:array, :map}
      add :receipt_url, :string
      add :refunded, :boolean
      add :status, :string
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_charge_captures, [:id_from_charge], name: :stripe_charge_captures_id_from_charge_index)
    create unique_index(:stripe_charge_captures, [:id_from_stripe], name: :stripe_charge_captures_id_from_stripe_index)
  end
end

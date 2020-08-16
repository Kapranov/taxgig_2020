defmodule Stripy.Repo.Migrations.CreateStripeCharge do
  use Ecto.Migration

  def change do
    create table(:stripe_charges, primary_key: false) do
      add :id_from_stripe, :string, null: false
      add :amount, :integer, null: false
      add :amount_refunded, :integer
      add :application, :string
      add :application_fee, :string
      add :application_fee_amount, :integer
      add :balance_transaction, :string
      add :billing_details, {:array, :map}
      add :calculated_statement_descriptor, :string
      add :captured, :boolean
      add :card_token_id_from_stripe, :string
      add :created, :integer
      add :currency, :string, null: false
      add :customer_id, :string, null: false
      add :description, :string
      add :disputed, :boolean
      add :failure_code, :string
      add :failure_message, :string
      add :fraud_details, {:array, :map}
      add :livemode, :boolean
      add :metadata, {:array, :map}
      add :on_behalf_of, :string
      add :order, :string
      add :outcome, {:array, :map}
      add :paid, :boolean
      add :payment_method, :string
      add :payment_method_details, {:array, :map}
      add :receipt_email, :string
      add :receipt_number, :string
      add :receipt_url, :string
      add :refunded, :boolean
      add :refunds, {:array, :map}
      add :review, :string
      add :shipping, {:array, :map}
      add :source_transfer, :string
      add :statement_descriptor, :string
      add :statement_descriptor_suffix, :string
      add :status, :string
      add :transfer, :string
      add :transfer_data, {:array, :map}
      add :transfer_group, :string
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_charges, [:id_from_stripe], name: :stripe_charges_id_from_stripe_index)
  end
end

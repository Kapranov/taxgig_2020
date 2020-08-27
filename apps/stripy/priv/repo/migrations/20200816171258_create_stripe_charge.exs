defmodule Stripy.Repo.Migrations.CreateStripeCharge do
  use Ecto.Migration

  def change do
    create table(:stripe_charges, primary_key: false) do
      add :id_from_stripe, :string, null: false
      add :amount, :integer, null: false
      add :amount_refunded, :integer
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
      add :outcome, {:array, :map}
      add :paid, :boolean
      add :payment_method, :string
      add :payment_method_details, {:array, :map}
      add :receipt_url, :string
      add :refunded, :boolean
      add :status, :string
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_charges, [:id_from_stripe], name: :stripe_charges_id_from_stripe_index)
  end
end

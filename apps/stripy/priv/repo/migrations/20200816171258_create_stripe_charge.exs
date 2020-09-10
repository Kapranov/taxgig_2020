defmodule Stripy.Repo.Migrations.CreateStripeCharge do
  use Ecto.Migration

  def change do
    create table(:stripe_charges, primary_key: false) do
      add :id_from_stripe, :string, null: false
      add :amount, :integer, null: false
      add :amount_refunded, :integer
      add :captured, :boolean
      add :card_token_id_from_stripe, :string
      add :created, :integer
      add :currency, :string, null: false
      add :customer_id, :string, null: false
      add :description, :string
      add :failure_code, :string
      add :failure_message, :string
      add :fraud_details: {:array, :map}
      add :outcome, {:array, :map}
      add :receipt_url, :string
      add :source, {:array, :map}
      add :status, :string
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_charges, [:id_from_stripe], name: :stripe_charges_id_from_stripe_index)
  end
end

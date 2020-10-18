defmodule Stripy.Repo.Migrations.CreateStripeCharge do
  use Ecto.Migration

  def change do
    create table(:stripe_charges, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :id_from_card, :string, null: false
      add :id_from_customer, :string, null: false
      add :id_from_stripe, :string, null: false
      add :amount, :integer, null: false
      add :amount_refunded, :integer, null: false
      add :captured, :boolean, null: false
      add :created, :integer, null: false
      add :currency, :string, null: false
      add :description, :string, null: false
      add :failure_code, :string, null: true
      add :failure_message, :string, null: true
      add :fraud_details, :map, null: false, default: %{}
      add :outcome, :map, null: false
      add :receipt_url, :string, null: false
      add :status, :string, null: false
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:stripe_charges, [:user_id])
    create unique_index(:stripe_charges, [:id_from_stripe], name: :stripe_charges_id_from_stripe_index)
  end
end

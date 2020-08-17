defmodule Stripy.Repo.Migrations.CreateStripeChargeCapture do
  use Ecto.Migration

  def change do
    create table(:stripe_charge_captures, primary_key: false) do
      add :id_from_stripe, :string, null: false
      add :id_from_charge, :string, null: false
      add :amount, :integer
      add :application_fee_amount, :integer
      add :receipt_email, :string
      add :statement_descriptor, :string
      add :statement_descriptor_suffix, :string
      add :transfer_data, {:array, :map}
      add :transfer_group, :string
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_charge_captures, [:id_from_stripe], name: :stripe_charge_captures_id_from_stripe_index)
    create unique_index(:stripe_charge_captures, [:id_from_charge], name: :stripe_charge_captures_id_from_charge_index)
  end
end

defmodule Stripy.Repo.Migrations.CreateStripeTransfer do
  use Ecto.Migration

  def change do
    create table(:stripe_transfers, primary_key: false) do
      add :id_from_stripe, :string, null: false
      add :account_id_from_stripe, :string, null: false
      add :amount, :integer, null: false
      add :amount_reversed, :integer
      add :balance_transaction, :string
      add :created, :integer
      add :currency, :string, null: false
      add :description, :string
      add :destination, :string, null: false
      add :destination_payment, :string
      add :livemode, :boolean
      add :metadata, {:array, :map}
      add :reversals, {:array, :map}
      add :reversed, :boolean
      add :source_transaction, :string
      add :source_type, :string
      add :transfer_group, :string
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_transfers, [:id_from_stripe], name: :stripe_transfers_id_from_stripe_index)
  end
end

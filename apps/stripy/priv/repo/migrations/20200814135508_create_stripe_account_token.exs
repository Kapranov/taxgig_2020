defmodule Stripy.Repo.Migrations.CreateStripeAccountToken do
  use Ecto.Migration

  def change do
    create table(:stripe_account_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :id_from_stripe, :string, null: false
      add :client_ip, :string, null: false
      add :created, :integer, null: false
      add :used, :boolean, null: false
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:stripe_account_tokens, [:user_id])
    create unique_index(:stripe_account_tokens, [:id_from_stripe], name: :stripe_account_tokens_id_from_stripe_index)
  end
end

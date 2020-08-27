defmodule Stripy.Repo.Migrations.CreateStripeCardToken do
  use Ecto.Migration

  def change do
    create table(:stripe_card_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :brand, :string, null: false
      add :card_account, :string, null: false
      add :card_token, :string, null: false
      add :client_ip, :string, null: false
      add :created, :integer, null: false
      add :cvc_check, :string, null: false
      add :exp_month, :integer, null: false
      add :exp_year, :integer, null: false
      add :fingerprint, :string, null: false
      add :funding, :string, null: false
      add :last4, :string, null: false
      add :name, :string
      add :used, :boolean, null: false
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_card_tokens, [:card_token], name: :stripe_card_tokens_card_token_index)
  end
end

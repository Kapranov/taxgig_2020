defmodule Stripy.Repo.Migrations.CreateStripeAccountToken do
  use Ecto.Migration

  def change do
    create table(:stripe_account_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :account_token, :string, null: false
      add :used, :boolean, null: false
      add :created, :integer, null: false
      add :user_id, :uuid, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:stripe_account_tokens, [:account_token], name: :stripe_account_tokens_account_token_index)
  end
end

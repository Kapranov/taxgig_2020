defmodule Core.Repo.Migrations.CreateIndividualForeignAccountCounts do
  use Ecto.Migration

  def change do
    create table(:individual_foreign_account_counts, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :individual_tax_return_id, references(:individual_tax_returns, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :name, :string, default: nil, null: true

      timestamps(type: :utc_datetime_usec)
    end

    create index(:individual_foreign_account_counts, [:individual_tax_return_id])
  end
end

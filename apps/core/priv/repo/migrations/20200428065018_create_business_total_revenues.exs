defmodule Core.Repo.Migrations.CreateBusinessTotalRevenues do
  use Ecto.Migration

  def change do
    create table(:business_total_revenues, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :business_tax_return_id, references(:business_tax_returns, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :name, :string, default: nil, null: true
      add :price, :integer, default: nil, null: true

      timestamps(type: :utc_datetime_usec)
    end

    create index(:business_total_revenues, [:business_tax_return_id])
  end
end

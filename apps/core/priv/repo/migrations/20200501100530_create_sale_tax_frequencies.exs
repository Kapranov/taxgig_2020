defmodule Core.Repo.Migrations.CreateSaleTaxFrequencies do
  use Ecto.Migration

  def change do
    create table(:sale_tax_frequencies, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :name, :string, default: nil, null: true
      add :price, :integer, default: nil, null: true
      add :sale_tax_id, references(:sale_taxes, type: :uuid, on_delete: :delete_all), null: false, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:sale_tax_frequencies, [:sale_tax_id])
  end
end

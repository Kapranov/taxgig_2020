defmodule Core.Repo.Migrations.CreateServiceLinks do
  use Ecto.Migration

  def change do
    create table(:service_links, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :book_keeping_id, references(:book_keepings, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :business_tax_return_id, references(:business_tax_returns, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :individual_tax_return_id, references(:individual_tax_returns, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :sale_tax_id, references(:sale_taxes, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :project_id, references(:projects, type: :uuid, on_delete: :delete_all), null: true, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end
  end
end

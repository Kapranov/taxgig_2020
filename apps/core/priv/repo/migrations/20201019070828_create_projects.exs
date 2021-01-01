defmodule Core.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :addon_price, :integer, null: true
      add :assigned_id, references(:users, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :book_keeping_id, references(:book_keepings, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :business_tax_return_id, references(:business_tax_returns, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :end_time, :date, null: true
      add :id_from_stripe_card, :string, null: true
      add :id_from_stripe_transfer, :string, null: true
      add :individual_tax_return_id, references(:individual_tax_returns, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :instant_matched, :boolean, null: false
      add :offer_price, :decimal, null: true
      add :sale_tax_id, references(:sale_taxes, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :service_review_id, references(:service_reviews, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :status, :string, null: false
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: true, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:projects, [:book_keeping_id])
    create index(:projects, [:business_tax_return_id])
    create index(:projects, [:id_from_stripe_card])
    create index(:projects, [:id_from_stripe_transfer])
    create index(:projects, [:individual_tax_return_id])
    create index(:projects, [:sale_tax_id])
    create index(:projects, [:service_review_id])
    create index(:projects, [:user_id])
    create(unique_index(:projects, [:book_keeping_id], name: :book_keeping_id_unique_index))
    create(unique_index(:projects, [:business_tax_return_id], name: :business_tax_return_id_unique_index))
    create(unique_index(:projects, [:individual_tax_return_id], name: :individual_tax_return_id_unique_index))
    create(unique_index(:projects, [:sale_tax_id], name: :sale_tax_id_unique_index))
    create(unique_index(:projects, [:service_review_id], name: :service_review_id_unique_index))
  end
end

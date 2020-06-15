defmodule Core.Repo.Migrations.CreateIndividualTaxReturns do
  use Ecto.Migration

  def change do
    create table(:individual_tax_returns, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :active, :boolean, default: true, null: false
      add :deadline, :utc_datetime_usec, default: nil, null: true
      add :foreign_account, :boolean, default: nil, null: true
      add :foreign_account_limit, :boolean, default: nil, null: true
      add :foreign_financial_interest, :boolean, default: nil, null: true
      add :home_owner, :boolean, default: nil, null: true
      add :k1_count, :integer, default: nil, null: true
      add :k1_income, :boolean, default: nil, null: true
      add :living_abroad, :boolean, default: nil, null: true
      add :non_resident_earning, :boolean, default: nil, null: true
      add :none_expat, :boolean, default: nil, null: true
      add :own_stock_crypto, :boolean, default: nil, null: true
      add :price_foreign_account, :integer, default: nil, null: true
      add :price_home_owner, :integer, default: nil, null: true
      add :price_living_abroad, :integer, default: nil, null: true
      add :price_non_resident_earning, :integer, default: nil, null: true
      add :price_own_stock_crypto, :integer, default: nil, null: true
      add :price_rental_property_income, :integer, default: nil, null: true
      add :price_sole_proprietorship_count, :integer, default: nil, null: true
      add :price_state, :integer, default: nil, null: true
      add :price_stock_divident, :integer, default: nil, null: true
      add :price_tax_year, :integer, default: nil, null: true
      add :rental_property_count, :integer, default: nil, null: true
      add :rental_property_income, :boolean, default: nil, null: true
      add :sole_proprietorship_count, :integer, default: nil, null: true
      add :state, {:array, :string}, default: nil, null: true
      add :stock_divident, :boolean, default: nil, null: true
      add :tax_year, {:array, :string}, default: nil, null: true
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:individual_tax_returns, [:user_id])
  end
end

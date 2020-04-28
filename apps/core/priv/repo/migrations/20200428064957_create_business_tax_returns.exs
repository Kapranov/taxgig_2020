defmodule Core.Repo.Migrations.CreateBusinessTaxReturns do
  use Ecto.Migration

  def change do
    create table(:business_tax_returns, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :accounting_software, :boolean, default: nil, null: true
      add :capital_asset_sale, :boolean, default: nil, null: true
      add :church_hospital, :boolean, default: nil, null: true
      add :dispose_asset, :boolean, default: nil, null: true
      add :dispose_property, :boolean, default: nil, null: true
      add :educational_facility, :boolean, default: nil, null: true
      add :financial_situation, :text, default: nil, null: true
      add :foreign_account_interest, :boolean, default: nil, null: true
      add :foreign_account_value_more, :boolean, default: nil, null: true
      add :foreign_entity_interest, :boolean, default: nil, null: true
      add :foreign_partner_count, :integer, default: nil, null: true
      add :foreign_shareholder, :boolean, default: nil, null: true
      add :foreign_value, :boolean, default: nil, null: true
      add :fundraising_over, :boolean, default: nil, null: true
      add :has_contribution, :boolean, default: nil, null: true
      add :has_loan, :boolean, default: nil, null: true
      add :income_over_thousand, :boolean, default: nil, null: true
      add :invest_research, :boolean, default: nil, null: true
      add :k1_count, :integer, default: nil, null: true
      add :lobbying, :boolean, default: nil, null: true
      add :make_distribution, :boolean, default: nil, null: true
      add :none_expat, :boolean, default: nil, null: true
      add :operate_facility, :boolean, default: nil, null: true
      add :price_state, :integer, default: nil, null: true
      add :price_tax_year, :integer, default: nil, null: true
      add :property_sale, :boolean, default: nil, null: true
      add :public_charity, :boolean, default: nil, null: true
      add :rental_property_count, :integer, default: nil, null: true
      add :reported_grant, :boolean, default: nil, null: true
      add :restricted_donation, :boolean, default: nil, null: true
      add :state, {:array, :string}, default: nil, null: true
      add :tax_exemption, :boolean, default: nil, null: true
      add :tax_year, {:array, :string}, default: nil, null: true
      add :total_asset_less, :boolean, default: nil, null: true
      add :total_asset_over, :boolean, default: nil, null: true
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:business_tax_returns, [:user_id])
  end
end

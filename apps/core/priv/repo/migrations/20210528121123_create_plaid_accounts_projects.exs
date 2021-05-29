defmodule Core.Repo.Migrations.CreatePlaidAccountsProjects do
  use Ecto.Migration

  def change do
    create table(:plaid_accounts_projects, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :plaid_account_id, references(:plaid_accounts, type: :uuid, on_delete: :delete_all, on_replace: :delete), null: true, primary_key: false
      add :project_id, references(:projects, type: :uuid, on_delete: :delete_all, on_replace: :delete), null: true, primary_key: false
    end

    create index(:plaid_accounts_projects, [:plaid_account_id])
    create index(:plaid_accounts_projects, [:project_id])
    create(unique_index(:plaid_accounts_projects, [:plaid_account_id, :project_id], name: :plaid_account_id_project_id_unique_index))
  end
end

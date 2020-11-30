defmodule Core.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :addon_id, references(:addons, type: :uuid, on_delete: :nilify_all), null: true, primary_key: false
      add :assigned_pro, :uuid, type: FlakeId.Ecto.Type, null: true
      add :end_time, :date, null: true
      add :id_from_stripe_card, :string, null: true
      add :id_from_stripe_transfer, :string, null: true
      add :instant_matched, :boolean, null: false
      add :offer_id, references(:offers, type: :uuid, on_delete: :nilify_all), null: true, primary_key: false
      add :project_price, :integer, null: true
      add :status, :string, null: false
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:projects, [:addon_id])
    create index(:projects, [:id_from_stripe_card])
    create index(:projects, [:id_from_stripe_transfer])
    create index(:projects, [:offer_id])
    create index(:projects, [:user_id])
  end
end

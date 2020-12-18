defmodule Core.Repo.Migrations.CreateBanReasons do
  use Ecto.Migration

  def change do
    create table(:ban_reasons, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :description, :string, null: true
      add :other, :boolean, null: false
      add :platform_id, references(:platforms, type: :uuid, on_delete: :nilify_all), null: true, primary_key: false
      add :reasons, :string, null: true, default: nil
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: true, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:ban_reasons, [:user_id])
    create(unique_index(:ban_reasons, [:platform_id], name: :ban_reasons_platform_id_index))
  end
end

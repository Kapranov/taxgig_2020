defmodule Core.Repo.Migrations.CreateBanReasons do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:ban_reasons, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :description, :string, null: true
      add :other, :boolean, null: false
      add :reasons, :string, null: true, default: nil

      timestamps(type: :utc_datetime_usec)
    end
  end
end

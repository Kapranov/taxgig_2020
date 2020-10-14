defmodule Core.Repo.Migrations.CreateBanReasons do
  use Ecto.Migration

  def change do
    create table(:ban_reasons, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :reasons, :string, default: nil, null: true
      add :other, :boolean
      add :other_description, :string

      timestamps(type: :utc_datetime_usec)
    end
  end
end

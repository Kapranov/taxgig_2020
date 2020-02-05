defmodule Ptin.Repo.Migrations.CreateExpires do
  use Ecto.Migration

  def change do
    create table(:expires, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :expired, :string, null: false
      add :url, :string, null: false
    end
  end
end

defmodule Core.Repo.Migrations.CreateStates do
  use Ecto.Migration

  def change do
    create table(:states, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :abbr, :string
      add :name, :string
    end
  end
end

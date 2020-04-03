defmodule Ptin.Repo.Migrations.CreatePtins do
  use Ecto.Migration

  def change do
    create table(:ptins, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :bus_addr_zip, :string, null: false
      add :bus_st_code, :string, null: false
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :profession, :string, null: true
    end
  end
end

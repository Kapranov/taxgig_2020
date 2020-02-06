defmodule Core.Repo.Migrations.CreateUsZipcodes do
  use Ecto.Migration

  def change do
    create table(:us_zipcodes, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :city, :string, null: false
      add :state, :string, null: false
      add :zipcode, :integer, null: false
    end
  end
end

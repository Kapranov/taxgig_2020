defmodule Core.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :active, :boolean
      add :admin, :boolean, default: false, null: false
      add :avatar, :string
      add :bio, :string
      add :birthday, :date
      add :email, :string, null: false
      add :first_name, :string
      add :init_setup, :boolean
      add :last_name, :string
      add :middle_name, :string
      add :password_hash, :string, null: false
      add :phone, :string
      add :role, :boolean
      add :provider, :string, default: "localhost", null: false
      add :sex, :string
      add :ssn, :integer
      add :street, :string
      add :zip, :integer

      timestamps(type: :utc_datetime_usec)
    end

    create(unique_index(:users, [:email]))
  end
end

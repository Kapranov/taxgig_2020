defmodule Core.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :active, :boolean, default: false, null: false
      add :admin, :boolean, default: false, null: false
      add :avatar, :string, null: true
      add :bio, :text, null: true
      add :birthday, :date, null: true
      add :bus_addr_zip, :string, null: false, default: ""
      add :email, :string, null: false
      add :first_name, :string, null: true
      add :init_setup, :boolean, null: true
      add :is2fa, :boolean, null: false, default: false
      add :last_name, :string, null: true
      add :middle_name, :string, null: true
      add :otp_last, :integer, null: false, default: 0
      add :otp_secret, :string, null: false
      add :password_hash, :string, null: false
      add :phone, :string, null: true
      add :profession, :string, null: true
      add :provider, :string, default: "localhost", null: false
      add :role, :boolean, default: false, null: false
      add :sex, :string, null: true
      add :street, :string, null: true
      add :zip, :integer, null: true

      timestamps(type: :utc_datetime_usec)
    end

    create(unique_index(:users, [:email]))
  end
end

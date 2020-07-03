defmodule Core.Repo.Migrations.CreateAccountingSoftwares do
  use Ecto.Migration

  def change do
    create table(:accounting_softwares, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :name, {:array, :string}, default: nil, null: true
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end

    create(unique_index(:accounting_softwares, [:user_id], name: :accounting_softwares_user_id_index))
  end
end

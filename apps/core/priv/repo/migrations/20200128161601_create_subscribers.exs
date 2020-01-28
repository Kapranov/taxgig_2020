defmodule Core.Repo.Migrations.CreateSubscribers do
  use Ecto.Migration

  def change do
    create table(:subscribers, primary_key: false) do
      add :id, :uuid, primary_key: true,
        default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :email, :string
      add :pro_role, :boolean

      timestamps(type: :utc_datetime_usec)
    end

    create(unique_index(:subscribers, [:email]))
  end
end

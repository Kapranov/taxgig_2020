defmodule Core.Skills.AccountingSoftware do
  @moduledoc """
  Schema for AccountingSoftware.
  """

  use Core.Model

  alias Core.Repo
  alias Core.Accounts.User
  alias Core.Skills.Helpers.AccountingSoftwareNameEnum

  @type t :: %__MODULE__{
    name: tuple,
    user_id: User.t()
  }

  @allowed_params ~w(
    name
    user_id
  )a

  @required_params ~w(
    name
    user_id
  )a

  schema "accounting_softwares" do
    field :name, {:array, AccountingSoftwareNameEnum}

    belongs_to :users, User,
      foreign_key: :user_id, type: FlakeId.Ecto.CompatType, references: :id

    timestamps()
  end

  @doc """
  Create changeset for AccountingSoftware.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:user_id, name: :accounting_softwares_user_id_index)
  end

  @doc """
  List all and sorted.
  """
  def all do
    Repo.all(from row in @name, order_by: [desc: row.id])
  end
end

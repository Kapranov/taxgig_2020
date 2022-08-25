defmodule Core.Contracts.PotentialClient do
  @moduledoc """
  Schema for PotentialClient.
  """

  use Core.Model

  alias Core.Accounts.User

  @type t :: %__MODULE__{
    project: tuple,
    user_id: User.t()
  }

  @allowed_params ~w(
    project
    user_id
  )a

  @required_params ~w(user_id)a

  schema "potential_clients" do
    field :project, {:array, :string}, default: []

    belongs_to :user, User,
      foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    timestamps()
  end

  @doc """
  Create changeset for PotentialClient.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:user_id, name: :user_id_unique_index)
  end
end

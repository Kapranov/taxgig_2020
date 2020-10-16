defmodule Core.Accounts.DeletedUser do
  @moduledoc """
  Schema for DeletedUser.
  """

  use Core.Model

  alias Core.Accounts.{
    Helpers.DeletedUserEnum,
    User
  }

  @type t :: %__MODULE__{
    reason: String.t(),
    user_id: User.t()
  }

  @allowed_params ~w(
    reason
    user_id
  )a

  @required_params ~w(
    reason
    user_id
  )a

  schema "deleted_users" do
    field :reason, DeletedUserEnum, null: false

    belongs_to :user, User,
      foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    timestamps()
  end

  @doc """
  Create changeset for DeletedUser.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:user, name: :deleted_users_user_id_index, message: "Only one an User")
  end
end

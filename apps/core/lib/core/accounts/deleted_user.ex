defmodule Core.Accounts.DeletedUser do
  @moduledoc """
  Schema for DeletedUser.
  """

  use Core.Model

  alias Core.Accounts.Helpers.DeletedUserEnum

  @type t :: %__MODULE__{
    reason: String.t(),
    user_id: String.t()
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
    field :user_id, FlakeId.Ecto.Type, null: false

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
  end
end

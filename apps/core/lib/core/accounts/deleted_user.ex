defmodule Core.Accounts.DeletedUser do
  @moduledoc """
  Schema for DeletedUser.
  """

  use Core.Model

  alias Core.Accounts.Helpers.DeletedUserEnum

  @type t :: %__MODULE__{
    email: String.t(),
    reason: String.t(),
    role: boolean,
    user_id: String.t()
  }

  @allowed_params ~w(
    email
    reason
    role
    user_id
  )a

  @required_params ~w(
    email
    reason
    role
    user_id
  )a

  schema "deleted_users" do
    field :email, :string, null: false
    field :reason, DeletedUserEnum, null: false
    field :role, :boolean, null: false
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
    |> foreign_key_constraint(:email, message: "Select an Email")
    |> unique_constraint(:email, name: :deleted_users_email_index, message: "Only one an Email")
  end
end

defmodule Core.Talk.Message do
  @moduledoc """
  Schema for Messages.
  """

  use Core.Model

  alias Core.Accounts.User
  alias Core.Talk.Room

  @type t :: %__MODULE__{
    body: String.t(),
    room: Room.t(),
    user: User.t()
  }

  @allowed_params ~w(
    body
  )a

  @required_params ~w(
    body
  )a

  schema "messages" do
    field :body, :string

    belongs_to :room, Room,
      foreign_key: :room_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    belongs_to :user, User,
      foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    timestamps()
  end

  @doc """
  Create changeset for Messages.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:room_id, message: "Select a room")
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:room_id, name: :messages_room_id_index)
    |> unique_constraint(:user_id, name: :messages_user_id_index)
  end
end

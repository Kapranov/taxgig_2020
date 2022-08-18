defmodule Core.Talk.Message do
  @moduledoc """
  Schema for Messages.
  """

  use Core.Model

  alias Core.{
    Accounts.User,
    Talk.Room
  }

  @type t :: %__MODULE__{
    body: String.t(),
    is_read: boolean,
    recipient_id: User.t(),
    room_id: Room.t(),
    user_id: User.t(),
    warning: boolean
  }

  @allowed_params ~w(
    body
    is_read
    recipient_id
    room_id
    user_id
    warning
  )a

  @required_params ~w(
    body
    is_read
    recipient_id
    room_id
    user_id
    warning
  )a

  schema "messages" do
    field :body, :string, null: false
    field :is_read, :boolean, null: false
    field :warning, :boolean, null: false

    belongs_to :room, Room,
      foreign_key: :room_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    belongs_to :recipient, User,
      foreign_key: :recipient_id,
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
    |> foreign_key_constraint(:recipient_id, message: "Select Recipients")
    |> foreign_key_constraint(:room_id, message: "Select a Room")
    |> foreign_key_constraint(:user_id, message: "Select an User")
  end
end

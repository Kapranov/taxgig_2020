defmodule Core.Talk.Message do
  @moduledoc """
  Schema for Messages.
  """

  use Core.Model

  alias Core.{
    Accounts.User,
    Contracts.Project,
    Talk.Room
  }

  @type t :: %__MODULE__{
    body: String.t(),
    is_read: boolean,
    project_id: Project.t(),
    recipient: String.t(),
    room_id: Room.t(),
    user_id: User.t(),
    warning: boolean
  }

  @allowed_params ~w(
    body
    is_read
    project_id
    recipient
    room_id
    user_id
    warning
  )a

  @required_params ~w(
    body
    is_read
    project_id
    recipient
    room_id
    user_id
    warning
  )a

  schema "messages" do
    field :body, :string, null: false
    field :is_read, :boolean, null: false
    field :recipient, FlakeId.Ecto.Type, null: true
    field :warning, :boolean, null: false

    belongs_to :projects, Project,
      foreign_key: :project_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

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
    |> foreign_key_constraint(:project_id, message: "Select a Project")
    |> foreign_key_constraint(:room_id, message: "Select a Room")
    |> foreign_key_constraint(:user_id, message: "Select an User")
  end
end

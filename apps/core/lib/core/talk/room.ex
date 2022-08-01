defmodule Core.Talk.Room do
  @moduledoc """
  Schema for Faqs.
  """

  use Core.Model

  alias Core.{
    Accounts.User,
    Contracts.Project,
    Talk.Message
  }

  @type t :: %__MODULE__{
    active: boolean,
    description: String.t(),
    last_msg: String.t(),
    messages: [Message.t()],
    name: String.t(),
    project_id: Project.t(),
    topic: String.t(),
    unread_msg: integer,
    user: User.t()
  }

  @allowed_params ~w(
    active
    description
    last_msg
    name
    project_id
    topic
    unread_msg
    user_id
  )a

  @required_params ~w(
    active
    name
    project_id
    user_id
  )a

  schema "rooms" do
    field :active, :boolean, null: false, default: false
    field :description, :string, null: true
    field :last_msg, :string, null: true
    field :name, :string, null: false
    field :topic, :string, null: true
    field :unread_msg, :integer, null: true

    belongs_to :projects, Project,
      foreign_key: :project_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    belongs_to :user, User,
      foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    has_many :messages, Message

    timestamps()
  end

  @doc """
  Create changeset for Room.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> validate_length(:name, min: 1, max: 30)
    |> validate_length(:topic, min: 1, max: 120)
    |> foreign_key_constraint(:name, message: "Only a single unique names")
    |> foreign_key_constraint(:project_id, message: "Select a Project")
    |> foreign_key_constraint(:user_id, message: "Select an User")
  end
end

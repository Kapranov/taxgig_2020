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
    participant_id: User.t(),
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
    participant_id
    project_id
    topic
    unread_msg
    user_id
  )a

  @required_params ~w(
    active
    name
    participant_id
    project_id
    user_id
  )a

  @required_updated_params ~w(active)a

  schema "rooms" do
    field :active, :boolean, null: false, default: false
    field :description, :string, null: true
    field :last_msg, :string, null: true
    field :name, :string, null: false
    field :topic, :string, null: true
    field :unread_msg, :integer, null: true

    belongs_to :participant, User,
      foreign_key: :participant_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

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
  end

  @doc """
  Updated changeset for Room.
  """
  @spec updated_changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def updated_changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_updated_params)
    |> validate_length(:name, min: 1, max: 30)
    |> validate_length(:topic, min: 1, max: 120)
  end
end

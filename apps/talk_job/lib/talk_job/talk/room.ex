defmodule TalkJob.Talk.Room do
  @moduledoc """
  Schema for Faqs.
  """

  use TalkJob.Model

  @type t :: %__MODULE__{
    active: boolean,
    description: String.t(),
    last_msg: String.t(),
    name: String.t(),
    participant_id: FlakeId.Ecto.CompatType.t(),
    project_id: FlakeId.Ecto.CompatType.t(),
    topic: String.t(),
    unread_msg: integer,
    user_id: FlakeId.Ecto.CompatType.t()
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
    field :active, :boolean, default: false
    field :description, :string
    field :last_msg, :string
    field :name, :string
    field :topic, :string
    field :unread_msg, :integer
    field :participant_id, FlakeId.Ecto.CompatType
    field :project_id, FlakeId.Ecto.CompatType
    field :user_id, FlakeId.Ecto.CompatType

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

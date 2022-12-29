defmodule TalkJob.Talk.Message do
  @moduledoc """
  Schema for Messages.
  """

  use TalkJob.Model

  @type t :: %__MODULE__{
    body: String.t(),
    is_read: boolean,
    recipient_id: FlakeId.Ecto.CompatType.t(),
    room_id: FlakeId.Ecto.CompatType.t(),
    user_id: FlakeId.Ecto.CompatType.t(),
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


  @required_updated_params ~w(
    body
    is_read
    warning
  )a

  schema "messages" do
    field :body, :string
    field :is_read, :boolean
    field :warning, :boolean
    field :room_id, FlakeId.Ecto.CompatType
    field :recipient_id, FlakeId.Ecto.CompatType
    field :user_id, FlakeId.Ecto.CompatType

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

  @doc """
  Updated changeset for Messages.
  """
  @spec updated_changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def updated_changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_updated_params)
    |> foreign_key_constraint(:recipient_id, message: "Select Recipients")
    |> foreign_key_constraint(:room_id, message: "Select a Room")
    |> foreign_key_constraint(:user_id, message: "Select an User")
  end
end

defmodule Core.Talk.Room do
  @moduledoc """
  Schema for Faqs.
  """

  use Core.Model

  alias Core.Accounts.User
  alias Core.Talk.Message

  @type t :: %__MODULE__{
    description: String.t(),
    messages: [Message.t()],
    name: String.t(),
    topic: String.t(),
    user: User.t()
  }

  @allowed_params ~w(
    description
    name
    topic
  )a

  @required_params ~w(
    name
  )a

  schema "rooms" do
    field :description, :string
    field :name, :string
    field :topic, :string

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
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:name)
    |> unique_constraint(:user_id, name: :rooms_user_id_index)
  end
end

defmodule Core.Notifications.Notify do
  @moduledoc """
  Schema for Notify.
  """

  use Core.Model

  alias Core.{
    Accounts.User,
    Contracts.Project,
    Contracts.ServiceReview,
    Talk.Room
  }

  @type t :: %__MODULE__{
    is_hidden: :boolean,
    is_read: :boolean,
    project_id: Project.t(),
    room_id: Room.t(),
    sender_id: User.t(),
    service_review_id: ServiceReview.t(),
    template: :integer,
    user_id: User.t()
  }

  @allowed_params ~w(
    is_hidden
    is_read
    project_id
    room_id
    sender_id
    service_review_id
    template
    user_id
  )a

  @required_params ~w(
    template
    user_id
  )a

  schema "notifies" do
    field :is_hidden, :boolean
    field :is_read, :boolean
    field :template, :integer

    belongs_to :projects, Project,
      foreign_key: :project_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    belongs_to :rooms, Room,
      foreign_key: :room_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    belongs_to :service_reviews, ServiceReview,
      foreign_key: :service_review_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    belongs_to :sender, User,
      foreign_key: :sender_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    belongs_to :users, User,
      foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    timestamps(type: :utc_datetime_usec)
  end

  @doc """
  Create changeset for Notify.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:sender_id, message: "Select an User's")
    |> foreign_key_constraint(:room_id, message: "Select the Room")
    |> foreign_key_constraint(:project_id, message: "Select the Project")
    |> foreign_key_constraint(:service_review_id, message: "Select the ServiceReview")
    |> foreign_key_constraint(:user_id, message: "Select an User")
  end
end

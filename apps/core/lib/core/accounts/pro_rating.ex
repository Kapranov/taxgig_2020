defmodule Core.Accounts.ProRating do
  @moduledoc """
  Schema for ProRating.
  """

  use Core.Model

  alias Core.Accounts.User

  @type t :: %__MODULE__{
    average_communication: integer,
    average_professionalism: integer,
    average_rating: integer,
    average_work_quality: integer,
    user_id: User.t()
  }

  @allowed_params ~w(
    average_communication
    average_professionalism
    average_rating
    average_work_quality
    user_id
  )a

  @required_params ~w(
    average_communication
    average_professionalism
    average_rating
    average_work_quality
    user_id
  )a

  schema "pro_ratings" do
    field :average_communication, :decimal, null: false
    field :average_professionalism, :decimal, null: false
    field :average_rating, :decimal, null: false
    field :average_work_quality, :decimal, null: false

    belongs_to :user, User,
      foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    timestamps()
  end

  @doc """
  Create changeset for ProRating.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:user, name: :pro_ratings_user_id_index, message: "Only one an User")
  end
end

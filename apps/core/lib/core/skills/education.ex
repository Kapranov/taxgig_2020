defmodule Core.Skills.Education do
  @moduledoc """
  Schema for Education.
  """

  use Core.Model

  alias Core.Repo
  alias Core.Accounts.User
  alias Core.Skills.University

  @type t :: %__MODULE__{
    course: String.t(),
    graduation: String.t(),
    university_id: University.t(),
    user_id: User.t()
  }

  @allowed_params ~w(
    course
    graduation
    university_id
    user_id
  )a

  @required_params ~w(
    course
    graduation
    university_id
    user_id
  )a

  schema "educations" do
    field :course, :string
    field :graduation, :date

    belongs_to :university, University,
      foreign_key: :university_id, type: FlakeId.Ecto.CompatType, references: :id
    belongs_to :users, User,
      foreign_key: :user_id, type: FlakeId.Ecto.CompatType, references: :id

    timestamps()
  end

  @doc """
  Create changeset for Education.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:university_id, message: "Select an University")
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:university_id, name: :universities_user_id_index)
    |> unique_constraint(:user_id, name: :accounting_softwares_user_id_index)
  end

  @doc """
  List all and sorted.
  """
  def all do
    Repo.all(from row in @name, order_by: [desc: row.id])
  end
end

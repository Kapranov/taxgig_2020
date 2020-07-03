defmodule Core.Skills.WorkExperience do
  @moduledoc """
  Schema for WorkExperience.
  """

  use Core.Model

  alias Core.Repo
  alias Core.Accounts.User

  @type t :: %__MODULE__{
    end_date: DateTime.t(),
    name: String.t(),
    start_date: DateTime.t(),
    user_id: User.t()
  }

  @allowed_params ~w(
    end_date
    name
    start_date
    user_id
  )a

  @required_params ~w(
    end_date
    name
    start_date
    user_id
  )a

  schema "work_experiences" do
    field :end_date, :date
    field :name, :string
    field :start_date, :date

    belongs_to :user, User,
      foreign_key: :user_id, type: FlakeId.Ecto.CompatType, references: :id

    timestamps()
  end

  @doc """
  Create changeset for WorkExperience.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:user_id, name: :accounting_softwares_user_id_index)
  end

  @doc """
  List all and sorted.
  """
  def all do
    Repo.all(from row in @name, order_by: [desc: row.id])
  end
end

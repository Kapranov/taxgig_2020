defmodule Core.Skills.University do
  @moduledoc """
  Schema for University.
  """

  use Core.Model

  alias Core.Repo
  alias Core.Skills.Education

  @type t :: %__MODULE__{
    educations: [Education.t()],
    name: String.t()
  }

  @allowed_params ~w(
    name
  )a

  @required_params ~w(
    name
  )a

  schema "universities" do
    field :name, :string

    has_many :educations, Education, on_delete: :nothing
  end

  @doc """
  Create changeset for University.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:name)
  end

  @doc """
  List all and sorted.
  """
  def all do
    Repo.all(from row in @name, order_by: [desc: row.id])
  end
end

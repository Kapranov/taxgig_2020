defmodule Core.Landing.Vacancy do
  @moduledoc """
  Schema for Vacancies.
  """

  use Core.Model

  @type t :: %__MODULE__{
    content: String.t(),
    department: String.t(),
    title: String.t()
  }

  @allowed_params ~w(
    content
    department
    title
  )a

  @required_params ~w(
    content
    department
    title
  )a

  schema "vacancies" do
    field :content, :string
    field :department, :string
    field :title, :string

    timestamps()
  end

  @doc """
  Create changeset for Vacancy.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end

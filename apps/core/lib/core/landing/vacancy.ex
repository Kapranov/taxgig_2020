defmodule Core.Landing.Vacancy do
  @moduledoc """
  Schema for Vacancies.
  """

  use Core.Model

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
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end

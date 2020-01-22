defmodule Core.Landing.Vacancy do
  @moduledoc """
  Schema for Vacancies.
  """

  use Core.Model

  @allowed_params ~w(
    title
    content
    department
  )

  @required_params ~w(
    title
    content
    department
  )

  schema "vacancies" do
    field :title, :string
    field :content, :string
    field :department, :string

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

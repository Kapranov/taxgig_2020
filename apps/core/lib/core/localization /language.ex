defmodule Core.Localization.Language do
  @moduledoc """
  Schema for Language.
  """

  use Core.Model

  @allowed_params ~w(
    abbr
    name
  )a

  @required_params ~w(
    abbr
    name
  )a

  schema "languages" do
    field :abbr, :string
    field :name, :string

    timestamps()
  end

  @doc """
  Create changeset for Language.
  """
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:name)
  end
end

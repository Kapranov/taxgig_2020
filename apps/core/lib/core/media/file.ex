defmodule Core.Media.File do
  @moduledoc """
  Represents a file entity.
  """

  use Core.Model

  import Ecto.Changeset, only: [
    cast: 3,
    validate_required: 2
  ]

  @type t :: %__MODULE__{
    content_type: String.t(),
    name: String.t(),
    size: integer,
    url: String.t()
  }

  @required_attrs [:name, :url]
  @optional_attrs [:content_type, :size]
  @attrs @required_attrs ++ @optional_attrs

  embedded_schema do
    field(:content_type, :string)
    field(:name, :string)
    field(:size, :integer)
    field(:url, :string)

    timestamps()
  end

  @doc """
  Create changeset for File.
  """
  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = file, attrs) do
    file
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
  end
end

defmodule Core.Media.TpDoc do
  @moduledoc """
  Represents a tp document entity.
  """

  use Core.Model

  import Ecto.Changeset, only: [
    cast: 3,
    cast_embed: 2,
    validate_required: 2,
    foreign_key_constraint: 3
  ]

  alias Core.{
    Contracts.Project,
    Media.File,
    Media.Helpers.CategoryEnum
  }

  @type t :: %__MODULE__{
    access_granted: boolean,
    category: String.t(),
    file: File.t(),
    project_id: Project.t(),
    signed_by_tp: boolean
  }

  @allowed_params ~w(
    access_granted
    category
    project_id
    signed_by_tp
  )a

  @required_params ~w(
    access_granted
    category
    project_id
    signed_by_tp
  )a

  schema "tp_docs" do
    field :access_granted, :boolean, null: false
    field :category, CategoryEnum, null: false
    field :signed_by_tp, :boolean, null: false

    embeds_one(:file, File, on_replace: :update)

    belongs_to :projects, Project,
      foreign_key: :project_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    timestamps()
  end

  @doc """
  Create changeset for Tp Document.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> cast_embed(:file)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:project_id, name: :tp_docs_project_id_fkey, message: "Select the Project")
  end
end

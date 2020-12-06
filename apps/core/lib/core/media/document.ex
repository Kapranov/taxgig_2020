defmodule Core.Media.Document do
  @moduledoc """
  Represents a document entity.
  """

  use Core.Model

  import Ecto.Changeset, only: [
    cast: 3,
    cast_embed: 2,
    validate_required: 2,
    foreign_key_constraint: 3,
    unique_constraint: 3
  ]

  alias Core.{
    Contracts.ProjectDoc,
    Media.File,
    Media.Helpers.CategoryEnum
  }

  @type t :: %__MODULE__{
    access_granted: boolean,
    category: String.t(),
    file: File.t(),
    format: String.t(),
    name: String.t(),
    project_doc: ProjectDoc.t(),
    signature: boolean,
    signed_by_pro: boolean,
    signed_by_tp: boolean,
    url: String.t()
  }

  @allowed_params ~w(
    access_granted
    category
    format
    name
    project_doc_id
    signature
    signed_by_pro
    signed_by_tp
    url
  )a

  @required_params ~w(
    access_granted
    category
    format
    name
    project_doc_id
    signature
    signed_by_pro
    signed_by_tp
    url
  )a

  schema "documents" do
    field :access_granted, :boolean, null: false
    field :category, CategoryEnum, null: false
    field :format, :string, null: false
    field :name, :string, null: false
    field :signature, :boolean, null: false
    field :signed_by_pro, :boolean, null: false
    field :signed_by_tp, :boolean, null: false
    field :url, :string, null: false

    embeds_one(:file, File, on_replace: :update)

    belongs_to :project_doc, ProjectDoc,
      foreign_key: :project_doc_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    timestamps()
  end

  @doc """
  Create changeset for Document.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> cast_embed(:file)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:project_doc_id, name: :documents_project_doc_id_fkey, message: "Select the ProjectDoc")
    |> unique_constraint(:project_doc_id, name: :documents_project_doc_id_index, message: "Only one a ProjectDoc Record")
  end
end

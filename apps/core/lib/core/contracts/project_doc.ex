defmodule Core.Contracts.ProjectDoc do
  @moduledoc """
  Schema for ProjectDoc.
  """

  use Core.Model

  alias Core.{
    Contracts.Project,
    Media.Document,
    Media.File
  }

  @type t :: %__MODULE__{
    doc_pro: File.t(),
    doc_tp: File.t(),
    document: Document.t(),
    project_id: Project.t()
  }

  @allowed_params ~w(project_id)a
  @required_params ~w(project_id)a

  schema "project_docs" do
    embeds_one :doc_pro, File, on_replace: :update
    embeds_one :doc_tp, File, on_replace: :update

    belongs_to :projects, Project,
      foreign_key: :project_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    has_one :document, Document,
      on_delete: :delete_all

    timestamps()
  end

  @doc """
  Create changeset for ProjectDoc.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> cast_embed(:doc_pro)
    |> cast_embed(:doc_tp)
    |> foreign_key_constraint(:project_id, message: "Select a Project")
  end
end

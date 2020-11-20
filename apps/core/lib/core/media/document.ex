defmodule Core.Media.Document do
  @moduledoc """
  Represents the Document.
  """

  use Core.Model

  alias Core.Contracts.Project

  import Ecto.Changeset, only: [
    cast: 3,
    foreign_key_constraint: 3,
    unique_constraint: 3,
    validate_required: 2
  ]

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    access_granted: boolean,
    category: integer,
    document_link: String.t(),
    format: integer,
    name: integer,
    project_id: Project.t(),
    signature_required_from_client: boolean,
    signed_by_client: boolean,
    signed_by_pro: boolean,
    size: integer,
    uploader: map
  }

  @allowed_params ~w(
    access_granted
    category
    document_link
    format
    name
    signature_required_from_client
    signed_by_client
    signed_by_pro
    size
    project_id
  )a

  @required_params ~w(project_id)a

  schema "documents" do
    field :access_granted, :boolean
    field :category, :integer
    field :document_link, :string
    field :format, :integer
    field :name, :integer
    field :signature_required_from_client, :boolean
    field :signed_by_client, :boolean
    field :signed_by_pro, :boolean
    field :size, :decimal
    field :uploader, :map, default: %{}

    belongs_to :project, Project, foreign_key: :project_id,
      type: FlakeId.Ecto.CompatType, references: :id

    timestamps()
  end

  @doc """
  Create changeset for Document.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:user, name: :documents_user_id_index, message: "Only one an User")
  end
end

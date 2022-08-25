defmodule Core.Media.ProDoc do
  @moduledoc """
  Represents a pro document entity.
  """

  use Core.Model

  import Ecto.Changeset, only: [
    cast: 3,
    cast_embed: 2,
    validate_required: 2,
    foreign_key_constraint: 3
  ]

  alias Core.{
    Accounts.User,
    Contracts.Project,
    Media.File,
    Media.Helpers.CategoryEnum
  }

  @type t :: %__MODULE__{
    category: String.t(),
    file: File.t(),
    project_id: Project.t(),
    signature: boolean,
    signed_by_pro: boolean,
    user_id: User.t()
  }

  @allowed_params ~w(
    category
    project_id
    signature
    signed_by_pro
    user_id
  )a

  @required_params ~w(
    category
    project_id
    signature
    signed_by_pro
    user_id
  )a

  schema "pro_docs" do
    field :category, CategoryEnum
    field :signature, :boolean
    field :signed_by_pro, :boolean

    embeds_one(:file, File, on_replace: :update)

    belongs_to :projects, Project,
      foreign_key: :project_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    belongs_to :users, User,
      foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    timestamps()
  end

  @doc """
  Create changeset for Pro Document.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> cast_embed(:file)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:project_id, name: :pro_docs_project_id_fkey, message: "Select the Project")
    |> foreign_key_constraint(:user_id, name: :pro_docs_user_id_fkey, message: "Select an User")
  end
end

defmodule Core.Contracts.ServiceReview do
  @moduledoc """
  Schema for ServiceReview.
  """

  use Core.Model

  alias Core.Contracts.Project

  @type t :: %__MODULE__{
    client_comment: String.t(),
    communication: integer,
    final_rating: integer,
    pro_response: String.t(),
    professionalism: integer,
    project_id: Project.t(),
    work_quality: integer
  }

  @allowed_params ~w(
    client_comment
    communication
    final_rating
    pro_response
    professionalism
    project_id
    work_quality
  )a

  @required_params ~w(
    communication
    final_rating
    professionalism
    project_id
    work_quality
  )a

  schema "service_reviews" do
    field :client_comment, :string, null: true
    field :communication, :integer, null: false
    field :final_rating, :decimal, null: false
    field :pro_response, :string, null: true
    field :professionalism, :integer, null: false
    field :work_quality, :integer, null: false

    belongs_to :project, Project,
      foreign_key: :project_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    timestamps()
  end

  @doc """
  Create changeset for ServiceReview.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end

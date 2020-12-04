defmodule Core.Contracts.Offer do
  @moduledoc """
  Schema for Offer.
  """

  use Core.Model

  alias Core.{
    Accounts.User,
    Contracts.Helpers.StatusEnum,
    Contracts.Project
  }

  @type t :: %__MODULE__{
    price: integer,
    project_id: Project.t(),
    status: String.t(),
    user_id: User.t()
  }

  @allowed_params ~w(
    price
    project_id
    status
    user_id
  )a

  @required_params ~w(
    price
    project_id
    status
    user_id
  )a

  schema "offers" do
    field :price, :integer, null: false, default: 0
    field :status, StatusEnum, null: false

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
  Create changeset for Addon.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:project_id, message: "Select a Project")
    |> foreign_key_constraint(:user_id, message: "Select an User")
  end
end

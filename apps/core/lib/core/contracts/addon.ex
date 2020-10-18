defmodule Core.Contracts.Addon do
  @moduledoc """
  Schema for Addon.
  """

  use Core.Model

  alias Core.{
    Accounts.User,
    Contracts.Helpers.StatusEnum,
    Contracts.Project
  }

  @type t :: %__MODULE__{
    addon_price: integer,
    project: Project.t(),
    status: String.t(),
    user_id: User.t()
  }

  @allowed_params ~w(
    addon_price
    status
    user_id
  )a

  @required_params ~w(
    addon_price
    status
    user_id
  )a

  schema "addons" do
    field :addon_price, :integer, null: false, default: 0
    field :status, StatusEnum, null: false

    has_one :project, Project, on_delete: :nilify_all

    belongs_to :user, User,
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
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:user, name: :addons_user_id_index, message: "Only one an User")
  end
end

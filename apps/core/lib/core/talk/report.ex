defmodule Core.Talk.Report do
  @moduledoc """
  Schema for Reports.
  """

  use Core.Model

  alias Core.{
    Accounts.User,
    Talk.Helpers.ReportEnum
  }

  @type t :: %__MODULE__{
    description: String.t(),
    messages: tuple,
    other: boolean(),
    reasons: String.t(),
    user_id: User.t()
  }

  @allowed_params ~w(
    description
    messages
    other
    reasons
    user_id
  )a

  @required_params ~w(
    messages
    user_id
  )a

  schema "reports" do
    field :description, :string
    field :messages, {:array, :string}, default: []
    field :other, :boolean
    field :reasons, ReportEnum

    belongs_to :users, User,
      foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    timestamps()
  end

  @doc """
  Create changeset for Reports.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:user_id, message: "Select an User")
  end
end

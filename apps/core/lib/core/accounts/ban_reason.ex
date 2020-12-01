defmodule Core.Accounts.BanReason do
  @moduledoc """
  Schema for BanReason.
  """

  use Core.Model

  alias Core.Accounts.{
    Helpers.BanReasonsEnum,
    Platform,
    User
  }

  @type t :: %__MODULE__{
    description: String.t(),
    other: boolean,
    platform_id: Platform.t(),
    reasons: String.t(),
    user_id: User.t()
  }

  @allowed_params ~w(
    description
    other
    platform_id
    reasons
    user_id
  )a

  @required_params ~w(
    other
    platform_id
    user_id
  )a

  schema "ban_reasons" do
    field :other, :boolean, null: false
    field :description, :string, null: true
    field :reasons, BanReasonsEnum, null: true

    belongs_to :platform, Platform,
      foreign_key: :platform_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    belongs_to :users, User,
      foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    timestamps()
  end

  @doc """
  Create changeset for BanReason.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:platform_id, message: "Select the Platform")
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:platform, name: :ban_reasons_platform_id_index, message: "Only one a Platform")
  end
end

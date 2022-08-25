defmodule Core.Accounts.Platform do
  @moduledoc """
  Schema for Platform.
  """

  use Core.Model

  alias Core.Accounts.{
    BanReason,
    Helpers.StuckStageEnum,
    User
  }

  @type t :: %__MODULE__{
    ban_reason: BanReason.t(),
    client_limit_reach: boolean,
    hero_active: boolean,
    hero_status: boolean,
    is_banned: boolean,
    is_online: boolean,
    is_stuck: boolean,
    payment_active: boolean,
    stuck_stage: String.t(),
    user_id: User.t()
  }

  @allowed_params ~w(
    client_limit_reach
    hero_active
    hero_status
    is_banned
    is_online
    is_stuck
    payment_active
    stuck_stage
    user_id
  )a

  @required_params ~w(
    is_banned
    is_online
    is_stuck
    payment_active
    user_id
  )a

  schema "platforms" do
    field :client_limit_reach, :boolean
    field :hero_active, :boolean
    field :hero_status, :boolean
    field :is_banned, :boolean, default: false
    field :is_online, :boolean, default: false
    field :is_stuck, :boolean, default: false
    field :payment_active, :boolean, default: false
    field :stuck_stage, StuckStageEnum

    belongs_to :user, User,
      foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    has_one :ban_reason, BanReason, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Create changeset for Platform.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:user, name: :platforms_user_id_index, message: "Only one an User")
  end
end

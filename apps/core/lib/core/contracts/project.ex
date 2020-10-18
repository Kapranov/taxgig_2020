defmodule Core.Contracts.Project do
  @moduledoc """
  Schema for the Project.
  """

  use Core.Model

  alias Core.{
    Accounts.User,
    Contracts.Addon,
    Contracts.Helpers.ProjectEnum,
    Contracts.Offer
  }

  @type t :: %__MODULE__{
    addon_id: Addon.t(),
    assigned_pro: FlakeId.Ecto.Type,
    end_time: DateTime.t(),
    instant_matched: boolean,
    offer_id: Offer.t(),
    project_price: integer,
    status: String.t(),
    stripe_card_token_id: FlakeId.Ecto.Type,
    user_id: User.t()
  }

  @allowed_params ~w(
    addon_id
    assigned_pro
    end_time
    instant_matched
    offer_id
    project_price
    status
    stripe_card_token_id
    user_id
  )a

  @required_params ~w(
    instant_matched
    status
    user_id
  )a

  schema "projects" do
    field :assigned_pro, FlakeId.Ecto.Type, null: true
    field :end_time, :date, null: true
    field :instant_matched, :boolean, null: false
    field :project_price, :decimal, null: true
    field :status, ProjectEnum, null: false
    field :stripe_card_token_id, FlakeId.Ecto.Type, null: true

    belongs_to :addon, Addon,
      foreign_key: :addon_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    belongs_to :offer, Offer,
      foreign_key: :offer_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    belongs_to :users, User,
      foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    timestamps()
  end

  @doc """
  Create changeset for the Project.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:addon_id, message: "Select an Addon")
    |> foreign_key_constraint(:offer_id, message: "Select an Offer")
    |> foreign_key_constraint(:stripe_card_token_id, message: "Select the Card")
    |> foreign_key_constraint(:user_id, message: "Select an User")
  end
end

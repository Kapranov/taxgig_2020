defmodule Stripy.Payments.StripeAccount do
  @moduledoc """
  Schema for StripeAccount.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    business_profile: tuple,
    business_type: String.t(),
    capabilities: tuple,
    charges_enabled: boolean,
    country: String.t(),
    created: integer,
    default_currency: String.t(),
    details_submitted: boolean,
    email: String.t(),
    external_accounts: tuple,
    id_from_stripe: String.t(),
    metadata: tuple,
    payouts_enabled: boolean,
    requirements: tuple,
    settings: tuple,
    tos_acceptance: tuple,
    type: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    business_profile
    business_type
    capabilities
    charges_enabled
    country
    created
    default_currency
    details_submitted
    email
    external_accounts
    id_from_stripe
    metadata
    payouts_enabled
    requirements
    settings
    tos_acceptance
    type
    user_id
  )a

  @required_params ~w(
    email
    id_from_stripe
    user_id
  )a

  schema "stripe_accounts" do
    field :business_profile, {:array, :map}
    field :business_type, :string, default: "individual"
    field :capabilities, {:array, :map}
    field :charges_enabled, :boolean
    field :country, :string, default: "US"
    field :created, :integer
    field :default_currency, :string, default: "usd"
    field :details_submitted, :boolean
    field :email, :string
    field :external_accounts, {:array, :map}
    field :id_from_stripe, :string, null: false
    field :metadata, {:array, :map}
    field :payouts_enabled, :boolean
    field :requirements, {:array, :map}
    field :settings, {:array, :map}
    field :tos_acceptance, {:array, :map}
    field :type, :string, default: "custom"
    field :user_id, FlakeId.Ecto.CompatType, null: false

    timestamps()
  end

  @doc """
  Create changeset for StripeAccount.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:email, name: :stripe_accounts_email_index)
    |> unique_constraint(:id_from_stripe, name: :stripe_accounts_id_from_stripe_index)
  end
end

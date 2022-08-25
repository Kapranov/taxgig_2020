defmodule Stripy.Payments.StripeAccount do
  @moduledoc """
  Schema for StripeAccount.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    business_url: String.t(),
    capabilities: map,
    charges_enabled: boolean,
    country: String.t(),
    created: integer,
    default_currency: String.t(),
    details_submitted: boolean,
    email: String.t(),
    id_from_stripe: String.t(),
    payouts_enabled: boolean,
    tos_acceptance: map,
    type: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    business_url
    capabilities
    charges_enabled
    country
    created
    default_currency
    details_submitted
    email
    id_from_stripe
    payouts_enabled
    tos_acceptance
    type
    user_id
  )a

  @required_params ~w(
    business_url
    capabilities
    charges_enabled
    country
    created
    default_currency
    details_submitted
    email
    id_from_stripe
    payouts_enabled
    tos_acceptance
    type
    user_id
  )a

  schema "stripe_accounts" do
    field :business_url, :string, default: "https://taxgig.com"
    field :capabilities, :map
    field :charges_enabled, :boolean
    field :country, :string, default: "US"
    field :created, :integer
    field :default_currency, :string, default: "usd"
    field :details_submitted, :boolean
    field :email, :string
    field :id_from_stripe, :string
    field :payouts_enabled, :boolean
    field :tos_acceptance, :map
    field :type, :string, default: "custom"
    field :user_id, FlakeId.Ecto.CompatType

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
    |> unique_constraint(:user_id, name: :stripe_accounts_user_id_index)
  end
end

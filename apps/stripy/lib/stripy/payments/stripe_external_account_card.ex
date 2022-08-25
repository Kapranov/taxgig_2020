defmodule Stripy.Payments.StripeExternalAccountCard do
  @moduledoc """
  Schema for StripeCustomer.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    brand: String.t(),
    country: String.t(),
    currency: String.t(),
    cvc_check: String.t(),
    default_for_currency: boolean,
    exp_month: integer,
    exp_year: integer,
    fingerprint: String.t(),
    funding: String.t(),
    id_from_account: String.t(),
    id_from_stripe: String.t(),
    last4: String.t(),
    name: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    brand
    country
    currency
    cvc_check
    default_for_currency
    exp_month
    exp_year
    fingerprint
    funding
    id_from_account
    id_from_stripe
    last4
    name
    user_id
  )a

  @required_params ~w(
    brand
    country
    currency
    cvc_check
    default_for_currency
    exp_month
    exp_year
    fingerprint
    funding
    id_from_account
    id_from_stripe
    last4
    name
    user_id
  )a

  schema "stripe_external_account_cards" do
    field :brand, :string
    field :country, :string
    field :currency, :string, default: "usd"
    field :cvc_check, :string
    field :default_for_currency, :boolean
    field :exp_month, :integer
    field :exp_year, :integer
    field :fingerprint, :string
    field :funding, :string
    field :id_from_account, :string
    field :id_from_stripe, :string
    field :last4, :string
    field :name, :string
    field :user_id, FlakeId.Ecto.CompatType

    timestamps()
  end

  @doc """
  Create changeset for StripeExternalAccountCard.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, params) do
    struct
    |> cast(params, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:id_from_stripe, name: :stripe_external_account_cards_id_from_stripe_index)
  end
end

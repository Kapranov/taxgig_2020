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

  schema "stripe_external_account_banks" do
    field :brand, :string, null: false
    field :country, :string, null: false
    field :currency, :string, null: false
    field :cvc_check, :string, null: false
    field :default_for_currency, :boolean, null: false
    field :exp_month, :integer, null: false
    field :exp_year, :integer, null: false
    field :fingerprint, :string, null: false
    field :funding, :string, null: false
    field :id_from_account, :string, null: false
    field :id_from_stripe, :string, null: false
    field :last4, :string, null: false
    field :name, :string, null: false
    field :user_id, FlakeId.Ecto.CompatType, null: false

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

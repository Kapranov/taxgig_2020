defmodule Stripy.Payments.StripeExternalAccountCard do
  @moduledoc """
  Schema for StripeCustomer.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    account_id_from_stripe: String.t(),
    brand: String.t(),
    country: String.t(),
    currency: String.t(),
    customer_id: String.t(),
    cvc: integer,
    cvc_check: String.t(),
    default_for_currency: boolean,
    dynamic_last4: String.t(),
    exp_month: integer,
    exp_year: integer,
    fingerprint: String.t(),
    funding: String.t(),
    id_from_stripe: String.t(),
    last4: String.t(),
    metadata: tuple,
    name: String.t(),
    number: String.t(),
    tokenization_method: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    account_id_from_stripe
    brand
    country
    currency
    customer_id
    cvc
    cvc_check
    default_for_currency
    dynamic_last4
    exp_month
    exp_year
    fingerprint
    funding
    id_from_stripe
    last4
    metadata
    name
    number
    tokenization_method
    user_id
  )a

  @required_params ~w(
    account_id_from_stripe
    customer_id
    exp_month
    exp_year
    id_from_stripe
    number
    user_id
  )a

  schema "stripe_external_account_banks" do
    field :account_id_from_stripe, :string, null: false
    field :brand, :string
    field :country, :string
    field :currency, :string
    field :customer_id, :string, null: false
    field :cvc, :integer
    field :cvc_check, :string
    field :default_for_currency, :boolean
    field :dynamic_last4, :string
    field :exp_month, :integer, null: false
    field :exp_year, :integer, null: false
    field :fingerprint, :string
    field :funding, :string
    field :id_from_stripe, :string, null: false
    field :last4, :string
    field :metadata, {:array, :map}
    field :name, :string
    field :number, :string, null: false
    field :tokenization_method, :string
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

defmodule Stripy.Payments.StripeExternalAccountBank do
  @moduledoc """
  Schema for StripeCustomer.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    account_holder_name: String.t(),
    account_holder_type: String.t(),
    bank_name: String.t(),
    country: String.t(),
    currency: String.t(),
    fingerprint: String.t(),
    id_from_account: String.t(),
    id_from_stripe: String.t(),
    last4: String.t(),
    routing_number: String.t(),
    status: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    account_holder_name
    account_holder_type
    bank_name
    country
    currency
    fingerprint
    id_from_account
    id_from_stripe
    last4
    routing_number
    status
    user_id
  )a

  @required_params ~w(
    account_holder_name
    account_holder_type
    bank_name
    country
    currency
    fingerprint
    id_from_account
    id_from_stripe
    last4
    routing_number
    status
    user_id
  )a

  schema "stripe_external_account_banks" do
    field :account_holder_name, :string
    field :account_holder_type, :string
    field :bank_name, :string
    field :country, :string
    field :currency, :string, default: "usd"
    field :fingerprint, :string
    field :id_from_account, :string
    field :id_from_stripe, :string
    field :last4, :string
    field :routing_number, :string
    field :status, :string
    field :user_id, FlakeId.Ecto.CompatType

    timestamps()
  end

  @doc """
  Create changeset for StripeExternalAccountBank.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, params) do
    struct
    |> cast(params, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:id_from_stripe, name: :stripe_external_account_banks_id_from_stripe_index)
  end
end

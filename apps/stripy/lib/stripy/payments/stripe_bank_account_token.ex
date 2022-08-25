defmodule Stripy.Payments.StripeBankAccountToken do
  @moduledoc """
  Schema for StripeBankAccountToken.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    account_holder_name: String.t(),
    account_holder_type: String.t(),
    bank_name: String.t(),
    client_ip: String.t(),
    country: String.t(),
    created: integer,
    currency: String.t(),
    fingerprint: String.t(),
    id_from_bank_account: String.t(),
    id_from_stripe: String.t(),
    last4: String.t(),
    routing_number: String.t(),
    status: String.t(),
    used: boolean,
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    account_holder_name
    account_holder_type
    bank_name
    client_ip
    country
    created
    currency
    fingerprint
    id_from_bank_account
    id_from_stripe
    last4
    routing_number
    status
    used
    user_id
  )a

  @required_params ~w(
    account_holder_name
    account_holder_type
    bank_name
    client_ip
    country
    created
    currency
    fingerprint
    id_from_bank_account
    id_from_stripe
    last4
    routing_number
    status
    used
    user_id
  )a

  schema "stripe_bank_account_tokens" do
    field :account_holder_name, :string
    field :account_holder_type, :string
    field :bank_name, :string
    field :client_ip, :string
    field :country, :string
    field :created, :integer
    field :currency, :string, default: "usd"
    field :fingerprint, :string
    field :id_from_bank_account, :string
    field :id_from_stripe, :string
    field :last4, :string
    field :routing_number, :string
    field :status, :string
    field :used, :boolean
    field :user_id, FlakeId.Ecto.CompatType

    timestamps()
  end

  @doc """
  Create changeset for StripeBankAccountToken.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, params) do
    struct
    |> cast(params, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:id_from_bank_account, name: :stripe_bank_account_tokens_id_from_bank_account_index)
    |> unique_constraint(:id_from_stripe, name: :stripe_bank_account_tokens_id_from_stripe_index)
  end
end

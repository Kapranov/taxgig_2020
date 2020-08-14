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
    bank_account: String.t(),
    bank_name: String.t(),
    bank_token: String.t(),
    country: String.t(),
    created: integer(),
    currency: String.t(),
    fingerprint: String.t(),
    last4: String.t(),
    routing_number: String.t(),
    status: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    account_holder_name
    account_holder_type
    bank_account
    bank_name
    bank_token
    country
    created
    currency
    fingerprint
    last4
    routing_number
    status
    user_id
  )a

  @required_params ~w(
    bank_account
    bank_token
    user_id
  )a

  schema "stripe_bank_account_tokens" do
    field :account_holder_name, :string
    field :account_holder_type, :string
    field :bank_account, :string, null: false
    field :bank_name, :string
    field :bank_token, :string, null: false
    field :country, :string
    field :created, :integer
    field :currency, :string
    field :fingerprint, :string
    field :last4, :string
    field :routing_number, :string
    field :status, :string
    field :user_id, FlakeId.Ecto.CompatType, null: false

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
    |> unique_constraint(:bank_token, name: :stripe_bank_account_tokens_bank_token_index)
  end
end

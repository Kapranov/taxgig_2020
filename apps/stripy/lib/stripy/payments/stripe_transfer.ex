defmodule Stripy.Payments.StripeTransfer do
  @moduledoc """
  Schema for StripeTransfer.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    id_from_stripe: String.t(),
    account_id_from_stripe: String.t(),
    amount: integer,
    amount_reversed: integer,
    balance_transaction: String.t(),
    created: integer,
    currency: String.t(),
    description: String.t(),
    destination: String.t(),
    destination_payment: String.t(),
    livemode: boolean,
    metadata: tuple,
    reversals: tuple,
    reversed: boolean,
    source_transaction: String.t(),
    source_type: String.t(),
    transfer_group: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    account_id_from_stripe
    amount
    amount_reversed
    balance_transaction
    created
    currency
    description
    destination
    destination_payment
    id_from_stripe
    livemode
    metadata
    reversals
    reversed
    source_transaction
    source_type
    transfer_group
    user_id
  )a

  @required_params ~w(
    account_id_from_stripe
    amount
    currency
    destination
    id_from_stripe
    user_id
  )a

  schema "stripe_transfers" do
    field :id_from_stripe, :string, null: false
    field :account_id_from_stripe, :string, null: false
    field :amount, :integer, null: false
    field :amount_reversed, :integer
    field :balance_transaction, :string
    field :created, :integer
    field :currency, :string, null: false
    field :description, :string
    field :destination, :string, null: false
    field :destination_payment, :string
    field :livemode, :boolean
    field :metadata, {:array, :map}
    field :reversals, {:array, :map}
    field :reversed, :boolean
    field :source_transaction, :string
    field :source_type, :string
    field :transfer_group, :string
    field :user_id, FlakeId.Ecto.CompatType, null: false

    timestamps()
  end

  @doc """
  Create changeset for StripeTransfer.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, params) do
    struct
    |> cast(params, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:id_from_stripe, name: :stripe_transfers_id_from_stripe_index)
  end
end

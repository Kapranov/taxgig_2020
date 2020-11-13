defmodule Stripy.Payments.StripeTransferReversal do
  @moduledoc """
  Schema for StripeTransferReversal.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    amount: integer,
    balance_transaction: String.t(),
    created: integer,
    currency: String.t(),
    destination_payment_refund: String.t(),
    id_from_stripe: String.t(),
    id_from_transfer: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    amount
    balance_transaction
    created
    currency
    destination_payment_refund
    id_from_stripe
    id_from_transfer
    user_id
  )a

  @required_params ~w(
    amount
    balance_transaction
    created
    currency
    destination_payment_refund
    id_from_stripe
    id_from_transfer
    user_id
  )a

  schema "stripe_transfer_reversals" do
    field :amount, :integer, null: false
    field :balance_transaction, :string, null: false
    field :created, :integer, null: false
    field :currency, :string, null: false, default: "usd"
    field :destination_payment_refund, :string, null: false
    field :id_from_stripe, :string, null: false
    field :id_from_transfer, :string, null: false
    field :user_id, FlakeId.Ecto.CompatType, null: false

    timestamps()
  end

  @doc """
  Create changeset for StripeTransferReversal.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, params) do
    struct
    |> cast(params, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:id_from_stripe, name: :stripe_transfer_reversals_id_from_stripe_index)
    |> unique_constraint(:id_from_transfer, name: :stripe_transfer_reversals_id_from_transfer_index)
  end
end

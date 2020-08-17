defmodule Stripy.Payments.StripeRefund do
  @moduledoc """
  Schema for StripeRefund.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    amount: integer,
    balance_transaction: String.t(),
    created: integer,
    currency: String.t(),
    id_from_charge: String.t(),
    id_from_stripe: String.t(),
    metadata: tuple,
    payment_intent: String.t(),
    reason: String.t(),
    receipt_number: String.t(),
    refund_application_fee: boolean,
    reverse_transfer: boolean,
    source_transfer_reversal: String.t(),
    status: String.t(),
    transfer_reversal: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    amount
    balance_transaction
    created
    currency
    id_from_charge
    id_from_stripe
    metadata
    payment_intent
    reason
    receipt_number
    refund_application_fee
    reverse_transfer
    source_transfer_reversal
    status
    transfer_reversal
    user_id
  )a

  @required_params ~w(
    id_from_charge
    id_from_stripe
    user_id
  )a

  schema "stripe_refunds" do
    field :id_from_stripe, :string, null: false
    field :id_from_charge, :string, null: false
    field :amount, :integer
    field :balance_transaction, :string
    field :created, :integer
    field :currency, :string
    field :metadata, {:array, :map}
    field :payment_intent, :string
    field :reason, :string
    field :receipt_number, :string
    field :refund_application_fee, :boolean
    field :reverse_transfer, :boolean
    field :source_transfer_reversal, :string
    field :status, :string
    field :transfer_reversal, :string
    field :user_id, FlakeId.Ecto.CompatType, null: false

    timestamps()
  end

  @doc """
  Create changeset for StripeRefund.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, params) do
    struct
    |> cast(params, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:id_from_charge, name: :stripe_refunds_id_from_charge_index)
    |> unique_constraint(:id_from_stripe, name: :stripe_refunds_id_from_stripe_index)
  end
end

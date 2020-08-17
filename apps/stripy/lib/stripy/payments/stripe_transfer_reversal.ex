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
    metadata: tuple,
    source_refund: String.t(),
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
    metadata
    source_refund
    user_id
  )a

  @required_params ~w(
    id_from_stripe
    id_from_transfer
    user_id
  )a

  schema "stripe_transfer_reversals" do
    field :id_from_stripe, :string, null: false
    field :id_from_transfer, :string, null: false
    field :amount, :integer
    field :balance_transaction, :string
    field :created, :integer
    field :currency, :string
    field :destination_payment_refund, :string
    field :metadata, {:array, :map}
    field :source_refund, :string
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
  end
end

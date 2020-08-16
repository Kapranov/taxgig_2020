defmodule Stripy.Payments.StripeCharge do
  @moduledoc """
  Schema for StripeCharge.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    id_from_stripe: String.t(),
    amount: integer,
    amount_refunded: integer,
    application: String.t(),
    application_fee: String.t(),
    application_fee_amount: integer,
    balance_transaction: String.t(),
    billing_details: tuple,
    calculated_statement_descriptor: String.t(),
    captured: boolean,
    card_token_id_from_stripe: String.t(),
    created: integer,
    currency: String.t(),
    customer_id: String.t(),
    description: String.t(),
    disputed: boolean,
    failure_code: String.t(),
    failure_message: String.t(),
    fraud_details: tuple,
    livemode: boolean,
    metadata: tuple,
    on_behalf_of: String.t(),
    order: String.t(),
    outcome: tuple,
    paid: boolean,
    payment_method: String.t(),
    payment_method_details: tuple,
    receipt_email: String.t(),
    receipt_number: String.t(),
    receipt_url: String.t(),
    refunded: boolean,
    refunds: tuple,
    review: String.t(),
    shipping: tuple,
    source_transfer: String.t(),
    statement_descriptor: String.t(),
    statement_descriptor_suffix: String.t(),
    status: String.t(),
    transfer: String.t(),
    transfer_data: tuple,
    transfer_group: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    amount
    amount_refunded
    application
    application_fee
    application_fee_amount
    balance_transaction
    billing_details
    calculated_statement_descriptor
    captured
    card_token_id_from_stripe
    created
    currency
    customer_id
    description
    disputed
    failure_code
    failure_message
    fraud_details
    id_from_stripe
    livemode
    metadata
    on_behalf_of
    order
    outcome
    paid
    payment_method
    payment_method_details
    receipt_email
    receipt_number
    receipt_url
    refunded
    refunds
    review
    shipping
    source_transfer
    statement_descriptor
    statement_descriptor_suffix
    status
    transfer
    transfer_data
    transfer_group
    user_id
  )a

  @required_params ~w(
    amount
    currency
    customer_id
    id_from_stripe
    user_id
  )a

  schema "stripe_charges" do
    field :id_from_stripe, :string, null: false
    field :amount, :integer, null: false
    field :amount_refunded, :integer
    field :application, :string
    field :application_fee, :string
    field :application_fee_amount, :integer
    field :balance_transaction, :string
    field :billing_details, {:array, :map}
    field :calculated_statement_descriptor, :string
    field :captured, :boolean
    field :card_token_id_from_stripe, :string
    field :created, :integer
    field :currency, :string, null: false
    field :customer_id, :string, null: false
    field :description, :string
    field :disputed, :boolean
    field :failure_code, :string
    field :failure_message, :string
    field :fraud_details, {:array, :map}
    field :livemode, :boolean
    field :metadata, {:array, :map}
    field :on_behalf_of, :string
    field :order, :string
    field :outcome, {:array, :map}
    field :paid, :boolean
    field :payment_method, :string
    field :payment_method_details, {:array, :map}
    field :receipt_email, :string
    field :receipt_number, :string
    field :receipt_url, :string
    field :refunded, :boolean
    field :refunds, {:array, :map}
    field :review, :string
    field :shipping, {:array, :map}
    field :source_transfer, :string
    field :statement_descriptor, :string
    field :statement_descriptor_suffix, :string
    field :status, :string
    field :transfer, :string
    field :transfer_data, {:array, :map}
    field :transfer_group, :string
    field :user_id, FlakeId.Ecto.CompatType, null: false

    timestamps()
  end

  @doc """
  Create changeset for StripeCharge.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, params) do
    struct
    |> cast(params, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:id_from_stripe, name: :stripe_charges_id_from_stripe_index)
  end
end

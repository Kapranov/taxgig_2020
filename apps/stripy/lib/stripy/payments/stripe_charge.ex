defmodule Stripy.Payments.StripeCharge do
  @moduledoc """
  Schema for StripeCharge.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    amount: integer,
    amount_refunded: integer,
    captured: boolean,
    created: integer,
    currency: String.t(),
    description: String.t(),
    failure_code: String.t(),
    failure_message: String.t(),
    fraud_details: tuple,
    id_from_card_token: String.t(),
    id_from_customer: String.t(),
    id_from_stripe: String.t(),
    outcome: tuple,
    receipt_url: String.t(),
    source: tuple,
    status: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    amount
    amount_refunded
    captured
    created
    currency
    description
    failure_code
    failure_message
    fraud_details
    id_from_card_token
    id_from_customer
    id_from_stripe
    outcome
    receipt_url
    source
    status
    user_id
  )a

  @required_params ~w(
    amount
    amount_refunded
    captured
    created
    currency
    description
    fraud_details
    id_from_card_token
    id_from_customer
    id_from_stripe
    outcome
    receipt_url
    source
    status
    user_id
  )a

  schema "stripe_charges" do
    field :amount, :integer, null: false
    field :amount_refunded, :integer, null: false
    field :captured, :boolean, null: false
    field :created, :integer, null: false
    field :currency, :string, null: false
    field :description, :string, null: false
    field :failure_code, :string, null: true
    field :failure_message, :string, null: true
    field :fraud_details, {:array, :map}, null: false, default: []
    field :id_from_card_token, :string, null: false
    field :id_from_customer, :string, null: false
    field :id_from_stripe, :string, null: false
    field :outcome, {:array, :map}, null: false
    field :receipt_url, :string, null: false
    field :source, {:array, :map}, null: false
    field :status, :string, null: false
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

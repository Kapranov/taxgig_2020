defmodule Stripy.Payments.StripeRefund do
  @moduledoc """
  Schema for StripeRefund.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    amount: integer,
    created: integer,
    currency: String.t(),
    id_from_charge: String.t(),
    id_from_stripe: String.t(),
    reason: String.t(),
    status: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    amount
    created
    currency
    id_from_charge
    id_from_stripe
    reason
    status
    user_id
  )a

  @required_params ~w(
  )a

  schema "stripe_refunds" do
    field :amount, :integer, null: false
    field :created, :integer, null: false
    field :currency, :string, null: false
    field :id_from_charge, :string, null: false
    field :id_from_stripe, :string, null: false
    field :reason, :string, null: false
    field :status, :string, null: false
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

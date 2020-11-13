defmodule Stripy.Payments.StripeCustomer do
  @moduledoc """
  Schema for StripeCustomer.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    balance: integer,
    created: integer,
    currency: String.t(),
    email: String.t(),
    id_from_stripe: String.t(),
    name: String.t(),
    phone: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    balance
    created
    currency
    email
    id_from_stripe
    name
    phone
    user_id
  )a

  @required_params ~w(
    balance
    created
    email
    id_from_stripe
    name
    phone
    user_id
  )a

  schema "stripe_customers" do
    field :balance, :integer, null: false, default: 0
    field :created, :integer, null: false
    field :currency, :string, null: true, default: "usd"
    field :email, :string, null: false
    field :id_from_stripe, :string, null: false
    field :name, :string, null: false
    field :phone, :string, null: false
    field :user_id, FlakeId.Ecto.CompatType, null: false

    timestamps()
  end

  @doc """
  Create changeset for StripeCustomer.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, params) do
    struct
    |> cast(params, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:email, name: :stripe_customers_email_index)
    |> unique_constraint(:id_from_stripe, name: :stripe_customers_id_from_stripe_index)
    |> unique_constraint(:user_id, name: :stripe_customers_user_id_index)
  end
end

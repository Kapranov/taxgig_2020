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
    field :balance, :integer, default: 0
    field :created, :integer
    field :currency, :string, default: "usd"
    field :email, :string
    field :id_from_stripe, :string
    field :name, :string
    field :phone, :string
    field :user_id, FlakeId.Ecto.CompatType

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

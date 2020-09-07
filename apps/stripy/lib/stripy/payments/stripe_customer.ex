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
    name: String.t(),
    phone: String.t(),
    stripe_customer_id: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    balance
    created
    currency
    email
    name
    phone
    stripe_customer_id
    user_id
  )a

  @required_params ~w(
    stripe_customer_id
    user_id
  )a

  schema "stripe_customers" do
    field :balance, :integer
    field :created, :integer, null: false
    field :currency, :string, null: false
    field :email, :string, null: false
    field :name, :string
    field :phone, :string
    field :stripe_customer_id, :string, null: false
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
    |> unique_constraint(:stripe_customer_id, name: :stripe_customers_stripe_customer_id_index)
    |> unique_constraint(:user_id, name: :stripe_customers_user_id_index)
  end
end

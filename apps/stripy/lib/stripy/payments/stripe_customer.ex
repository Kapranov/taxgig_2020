defmodule Stripy.Payments.StripeCustomer do
  @moduledoc """
  Schema for StripeCustomer.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    account_balance: integer,
    address: tuple,
    created: integer,
    currency: String.t(),
    default_source: String.t(),
    delinquent: boolean,
    description: String.t(),
    discount: tuple,
    email: String.t(),
    invoice_prefix: String.t(),
    invoice_settings: tuple,
    livemode: boolean,
    metadata: tuple,
    name: String.t(),
    phone: String.t(),
    preferred_locales: tuple,
    shipping: tuple,
    sources: tuple,
    stripe_customer_id: String.t(),
    subscriptions: tuple,
    tax_exempt: String.t(),
    tax_ids: tuple,
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    account_balance
    address
    created
    currency
    default_source
    delinquent
    description
    discount
    email
    invoice_prefix
    invoice_settings
    livemode
    metadata
    name
    phone
    preferred_locales
    shipping
    sources
    stripe_customer_id
    subscriptions
    tax_exempt
    tax_ids
    user_id
  )a

  @required_params ~w(
    stripe_customer_id
    user_id
  )a

  schema "stripe_customers" do
    field :account_balance, :integer
    field :address, {:array, :map}
    field :created, :integer, null: false
    field :currency, :string, null: false
    field :default_source, :string
    field :delinquent, :boolean
    field :description, :string
    field :discount, {:array, :map}
    field :email, :string, null: false
    field :invoice_prefix, :string
    field :invoice_settings, {:array, :map}
    field :livemode, :boolean
    field :metadata, {:array, :map}
    field :name, :string
    field :phone, :string
    field :preferred_locales, {:array, :map}
    field :shipping, {:array, :map}
    field :sources, {:array, :map}
    field :stripe_customer_id, :string, null: false
    field :subscriptions, {:array, :map}
    field :tax_exempt, :string
    field :tax_ids, {:array, :map}
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
  end
end

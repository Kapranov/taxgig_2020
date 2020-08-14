defmodule Stripy.Payments.StripeAccountToken do
  @moduledoc """
  Schema for StripeAccountToken.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    account_token: String.t(),
    created: integer(),
    used: boolean(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    account_token
    created
    used
    user_id
  )a

  @required_params ~w(
    account_token
    created
    used
    user_id
  )a

  schema "stripe_account_tokens" do
    field :account_token, :string, null: false
    field :created, :integer, null: false
    field :used, :boolean, null: false
    field :user_id, FlakeId.Ecto.CompatType, null: false

    timestamps()
  end

  @doc """
  Create changeset for StripeAccountToken.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:account_token, name: :stripe_account_tokens_account_token_index)
  end
end

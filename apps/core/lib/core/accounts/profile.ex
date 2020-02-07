defmodule Core.Accounts.Profile do
  @moduledoc """
  Schema for Profile.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Core.{
    Accounts.User,
    Lookup.UsZipcode
  }

  @type t :: %__MODULE__{
    address: String.t(),
    banner: String.t(),
    description: String.t(),
    logo: map(),
    us_zipcode: UsZipcode.t(),
    user_id: User.t()
  }

  @primary_key {:id, :binary_id, autogenerate: false, source: :user_id}
  @timestamps_opts [type: :utc_datetime, usec: true]

  @allowed_params ~w(
    address
    banner
    description
    logo
    us_zipcode_id
    user_id
  )a

  @required_params ~w(
    user_id
  )a

  schema "profiles" do
    field :address, :string, null: true
    field :banner, :string, null: true
    field :description, :string, null: true
    field :logo, :map, null: true

    belongs_to :user, User, foreign_key: :user_id, type: :binary_id,
      references: :id
    belongs_to :us_zipcode, UsZipcode, foreign_key: :us_zipcode_id,
      type: :binary_id, references: :id

    timestamps()
  end

  @doc """
  Create changeset for Profile.
  """
  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:us_zipcode_id, message: "Select the UsZipcode")
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:user_id, name: :profiles_user_id_index)
  end
end

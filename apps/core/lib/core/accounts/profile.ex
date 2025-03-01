defmodule Core.Accounts.Profile do
  @moduledoc """
  Schema for Profile.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Core.{
    Accounts.User,
    Lookup.UsZipcode,
    Media.File,
    Media.Picture
  }

  @type t :: %__MODULE__{
    address: String.t(),
    banner: String.t(),
    description: String.t(),
    logo: File.t(),
    us_zipcode: UsZipcode.t(),
    user_id: User.t()
  }

  @primary_key {:id, FlakeId.Ecto.CompatType, autogenerate: false, source: :user_id}
  @timestamps_opts [type: :utc_datetime, usec: true]

  @allowed_params ~w(
    address
    banner
    description
    us_zipcode_id
    user_id
  )a

  @required_params ~w(user_id)a

  schema "profiles" do
    field :address, :string
    field :banner, :string
    field :description, :string

    embeds_one :logo, File, on_replace: :update

    belongs_to :user, User,
      foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    belongs_to :us_zipcode, UsZipcode,
      foreign_key: :us_zipcode_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    has_one :picture, Picture,
      on_delete: :delete_all

    timestamps()
  end

  @doc """
  Create changeset for Profile.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> cast_embed(:logo)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:us_zipcode_id, message: "Select the UsZipcode")
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:user_id, name: :profiles_user_id_index)
  end
end

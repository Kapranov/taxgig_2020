defmodule Core.Lookup.UsZipcode do
  @moduledoc """
  Schema for UsZipcode.
  """

  use Core.Model

  alias Core.Accounts.Profile

  @type t :: %__MODULE__{
    city: String.t(),
    profile: [Profile.t()],
    state: String.t(),
    zipcode: integer()
  }

  @allowed_params ~w(
    city
    state
    zipcode
  )a

  @required_params ~w(
    city
    state
    zipcode
  )a

  schema "us_zipcodes" do
    field :city, :string
    field :state, :string
    field :zipcode, :integer

    has_one :profile, Profile
  end

  @doc """
  Create changeset for UsZipcode.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end

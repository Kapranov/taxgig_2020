defmodule Ptin.Services.Ptin do
  @moduledoc false

  use Ptin.Model

  @type t :: %__MODULE__{
    bus_addr_zip: String.t(),
    bus_st_code: String.t(),
    first_name: String.t(),
    last_name: String.t(),
    profession: String.t()
  }

  @allowed_params ~w(
    bus_addr_zip
    bus_st_code
    first_name
    last_name
    profession
  )a

  @required_params ~w(
    bus_addr_zip
    bus_st_code
    first_name
    last_name
  )a

  schema "ptins" do
    field :bus_addr_zip, :string, null: false
    field :bus_st_code, :string, null: false
    field :first_name, :string, null: false
    field :last_name, :string, null: false
    field :profession, :string, null: false
  end

  @doc """
  Builds a changeset based on the `%Ptin{}` and `attrs`.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end

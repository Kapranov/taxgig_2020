defmodule Ptin.Services.Expire do
  @moduledoc false

  use Ptin.Model

  @type t :: %__MODULE__{
    expired: String.t(),
    url: String.t()
  }

  @allowed_params ~w(
    expired
    url
  )a

  @required_params ~w(
    expired
    url
  )a

  schema "expires" do
    field :expired, :string, null: false
    field :url, :string, null: false
  end

  @doc """
  Builds a changeset based on the `%Expire{}` and `attrs`.
  """
  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end

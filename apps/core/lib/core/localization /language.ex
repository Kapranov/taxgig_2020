defmodule Core.Localization.Language do
  @moduledoc """
  Schema for Language.
  """

  use Core.Model

  alias Core.Accounts.User

  @type t :: %__MODULE__{
    abbr: String.t(),
    name: String.t(),
    users: [User.t()]
  }

  @allowed_params ~w(
    abbr
    name
  )a

  @required_params ~w(
    abbr
    name
  )a

  schema "languages" do
    field :abbr, :string
    field :name, :string

    many_to_many :users, User,
      join_through: "users_languages",
      on_replace: :delete

    timestamps()
  end

  @doc """
  Create changeset for Language.
  """
  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:name, name: :languages_name_index, message: "Only one Language")
  end
end

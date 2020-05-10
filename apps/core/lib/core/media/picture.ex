defmodule Core.Media.Picture do
  @moduledoc """
  Represents a picture entity.
  """

  use Core.Model

  import Ecto.Changeset, only: [
    cast: 3,
    cast_embed: 2,
    validate_required: 2,
    foreign_key_constraint: 3,
    unique_constraint: 3
  ]

  alias Core.{
    Accounts.Profile,
    Media.File
  }

  @type t :: %__MODULE__{
    file: File.t(),
    profile: Profile.t()
  }

  @allowed_params ~w(
    profile_id
  )a

  @required_params ~w(
    profile_id
  )a

  schema "pictures" do
    embeds_one(:file, File, on_replace: :update)

    belongs_to :profile, Profile,
      foreign_key: :profile_id,
      type: FlakeId.Ecto.CompatType,
      references: :user_id

    timestamps()
  end

  @doc """
  Create changeset for Picture.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = picture, attrs) do
    picture
    |> cast(attrs, @allowed_params)
    |> cast_embed(:file)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:profile_id, name: :pictures_profile_id_fkey, message: "Select the Profile")
    |> unique_constraint(:profile_id, name: :pictures_profile_id_index, message: "Only one an Profile Record")
  end
end

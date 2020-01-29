defmodule Core.Accounts.UserLanguage do
  @moduledoc """
  Schema for UserLanguage.
  """

  use Core.Model

  alias Core.Accounts.User
  alias Core.Localization.Language

  @allowed_params ~w(
    language_id
    user_id
  )a

  @required_params ~w(
    language_id
    user_id
  )a

  schema "user_languages" do
    belongs_to :languages, Language, foreign_key: :language_id,
      type: :binary_id, references: :id
    belongs_to :users, User, foreign_key: :user_id,
      type: :binary_id, references: :id

    timestamps()
  end

  @doc """
  Create changeset for UserLanguage.
  """
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:language_id, message: "Select the Language")
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:language, name: :user_languages_language_id_index, message: "Only one the Language")
    |> unique_constraint(:user, name: :user_languages_user_id_index, message: "Only one an User")
  end
end

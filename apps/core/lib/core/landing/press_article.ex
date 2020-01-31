defmodule Core.Landing.PressArticle do
  @moduledoc """
  Schema for PressArticles.
  """

  use Core.Model

  @type t :: %__MODULE__{
    author: String.t(),
    img_url: String.t(),
    preview_text: String.t(),
    title: String.t(),
    url: String.t()
  }

  @allowed_params ~w(
    author
    img_url
    preview_text
    title
    url
  )a

  @required_params ~w(
    author
    img_url
    preview_text
    title
    url
  )a

  schema "press_articles" do
    field :author, :string
    field :img_url, :string
    field :preview_text, :string
    field :title, :string
    field :url, :string

    timestamps()
  end

  @doc """
  Create changeset for PressArticle.
  """
  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end

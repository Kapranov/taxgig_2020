defmodule Core.Landing.PressArticle do
  @moduledoc """
  Schema for PressArticles.
  """

  use Core.Model

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
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end

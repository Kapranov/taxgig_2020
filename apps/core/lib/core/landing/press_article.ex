defmodule Core.Landing.PressArticle do
  @moduledoc """
  Schema for PressArticles.
  """

  use Core.Model

  @allowed_params ~w(
    title
    author
    preview_text
    url
  )

  @required_params ~w(
    title
    author
    preview_text
    url
  )

  schema "press_articles" do
    field :title, :string
    field :author, :string
    field :preview_text, :string
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

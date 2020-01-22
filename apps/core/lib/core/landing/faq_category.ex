defmodule Core.Landing.FaqCategory do
  @moduledoc """
  Schema for FaqCategories.
  """

  use Core.Model

  alias Core.Landing.Faq

  @allowed_params ~w(
    title
  )a

  @required_params ~w(
    title
  )a

  schema "faq_categories" do
    field :title, :string

    has_many :faqs, Faq

    timestamps()
  end

  @doc """
  Create changeset for FaqCategory.
  """
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end

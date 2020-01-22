defmodule Core.Landing.Faq do
  @moduledoc """
  Schema for Faqs.
  """

  use Core.Model

  alias Core.Landing.FaqCategory

  @allowed_params ~w(
    title
    content
  )

  @required_params ~w(
    title
    content
  )

  schema "faqs" do
    field :title, :string
    field :content, :string

    belongs_to :faq_category, FaqCategory

    timestamps()
  end

  @doc """
  Create changeset for Faq.
  """
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end

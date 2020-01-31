defmodule Core.Landing.Faq do
  @moduledoc """
  Schema for Faqs.
  """

  use Core.Model

  alias Core.Landing.FaqCategory

  @type t :: %__MODULE__{
    content: String.t(),
    faq_categories: FaqCategory.t(),
    title: String.t()
  }

  @allowed_params ~w(
    content
    faq_category_id
    title
  )a

  @required_params ~w(
    content
    faq_category_id
    title
  )a

  schema "faqs" do
    field :content, :string
    field :title, :string

    belongs_to :faq_categories, FaqCategory,
      foreign_key: :faq_category_id, type: :binary_id, references: :id

    timestamps()
  end

  @doc """
  Create changeset for Faq.
  """
  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:faq_category_id, message: "Select the Faq Category")
  end
end

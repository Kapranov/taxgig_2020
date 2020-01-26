defmodule Core.Landing.Faq do
  @moduledoc """
  Schema for Faqs.
  """

  use Core.Model

  alias Core.Landing
  alias Core.Landing.FaqCategory

  @allowed_params ~w(
    content
    faq_category_id
    faqs_count
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
    field :faqs_count, :integer, virtual: true

    belongs_to :faq_categories, FaqCategory,
      foreign_key: :faq_category_id, type: :binary_id, references: :id

    timestamps()
  end

  @doc """
  Create changeset for Faq.
  """
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:faq_category_id, message: "Select the Faq Category")
    |> build_count()
  end

  defp build_count(changeset) do
    faqs_count = get_field(changeset, :faqs_count)

    count =
      changeset
      |> Map.get(:faq_category_id)
      |> Landing.count()

    if is_nil(faqs_count) do
      put_change(changeset, :faqs_count, count)
    else
      changeset
    end
  end
end

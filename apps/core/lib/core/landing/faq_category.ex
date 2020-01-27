defmodule Core.Landing.FaqCategory do
  @moduledoc """
  Schema for FaqCategories.
  """

  use Core.Model

  alias Core.Landing
  alias Core.Landing.Faq

  @allowed_params ~w(
    title
  )a

  @required_params ~w(
    title
    faqs_count
  )a

  schema "faq_categories" do
    field :title, :string
    field :faqs_count, :integer, virtual: true, default: 0

    has_many :faqs, Faq, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Create changeset for FaqCategory.
  """
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> build_count()
    |> validate_required(@required_params)
    |> unique_constraint(:title)
  end

  def build_count(changeset) do
    count =
      get_field(changeset, :title)
      |> Landing.count_title()

    put_change(changeset, :faqs_count, count)
  end
end

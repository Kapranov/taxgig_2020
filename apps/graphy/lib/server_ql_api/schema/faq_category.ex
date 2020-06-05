defmodule ServerQLApi.Schema.FaqCategory do
  use CommonGraphQLClient.Schema

  api_schema do
    field :id, :string
    field :title, :string
    field :faqs_count, :integer, virtual: true, default: 0

    embeds_many :faqs, Faq do
      field :content, :string
      field :title, :string
    end
  end

  @cast_params ~w(id title faqs_count)a

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @cast_params)
    |> cast_embed(:faqs, with: &faq_changeset/2)
  end

  defp faq_changeset(struct, attrs) do
    struct
    |> cast(attrs, [:id, :content, :title])
  end
end

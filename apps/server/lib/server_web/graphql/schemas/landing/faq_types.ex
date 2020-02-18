defmodule ServerWeb.GraphQL.Schemas.Landing.FaqTypes do
  @moduledoc """
  The Faq GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Landing.FaqResolver
  }

  @desc "A faq on the site"
  object :faq do
    field :id, non_null(:string), description: "faq id"
    field :content, non_null(:string), description: "faq content"
    field :title, non_null(:string), description: "faq title"
    field :faq_categories, :faq_category, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :updated_at, non_null(:datetime)
  end

  @desc "The faq update via params"
  input_object :update_faq_params do
    field :content, :string
    field :title, :string
    field :faq_category_id, non_null(:string)
  end

  object :faq_queries do
    @desc "Get all faqs"
    field :all_faqs, list_of(:faq) do
      resolve(&FaqResolver.list/3)
    end

    @desc "Get a specific faq"
    field :show_faq, :faq do
      arg(:id, non_null(:string))
      resolve(&FaqResolver.show/3)
    end

    @desc "Search title by faqs"
    field :search_titles, list_of(:faq) do
      arg(:title, non_null(:string))
      resolve(&FaqResolver.search_titles/3)
    end
  end

  object :faq_mutations do
    @desc "Create the Faq"
    field :create_faq, :faq do
      arg :content, :string
      arg :title, :string
      arg :faq_category_id, non_null(:string)
      resolve &FaqResolver.create/3
    end

    @desc "Update a specific faq"
    field :update_faq, :faq do
      arg :id, non_null(:string)
      arg :faq, :update_faq_params
      resolve &FaqResolver.update/3
    end

    @desc "Delete a specific the faq"
    field :delete_faq, :faq do
      arg :id, non_null(:string)
      resolve &FaqResolver.delete/3
    end
  end

  object :faq_subscriptions do
    @desc "Create the Faq via Channel"
    field :faq_created, :faq do
      config(fn _, _ ->
        {:ok, topic: "faqs"}
      end)

      trigger(:create_faq,
        topic: fn _ ->
          "faqs"
        end
      )
    end
  end
end

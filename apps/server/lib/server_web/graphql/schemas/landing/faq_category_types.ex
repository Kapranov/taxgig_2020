defmodule ServerWeb.GraphQL.Schemas.Landing.FaqCategoryTypes do
  @moduledoc """
  The FaqCategory GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Landing.FaqCategoryResolver

  @desc "A faq category on the site"
  object :faq_category do
    field :id, non_null(:string), description: "faq category id"
    field :title, non_null(:string), description: "faq category title"
  end

  @desc "The faq category update via params"
  input_object :update_faq_category_params do
    field :title, :string
  end

  object :faq_category_queries do
    @desc "Get all faq categories"
    field :faq_categories, list_of(:faq_category) do
      resolve(&FaqCategoryResolver.list/3)
    end

    @desc "Get a specific faq category"
    field :faq_category, :faq_category do
      arg(:id, non_null(:string))
      resolve(&FaqCategoryResolver.show/3)
    end
  end

  object :faq_category_mutations do
    @desc "Create the Faq Category"
    field :create_faq_category, :faq_category do
      arg :title, :string
      resolve &FaqCategoryResolver.create/3
    end

    @desc "Update a specific faq category"
    field :update_faq_category, :faq_category do
      arg :id, non_null(:string)
      arg :faq_category, :update_faq_category_params
      resolve &FaqCategoryResolver.update/3
    end

    @desc "Delete a specific the faq category"
    field :delete_faq_category, :faq_category do
      arg :id, non_null(:string)
      resolve &FaqCategoryResolver.delete/3
    end
  end

  object :faq_category_subscriptions do
    @desc "Create the Faq Category via Channel"
    field :faq_category_created, :faq_category do
      config(fn _, _ ->
        {:ok, topic: "faq_categories"}
      end)

      trigger(:create_faq_category,
        topic: fn _ ->
          "faq_categories"
        end
      )
    end
  end
end

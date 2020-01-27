defmodule ServerWeb.GraphQL.Schemas.Landing.FaqCategoryTypes do
  @moduledoc """
  The FaqCategory GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Landing.FaqCategoryResolver

  @desc "A faq category on the site"
  object :faq_category, description: "Faq Category" do
    field :id, non_null(:string), description: "unique identifier"
    field :title, non_null(:string), description: "faq category title"
    field :faqs_count, :integer, description: "count total used faqs for this category"
    field :inserted_at, non_null(:datetime), description: "Created at"
    field :updated_at, non_null(:datetime), description: "Last updated at"
  end

  @desc "The faq category update via params"
  input_object :update_faq_category_params, description: "create faq category" do
    field :title, non_null(:string), description: "Required title name"
  end

  object :faq_category_queries do
    @desc "Get all faq categories"
    field :all_faq_categories, list_of(:faq_category) do
      resolve(&FaqCategoryResolver.list/3)
    end

    @desc "Get a specific faq category"
    field :show_faq_category, :faq_category do
      arg(:id, non_null(:string))
      resolve(&FaqCategoryResolver.show/3)
    end
  end

  object :faq_category_mutations do
    @desc "Create the Faq Category"
    field :create_faq_category, :faq_category, description: "Create a new faq category" do
      arg :title, non_null(:string)
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

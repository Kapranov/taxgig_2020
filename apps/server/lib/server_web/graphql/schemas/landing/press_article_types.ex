defmodule ServerWeb.GraphQL.Schemas.Landing.PressArticleTypes do
  @moduledoc """
  The PressArticle GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Landing.PressArticleResolver

  @desc "The press article on the site"
  object :press_article do
    field :id, non_null(:string), description: "press article id"
    field :author, :string, description: "press article author"
    field :img_url, :string, description: "press article image_url"
    field :preview_text, :string, description: "press article preview_text"
    field :title, :string, description: "press article title"
    field :url, :string, description: "press article url"
  end

  @desc "The press article update via params"
  input_object :update_press_article_params do
    field :author, :string
    field :img_url, :string
    field :preview_text, :string
    field :title, :string
    field :url, :string
  end

  object :press_article_queries do
    @desc "Get all press articles"
    field :all_press_articles, list_of(:press_article) do
      resolve(&PressArticleResolver.list/3)
    end

    @desc "Get a specific press article"
    field :show_press_article, :press_article do
      arg(:id, non_null(:string))
      resolve(&PressArticleResolver.show/3)
    end
  end

  object :press_article_mutations do
    @desc "Create the Press Article"
    field :create_press_article, :press_article do
      arg :author, :string
      arg :img_url, :string
      arg :preview_text, :string
      arg :title, :string
      arg :url, :string
      resolve &PressArticleResolver.create/3
    end

    @desc "Update a specific press article"
    field :update_press_article, :press_article do
      arg :id, non_null(:string)
      arg :press_article, :update_press_article_params
      resolve &PressArticleResolver.update/3
    end

    @desc "Delete a specific the press article"
    field :delete_press_article, :press_article do
      arg :id, non_null(:string)
      resolve &PressArticleResolver.delete/3
    end
  end

  object :press_article_subscriptions do
    @desc "Create the Press Article via Channel"
    field :press_article_created, :press_article do
      config(fn _, _ ->
        {:ok, topic: "press_articles"}
      end)

      trigger(:create_press_article,
        topic: fn _ ->
          "press_articles"
        end
      )
    end
  end
end

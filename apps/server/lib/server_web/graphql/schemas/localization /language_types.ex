defmodule ServerWeb.GraphQL.Schemas.Localization.LanguageTypes do
  @moduledoc """
  The Language GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Localization.LanguageResolver

  @desc "The language on the site"
  object :language do
    field :id, :string, description: "language id"
    field :abbr, :string, description: "language abbr"
    field :name, :string, description: "language name"
    field :inserted_at, :datetime
    field :updated_at, :datetime
  end

  @desc "The language update via params"
  input_object :update_language_params do
    field :abbr, :string
    field :name, :string
  end

  object :language_queries do
    @desc "Get all languages"
    field :all_languages, list_of(:language) do
      resolve(&LanguageResolver.list/3)
    end

    @desc "Get a specific language"
    field :show_language, :language do
      arg(:id, non_null(:string))
      resolve(&LanguageResolver.show/3)
    end
  end

  object :language_mutations do
    @desc "Create the Language"
    field :create_language, :language do
      arg :abbr, :string
      arg :name, :string
      resolve &LanguageResolver.create/3
    end

    @desc "Update a specific language"
    field :update_language, :language do
      arg :id, non_null(:string)
      arg :language, :update_language_params
      resolve &LanguageResolver.update/3
    end

    @desc "Delete a specific the language"
    field :delete_language, :language do
      arg :id, non_null(:string)
      resolve &LanguageResolver.delete/3
    end
  end

  object :language_subscriptions do
    @desc "Create the Language via Channel"
    field :language_created, :language do
      config(fn _, _ ->
        {:ok, topic: "languages"}
      end)

      trigger(:create_language,
        topic: fn _ ->
          "languages"
        end
      )
    end
  end
end

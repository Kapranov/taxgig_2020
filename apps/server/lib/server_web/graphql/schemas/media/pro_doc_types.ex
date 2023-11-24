defmodule ServerWeb.GraphQL.Schemas.Media.ProDocTypes do
  @moduledoc """
  The Pro Docs GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Media.ProDocResolver
  }

  @desc "The pro docs on the site"
  object :pro_doc do
    field :category, :string
    field :error, :string
    field :error_description, :string
    field :file, :picture, description: "An upload's file"
    field :id, :string
    field :projects, :project, resolve: dataloader(Data)
    field :signature, :boolean
    field :signed_by_pro, :boolean
    field :users, :user, resolve: dataloader(Data)
  end

  @desc "The pro docs on the site after destroy"
  object :pro_doc_deleted do
    field :id, :string
  end

  @desc "The pro docs an update via params"
  input_object :update_pro_doc_params do
    field :signature, :boolean
    field :signed_by_pro, :boolean
  end

  @desc "The pro docs an update via params for tp"
  input_object :update_pro_doc_params_for_tp do
    field :signed_by_pro, :boolean
  end

  @desc "An attached picture or a link to a picture"
  input_object :picture_input do
    field(:picture, :picture_input_object)
  end

  @desc "An attached picture"
  input_object :picture_input_object do
    field(:file, non_null(:upload))
  end

  object :pro_doc_queries do
    @desc "Get all pro docs"
    field :all_pro_docs, list_of(:pro_doc) do
      resolve(&ProDocResolver.list/3)
    end

    @desc "Get a specific pro docs"
    field :show_pro_doc, :pro_doc do
      arg(:id, non_null(:string))
      resolve(&ProDocResolver.show/3)
    end
  end

  object :pro_doc_mutations do
    @desc "Create the pro docs"
    field :create_pro_doc, :pro_doc, description: "Create a new pro docs" do
      arg :category, non_null(:string)
      arg :file, :picture_input
      arg :project_id, non_null(:string)
      arg :signature, non_null(:boolean)
      arg :signed_by_pro, non_null(:boolean)
      resolve &ProDocResolver.create/3
    end

    @desc "Update a specific pro docs"
    field :update_pro_doc, :pro_doc do
      arg :id, non_null(:string)
      arg :file, :picture_input, description: "The file for the pro docs, either as an object or directly the ID of an existing Picture"
      arg :pro_doc, :update_pro_doc_params, description: "The params for pro docs, either as an object"
      resolve &ProDocResolver.update/3
    end

    @desc "Update a specific pro docs for tp"
    field :update_pro_doc_for_tp, :pro_doc do
      arg :id, non_null(:string)
      arg :file, :picture_input, description: "The file for the pro docs, either as an object or directly the ID of an existing Picture"
      arg :pro_doc, :update_pro_doc_params_for_tp, description: "The params for pro docs, either as an object for role tp"
      resolve &ProDocResolver.update_for_tp/3
    end

    @desc "Delete a specific pro docs"
    field :delete_pro_doc, :pro_doc_deleted do
      arg :id, non_null(:string)
      resolve &ProDocResolver.delete/3
    end
  end

  object :pro_doc_subscriptions do
    @desc "Create the pro docs via channel"
    field :pro_doc_created, :pro_doc do
      config(fn _, _ ->
        {:ok, topic: "pro_docs"}
      end)

      trigger(:create_pro_doc,
        topic: fn _ ->
          "pro_docs"
        end
      )
    end
  end
end

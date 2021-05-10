defmodule ServerWeb.GraphQL.Schemas.Media.TpDocTypes do
  @moduledoc """
  The Tp Docs GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Media.TpDocResolver
  }

  @desc "The tp docs on the site"
  object :tp_doc do
    field :access_granted, non_null(:boolean)
    field :category, non_null(:string)
    field :error, :string
    field :error_description, :string
    field :file, :picture, description: "An upload's file"
    field :id, non_null(:string)
    field :projects, :project, resolve: dataloader(Data)
    field :signed_by_tp, non_null(:boolean)
  end

  @desc "The tp docs an update via params"
  input_object :update_tp_doc_params do
    field :access_granted, :boolean
    field :category, :string
    field :project_id, :string
    field :signed_by_tp, :boolean
  end

  object :tp_doc_queries do
    @desc "Get all tp docs"
    field :all_tp_docs, list_of(:tp_doc) do
      resolve(&TpDocResolver.list/3)
    end

    @desc "Get a specific tp docs"
    field :show_tp_doc, :tp_doc do
      arg(:id, non_null(:string))
      resolve(&TpDocResolver.show/3)
    end
  end

  object :tp_doc_mutations do
    @desc "Create the tp docs"
    field :create_tp_doc, :tp_doc, description: "Create a new tp docs" do
      arg :access_granted, non_null(:boolean)
      arg :category, non_null(:string)
      arg :file, :picture_input
      arg :project_id, non_null(:string)
      arg :signed_by_tp, non_null(:boolean)
      resolve &TpDocResolver.create/3
    end

    @desc "Update a specific tp docs"
    field :update_tp_doc, :tp_doc do
      arg :id, non_null(:string)
      arg :file, :picture_input, description: "The file for the tp docs, either as an object or directly the ID of an existing Picture"
      arg :tp_doc, :update_tp_doc_params, description: "The params for tp docs, either as an object"
      resolve &TpDocResolver.update/3
    end

    @desc "Delete a specific tp docs"
    field :delete_tp_doc, :tp_doc do
      arg :id, non_null(:string)
      resolve &TpDocResolver.delete/3
    end
  end

  object :tp_doc_subscriptions do
    @desc "Create the tp docs via channel"
    field :tp_doc_created, :tp_doc do
      config(fn _, _ ->
        {:ok, topic: "tp_docs"}
      end)

      trigger(:create_tp_doc,
        topic: fn _ ->
          "tp_docs"
        end
      )
    end
  end
end

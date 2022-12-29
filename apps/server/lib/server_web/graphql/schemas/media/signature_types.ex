defmodule ServerWeb.GraphQL.Schemas.Media.SignatureTypes do
  @moduledoc """
  The Signatures GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Media.SignatureResolver
  }

  @desc "The signatures on the site"
  object :signature do
    field :id, non_null(:string)
    field :altitude, non_null(:decimal)
    field :longitude, non_null(:decimal)
    field :pro_docs, :pro_doc, resolve: dataloader(Data)
  end

  @desc "The signature update via params"
  input_object :update_signature_params, description: "update the signature" do
    field :altitude, :decimal
    field :longitude, :decimal
    field :pro_doc_id, :string
  end

  object :signature_queries do
    @desc "Get all signature by ProDocId"
    field :all_signature_by_pro_doc, list_of(:signature) do
      arg :pro_doc_id, non_null(:string)
      resolve(&SignatureResolver.list/3)
    end
  end

  object :signature_mutations do
    @desc "Create the Signature"
    field :create_signature, :signature do
      arg :altitude, non_null(:decimal)
      arg :longitude, non_null(:decimal)
      arg :pro_doc_id, non_null(:string)
      resolve &SignatureResolver.create/3
    end

    @desc "Update a specific signature"
    field :update_signature, :signature do
      arg :id, non_null(:string)
      arg :signature, :update_signature_params
      resolve &SignatureResolver.update/3
    end

    @desc "Delete a specific the signature"
    field :delete_signature, :signature do
      arg :id, non_null(:string)
      resolve &SignatureResolver.delete/3
    end
  end
end

defmodule ServerWeb.GraphQL.Schemas.Products.BookKeepingTransactionVolumeTypes do
  @moduledoc """
  The BookKeepingTransactionVolume GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.BookKeepingTransactionVolumesResolver
  }

  @desc "The list book keeping transaction volumes"
  object :book_keeping_transaction_volume do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :price, :integer
    field :updated_at, non_null(:datetime)
  end

  @desc "The list book keeping transaction volumes via role's Tp"
  object :tp_book_keeping_transaction_volume do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :updated_at, non_null(:datetime)
  end

  @desc "The list book_keeping transaction volumes via role's Pro"
  object :pro_book_keeping_transaction_volume do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :price, :integer
    field :updated_at, non_null(:datetime)
  end

  @desc "The book keeping transaction volume update via params"
  input_object :update_book_keeping_transaction_volume_params do
    field :book_keeping_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  @desc "The book keeping transaction volume via role's Tp update with params"
  input_object :update_tp_book_keeping_transaction_volume_params do
    field :book_keeping_id, non_null(:string)
    field :name, :string
  end

  @desc "The book keeping transaction volume via role's Pro update with params"
  input_object :update_pro_book_keeping_transaction_volume_params do
    field :book_keeping_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  object :book_keeping_transaction_volume_queries do
    @desc "Get all book keeping transaction volumes"
    field(:all_book_keeping_transaction_volumes, non_null(list_of(non_null(:book_keeping_transaction_volume)))) do
      resolve &BookKeepingTransactionVolumesResolver.list/3
    end

    @desc "Get all book keeping transaction volumes via role's Tp"
    field(:all_tp_book_keeping_transaction_volumes,
      non_null(list_of(non_null(:tp_book_keeping_transaction_volume)))) do
        resolve &BookKeepingTransactionVolumesResolver.list/3
    end

    @desc "Get all book keeping transaction volumes via role's Pro"
    field(:all_pro_book_keeping_transaction_volumes,
      non_null(list_of(non_null(:pro_book_keeping_transaction_volume)))) do
        resolve &BookKeepingTransactionVolumesResolver.list/3
    end

    @desc "Get a specific book keeping transaction volume"
    field(:show_book_keeping_transaction_volume, non_null(:book_keeping_transaction_volume)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingTransactionVolumesResolver.show/3)
    end

    @desc "Get a specific book keeping transaction volume via role's Tp"
    field(:show_tp_book_keeping_transaction_volume, non_null(:tp_book_keeping_transaction_volume)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingTransactionVolumesResolver.show/3)
    end

    @desc "Get a specific book keeping transaction volume via role's Pro"
    field(:show_pro_book_keeping_transaction_volume, non_null(:pro_book_keeping_transaction_volume)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingTransactionVolumesResolver.show/3)
    end

    @desc "Find the book keeping transaction volume by id"
    field :find_book_keeping_transaction_volume, :book_keeping_transaction_volume do
      arg(:id, non_null(:string))

      resolve &BookKeepingTransactionVolumesResolver.find/3
    end

    @desc "Find the book keeping transaction volume by id via role's Tp"
    field :find_tp_book_keeping_transaction_volume, :tp_book_keeping_transaction_volume do
      arg(:id, non_null(:string))

      resolve &BookKeepingTransactionVolumesResolver.find/3
    end

    @desc "Find the book keeping transaction volume by id via role's Pro"
    field :find_pro_book_keeping_transaction_volume, :pro_book_keeping_transaction_volume do
      arg(:id, non_null(:string))

      resolve &BookKeepingTransactionVolumesResolver.find/3
    end
  end

  object :book_keeping_transaction_volume_mutations do
    @desc "Create the book keeping transaction volume"
    field :create_book_keeping_transaction_volume, :book_keeping_transaction_volume do
      arg :book_keeping_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &BookKeepingTransactionVolumesResolver.create/3
    end

    @desc "Create the book keeping transaction volume via role's Tp"
    field :create_tp_book_keeping_transaction_volume, :tp_book_keeping_transaction_volume do
      arg :book_keeping_id, non_null(:string)
      arg :name, :string

      resolve &BookKeepingTransactionVolumesResolver.create/3
    end

    @desc "Create the book keeping transaction volume via role's Pro"
    field :create_pro_book_keeping_transaction_volume, :pro_book_keeping_transaction_volume do
      arg :book_keeping_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &BookKeepingTransactionVolumesResolver.create/3
    end

    @desc "Update a specific the book keeping transaction volume"
    field :update_book_keeping_transaction_volume, :book_keeping_transaction_volume do
      arg :id, non_null(:string)
      arg :book_keeping_transaction_volume, :update_book_keeping_transaction_volume_params

      resolve &BookKeepingTransactionVolumesResolver.update/3
    end

    @desc "Update a specific the book keeping transaction volume via role's Tp"
    field :update_tp_book_keeping_transaction_volume, :tp_book_keeping_transaction_volume do
      arg :id, non_null(:string)
      arg :book_keeping_transaction_volume, :update_tp_book_keeping_transaction_volume_params

      resolve &BookKeepingTransactionVolumesResolver.update/3
    end

    @desc "Update a specific the book keeping transaction volume via role's Pro"
    field :update_pro_book_keeping_transaction_volume, :pro_book_keeping_transaction_volume do
      arg :id, non_null(:string)
      arg :book_keeping_transaction_volume, :update_pro_book_keeping_transaction_volume_params

      resolve &BookKeepingTransactionVolumesResolver.update/3
    end

    @desc "Delete a specific the book keeping transaction volume"
    field :delete_book_keeping_transaction_volume, :book_keeping_transaction_volume do
      arg :id, non_null(:string)

      resolve &BookKeepingTransactionVolumesResolver.delete/3
    end
  end
end

defmodule ServerWeb.GraphQL.Schemas.Products.BookKeepingClassifyInventoryTypes do
  @moduledoc """
  The BookKeepingClassifyInventory GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.BookKeepingClassifyInventoriesResolver
  }

  @desc "The list book keeping classify inventories"
  object :book_keeping_classify_inventory do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :name, list_of(:string)
  end

  @desc "The list book keeping classify inventories via role's Tp"
  object :tp_book_keeping_classify_inventory do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :name, :string
  end

  @desc "The book keeping classify inventory update via params"
  input_object :update_book_keeping_classify_inventory_params do
    field :book_keeping_id, non_null(:string)
    field :name, list_of(:string)
  end

  @desc "The book keeping classify inventory via role's Tp update with params"
  input_object :update_tp_book_keeping_classify_inventory_params do
    field :book_keeping_id, non_null(:string)
    field :name, :string
  end

  object :book_keeping_classify_inventory_queries do
    @desc "Get all book keeping classify inventories"
    field(:all_book_keeping_classify_inventories, non_null(list_of(non_null(:book_keeping_classify_inventory)))) do
      resolve &BookKeepingClassifyInventoriesResolver.list/3
    end

    @desc "Get all book keeping classify inventories via role's Tp"
    field(:all_tp_book_keeping_classify_inventories,
      non_null(list_of(non_null(:tp_book_keeping_classify_inventory)))) do
        resolve &BookKeepingClassifyInventoriesResolver.list/3
    end

    @desc "Get a specific book keeping classify inventory"
    field(:show_book_keeping_classify_inventory, non_null(:book_keeping_classify_inventory)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingClassifyInventoriesResolver.show/3)
    end

    @desc "Get a specific book keeping classify inventory via role's Tp"
    field(:show_tp_book_keeping_classify_inventory, non_null(:tp_book_keeping_classify_inventory)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingClassifyInventoriesResolver.show/3)
    end

    @desc "Find the book keeping classify inventory by id"
    field :find_book_keeping_classify_inventory, :book_keeping_classify_inventory do
      arg(:id, non_null(:string))

      resolve &BookKeepingClassifyInventoriesResolver.find/3
    end

    @desc "Find the book keeping classify inventory by id via role's Tp"
    field :find_tp_book_keeping_classify_inventory, :tp_book_keeping_classify_inventory do
      arg(:id, non_null(:string))

      resolve &BookKeepingClassifyInventoriesResolver.find/3
    end
  end

  object :book_keeping_classify_inventory_mutations do
    @desc "Create the book keeping classify inventory"
    field :create_book_keeping_classify_inventory, :book_keeping_classify_inventory do
      arg :book_keeping_id, non_null(:string)
      arg :name, list_of(:string)

      resolve &BookKeepingClassifyInventoriesResolver.create/3
    end

    @desc "Create the book keeping classify inventory via role's Tp"
    field :create_tp_book_keeping_classify_inventory, :tp_book_keeping_classify_inventory do
      arg :book_keeping_id, non_null(:string)
      arg :name, :string

      resolve &BookKeepingClassifyInventoriesResolver.create/3
    end

    @desc "Update a specific the book keeping classify inventory"
    field :update_book_keeping_classify_inventory, :book_keeping_classify_inventory do
      arg :id, non_null(:string)
      arg :book_keeping_classify_inventory, :update_book_keeping_classify_inventory_params

      resolve &BookKeepingClassifyInventoriesResolver.update/3
    end

    @desc "Update a specific the book keeping classify inventory via role's Tp"
    field :update_tp_book_keeping_classify_inventory, :tp_book_keeping_classify_inventory do
      arg :id, non_null(:string)
      arg :book_keeping_classify_inventory, :update_tp_book_keeping_classify_inventory_params

      resolve &BookKeepingClassifyInventoriesResolver.update/3
    end

    @desc "Delete a specific the book keeping classify inventory"
    field :delete_book_keeping_classify_inventory, :book_keeping_classify_inventory do
      arg :id, non_null(:string)

      resolve &BookKeepingClassifyInventoriesResolver.delete/3
    end
  end
end

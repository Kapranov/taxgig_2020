defmodule ServerWeb.GraphQL.Schemas.Products.BookKeepingAdditionalNeedTypes do
  @moduledoc """
  The BookKeepingAdditionalNeed GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.BookKeepingAdditionalNeedsResolver
  }

  @desc "The list book keeping additional needs"
  object :book_keeping_additional_need do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :price, :integer
    field :updated_at, non_null(:datetime)
  end

  @desc "The list book keeping additional needs via role's Tp"
  object :tp_book_keeping_additional_need do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :updated_at, non_null(:datetime)
  end

  @desc "The list book_keeping additional needs via role's Pro"
  object :pro_book_keeping_additional_need do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :price, :integer
    field :updated_at, non_null(:datetime)
  end

  @desc "The book keeping additional need update via params"
  input_object :update_book_keeping_additional_need_params do
    field :book_keeping_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  @desc "The book keeping additional need via role's Tp update with params"
  input_object :update_tp_book_keeping_additional_need_params do
    field :book_keeping_id, non_null(:string)
    field :name, :string
  end

  @desc "The book keeping additional need via role's Pro update with params"
  input_object :update_pro_book_keeping_additional_need_params do
    field :book_keeping_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  object :book_keeping_additional_need_queries do
    @desc "Get all book keeping additional needs"
    field(:all_book_keeping_additional_needs,
      non_null(list_of(non_null(:book_keeping_additional_need)))) do
        resolve &BookKeepingAdditionalNeedsResolver.list/3
    end

    @desc "Get all book keeping additional needs via role's Tp"
    field(:all_tp_book_keeping_additional_needs,
      non_null(list_of(non_null(:tp_book_keeping_additional_need)))) do
        resolve &BookKeepingAdditionalNeedsResolver.list/3
    end

    @desc "Get all book keeping additional needs via role's Pro"
    field(:all_pro_book_keeping_additional_needs,
      non_null(list_of(non_null(:pro_book_keeping_additional_need)))) do
        resolve &BookKeepingAdditionalNeedsResolver.list/3
    end

    @desc "Get a specific book keeping additional need"
    field(:show_book_keeping_additional_need, non_null(:book_keeping_additional_need)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingAdditionalNeedsResolver.show/3)
    end

    @desc "Get a specific book keeping additional need via role's Tp"
    field(:show_tp_book_keeping_additional_need, non_null(:tp_book_keeping_additional_need)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingAdditionalNeedsResolver.show/3)
    end

    @desc "Get a specific book keeping additional need via role's Pro"
    field(:show_pro_book_keeping_additional_need, non_null(:pro_book_keeping_additional_need)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingAdditionalNeedsResolver.show/3)
    end

    @desc "Find the book keeping additional need by id"
    field :find_book_keeping_additional_need, :book_keeping_additional_need do
      arg(:id, non_null(:string))

      resolve &BookKeepingAdditionalNeedsResolver.find/3
    end

    @desc "Find the book keeping additional need by id via role's Tp"
    field :find_tp_book_keeping_additional_need, :tp_book_keeping_additional_need do
      arg(:id, non_null(:string))

      resolve &BookKeepingAdditionalNeedsResolver.find/3
    end

    @desc "Find the book keeping additional need by id via role's Pro"
    field :find_pro_book_keeping_additional_need, :pro_book_keeping_additional_need do
      arg(:id, non_null(:string))

      resolve &BookKeepingAdditionalNeedsResolver.find/3
    end
  end

  object :book_keeping_additional_need_mutations do
    @desc "Create the book keeping additional need"
    field :create_book_keeping_additional_need, :book_keeping_additional_need do
      arg :book_keeping_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &BookKeepingAdditionalNeedsResolver.create/3
    end

    @desc "Create the book keeping additional need via role's Tp"
    field :create_tp_book_keeping_additional_need, :tp_book_keeping_additional_need do
      arg :book_keeping_id, non_null(:string)
      arg :name, :string

      resolve &BookKeepingAdditionalNeedsResolver.create/3
    end

    @desc "Create the book keeping additional need via role's Pro"
    field :create_pro_book_keeping_additional_need, :pro_book_keeping_additional_need do
      arg :book_keeping_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &BookKeepingAdditionalNeedsResolver.create/3
    end

    @desc "Update a specific the book keeping additional need"
    field :update_book_keeping_additional_need, :book_keeping_additional_need do
      arg :id, non_null(:string)
      arg :book_keeping_additional_need, :update_book_keeping_additional_need_params

      resolve &BookKeepingAdditionalNeedsResolver.update/3
    end

    @desc "Update a specific the book keeping additional need via role's Tp"
    field :update_tp_book_keeping_additional_need, :tp_book_keeping_additional_need do
      arg :id, non_null(:string)
      arg :book_keeping_additional_need, :update_tp_book_keeping_additional_need_params

      resolve &BookKeepingAdditionalNeedsResolver.update/3
    end

    @desc "Update a specific the book keeping additional need via role's Pro"
    field :update_pro_book_keeping_additional_need, :pro_book_keeping_additional_need do
      arg :id, non_null(:string)
      arg :book_keeping_additional_need, :update_pro_book_keeping_additional_need_params

      resolve &BookKeepingAdditionalNeedsResolver.update/3
    end

    @desc "Delete a specific the book keeping additional need"
    field :delete_book_keeping_additional_need, :book_keeping_additional_need do
      arg :id, non_null(:string)

      resolve &BookKeepingAdditionalNeedsResolver.delete/3
    end
  end
end

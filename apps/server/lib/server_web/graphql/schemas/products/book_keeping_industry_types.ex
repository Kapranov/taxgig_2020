defmodule ServerWeb.GraphQL.Schemas.Products.BookKeepingIndustryTypes do
  @moduledoc """
  The BookKeepingIndustry GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.BookKeepingIndustriesResolver
  }

  @desc "The list book keeping industries"
  object :book_keeping_industry do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, list_of(:string)
    field :updated_at, non_null(:datetime)
  end

  @desc "The list book keeping industries via role's Tp"
  object :tp_book_keeping_industry do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, list_of(:string)
    field :updated_at, non_null(:datetime)
  end

  @desc "The list book_keeping industries via role's Pro"
  object :pro_book_keeping_industry do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, list_of(:string)
    field :updated_at, non_null(:datetime)
  end

  @desc "The book keeping industry update via params"
  input_object :update_book_keeping_industry_params do
    field :book_keeping_id, non_null(:string)
    field :name, list_of(:string)
  end

  @desc "The book keeping industry via role's Tp update with params"
  input_object :update_tp_book_keeping_industry_params do
    field :book_keeping_id, non_null(:string)
    field :name, list_of(:string)
  end

  @desc "The book keeping industry via role's Pro update with params"
  input_object :update_pro_book_keeping_industry_params do
    field :book_keeping_id, non_null(:string)
    field :name, list_of(:string)
  end

  object :book_keeping_industry_queries do
    @desc "Get all book keeping industries"
    field(:all_book_keeping_industries, non_null(list_of(non_null(:book_keeping_industry)))) do
      resolve &BookKeepingIndustriesResolver.list/3
    end

    @desc "Get all book keeping industries via role's Tp"
    field(:all_tp_book_keeping_industries,
      non_null(list_of(non_null(:tp_book_keeping_industry)))) do
        resolve &BookKeepingIndustriesResolver.list/3
    end

    @desc "Get all book keeping industries via role's Pro"
    field(:all_pro_book_keeping_industries,
      non_null(list_of(non_null(:pro_book_keeping_industry)))) do
        resolve &BookKeepingIndustriesResolver.list/3
    end

    @desc "Get a specific book keeping industry"
    field(:show_book_keeping_industry, non_null(:book_keeping_industry)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingIndustriesResolver.show/3)
    end

    @desc "Get a specific book keeping industry via role's Tp"
    field(:show_tp_book_keeping_industry, non_null(:tp_book_keeping_industry)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingIndustriesResolver.show/3)
    end

    @desc "Get a specific book keeping industry via role's Pro"
    field(:show_pro_book_keeping_industry, non_null(:pro_book_keeping_industry)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingIndustriesResolver.show/3)
    end

    @desc "Find the book keeping industry by id"
    field :find_book_keeping_industry, :book_keeping_industry do
      arg(:id, non_null(:string))

      resolve &BookKeepingIndustriesResolver.find/3
    end

    @desc "Find the book keeping industry by id via role's Tp"
    field :find_tp_book_keeping_industry, :tp_book_keeping_industry do
      arg(:id, non_null(:string))

      resolve &BookKeepingIndustriesResolver.find/3
    end

    @desc "Find the book keeping industry by id via role's Pro"
    field :find_pro_book_keeping_industry, :pro_book_keeping_industry do
      arg(:id, non_null(:string))

      resolve &BookKeepingIndustriesResolver.find/3
    end
  end

  object :book_keeping_industry_mutations do
    @desc "Create the book keeping industry"
    field :create_book_keeping_industry, :book_keeping_industry do
      arg :book_keeping_id, non_null(:string)
      arg :name, list_of(:string)

      resolve &BookKeepingIndustriesResolver.create/3
    end

    @desc "Create the book keeping industry via role's Tp"
    field :create_tp_book_keeping_industry, :tp_book_keeping_industry do
      arg :book_keeping_id, non_null(:string)
      arg :name, list_of(:string)

      resolve &BookKeepingIndustriesResolver.create/3
    end

    @desc "Create the book keeping industry via role's Pro"
    field :create_pro_book_keeping_industry, :pro_book_keeping_industry do
      arg :book_keeping_id, non_null(:string)
      arg :name, list_of(:string)

      resolve &BookKeepingIndustriesResolver.create/3
    end

    @desc "Update a specific the book keeping industry"
    field :update_book_keeping_industry, :book_keeping_industry do
      arg :id, non_null(:string)
      arg :book_keeping_industry, :update_book_keeping_industry_params

      resolve &BookKeepingIndustriesResolver.update/3
    end

    @desc "Update a specific the book keeping industry via role's Tp"
    field :update_tp_book_keeping_industry, :tp_book_keeping_industry do
      arg :id, non_null(:string)
      arg :book_keeping_industry, :update_tp_book_keeping_industry_params

      resolve &BookKeepingIndustriesResolver.update/3
    end

    @desc "Update a specific the book keeping industry via role's Pro"
    field :update_pro_book_keeping_industry, :pro_book_keeping_industry do
      arg :id, non_null(:string)
      arg :book_keeping_industry, :update_pro_book_keeping_industry_params

      resolve &BookKeepingIndustriesResolver.update/3
    end

    @desc "Delete a specific the book keeping industry"
    field :delete_book_keeping_industry, :book_keeping_industry do
      arg :id, non_null(:string)

      resolve &BookKeepingIndustriesResolver.delete/3
    end
  end
end

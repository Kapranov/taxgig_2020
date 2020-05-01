defmodule ServerWeb.GraphQL.Schemas.Products.BookKeepingTypeClientTypes do
  @moduledoc """
  The BookKeepingTypeClient GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.BookKeepingTypeClientsResolver
  }

  @desc "The list book keeping type clients"
  object :book_keeping_type_client do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :price, :integer
    field :updated_at, non_null(:datetime)
  end

  @desc "The list book keeping type clients via role's Tp"
  object :tp_book_keeping_type_client do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :updated_at, non_null(:datetime)
  end

  @desc "The list book keeping type clients via role's Pro"
  object :pro_book_keeping_type_client do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :price, :integer
    field :updated_at, non_null(:datetime)
  end

  @desc "The book keeping type client update via params"
  input_object :update_book_keeping_type_client_params do
    field :book_keeping_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  @desc "The book keeping type client via role's Tp update with params"
  input_object :update_tp_book_keeping_type_client_params do
    field :book_keeping_id, non_null(:string)
    field :name, :string
  end

  @desc "The book keeping type client via role's Pro update with params"
  input_object :update_pro_book_keeping_type_client_params do
    field :book_keeping_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  object :book_keeping_type_client_queries do
    @desc "Get all book keeping type clients"
    field(:all_book_keeping_type_clients, non_null(list_of(non_null(:book_keeping_type_client)))) do
      resolve &BookKeepingTypeClientsResolver.list/3
    end

    @desc "Get all book keeping type clients via role's Tp"
    field(:all_tp_book_keeping_type_clients,
      non_null(list_of(non_null(:tp_book_keeping_type_client)))) do
        resolve &BookKeepingTypeClientsResolver.list/3
    end

    @desc "Get all book keeping type clients via role's Pro"
    field(:all_pro_book_keeping_type_clients,
      non_null(list_of(non_null(:pro_book_keeping_type_client)))) do
        resolve &BookKeepingTypeClientsResolver.list/3
    end

    @desc "Get a specific book keeping type client"
    field(:show_book_keeping_type_client, non_null(:book_keeping_type_client)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingTypeClientsResolver.show/3)
    end

    @desc "Get a specific book keeping type client via role's Tp"
    field(:show_tp_book_keeping_type_client, non_null(:tp_book_keeping_type_client)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingTypeClientsResolver.show/3)
    end

    @desc "Get a specific book keeping type client via role's Pro"
    field(:show_pro_book_keeping_type_client, non_null(:pro_book_keeping_type_client)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingTypeClientsResolver.show/3)
    end

    @desc "Find the book keeping type client by id"
    field :find_book_keeping_type_client, :book_keeping_type_client do
      arg(:id, non_null(:string))

      resolve &BookKeepingTypeClientsResolver.find/3
    end

    @desc "Find the book keeping type client by id via role's Tp"
    field :find_tp_book_keeping_type_client, :tp_book_keeping_type_client do
      arg(:id, non_null(:string))

      resolve &BookKeepingTypeClientsResolver.find/3
    end

    @desc "Find the book keeping type client by id via role's Pro"
    field :find_pro_book_keeping_type_client, :pro_book_keeping_type_client do
      arg(:id, non_null(:string))

      resolve &BookKeepingTypeClientsResolver.find/3
    end
  end

  object :book_keeping_type_client_mutations do
    @desc "Create the book keeping type client"
    field :create_book_keeping_type_client, :book_keeping_type_client do
      arg :book_keeping_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &BookKeepingTypeClientsResolver.create/3
    end

    @desc "Create the book keeping type client via role's Tp"
    field :create_tp_book_keeping_type_client, :tp_book_keeping_type_client do
      arg :book_keeping_id, non_null(:string)
      arg :name, :string

      resolve &BookKeepingTypeClientsResolver.create/3
    end

    @desc "Create the book keeping type client via role's Pro"
    field :create_pro_book_keeping_type_client, :pro_book_keeping_type_client do
      arg :book_keeping_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &BookKeepingTypeClientsResolver.create/3
    end

    @desc "Update a specific the book keeping type client"
    field :update_book_keeping_type_client, :book_keeping_type_client do
      arg :id, non_null(:string)
      arg :book_keeping_type_client, :update_book_keeping_type_client_params

      resolve &BookKeepingTypeClientsResolver.update/3
    end

    @desc "Update a specific the book keeping type client via role's Tp"
    field :update_tp_book_keeping_type_client, :tp_book_keeping_type_client do
      arg :id, non_null(:string)
      arg :book_keeping_type_client, :update_tp_book_keeping_type_client_params

      resolve &BookKeepingTypeClientsResolver.update/3
    end

    @desc "Update a specific the book keeping type client via role's Pro"
    field :update_pro_book_keeping_type_client, :pro_book_keeping_type_client do
      arg :id, non_null(:string)
      arg :book_keeping_type_client, :update_pro_book_keeping_type_client_params

      resolve &BookKeepingTypeClientsResolver.update/3
    end

    @desc "Delete a specific the book keeping type client"
    field :delete_book_keeping_type_client, :book_keeping_type_client do
      arg :id, non_null(:string)

      resolve &BookKeepingTypeClientsResolver.delete/3
    end
  end
end

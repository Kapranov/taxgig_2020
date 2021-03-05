defmodule ServerWeb.GraphQL.Schemas.Services.PtinTypes do
  @moduledoc """
  The Ptin GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Services.PtinResolver

  @desc "The Ptin of the site"
  object :ptin do
    field :id, :string
    field :bus_addr_zip, :string
    field :profession, :string
  end

  object :timestamp do
    field :path, :string
    field :error, :string
  end

  object :directory do
    field :ptin, :string
    field :error, :string
  end

  object :ptin_queries do
    @desc "Search a specific a ptin"
    field :search_profession, :ptin do
      arg :bus_addr_zip, non_null(:string)
      arg :first_name, non_null(:string)
      arg :last_name, non_null(:string)
      resolve &PtinResolver.search/3
    end
  end

  object :ptin_mutations do
    @desc "Create the ptin"
    field :create_ptin, :timestamp do
      arg :expired, non_null(:string)
      arg :url, non_null(:string)
      resolve &PtinResolver.create/3
    end

    @desc "Delete all ptin"
    field :delete_ptin, :directory do
      resolve &PtinResolver.delete/3
    end

    @desc "Delete timestamp directory"
    field :delete_dir, :timestamp do
      arg :date, non_null(:string)
      resolve &PtinResolver.delete_dir/3
    end
  end

  object :ptin_subscriptions do
    @desc "Create ptin via Channel"
    field :ptin_created, :ptin do
      config(fn _, _ ->
        {:ok, topic: "ptins"}
      end)

      trigger(:create_ptin,
        topic: fn _ ->
          "ptins"
        end
      )
    end
  end
end

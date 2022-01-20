defmodule ServerWeb.GraphQL.Schemas.Services.ReptinTypes do
  @moduledoc """
  The Reptin GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Services.ReptinResolver

  @desc "The Reptin of the site"
  object :reptin do
    field :id, :string
    field :bus_addr_zip, :string
    field :bus_st_code, :string
    field :error, :string
    field :first_name, :string
    field :last_name, :string
    field :profession, :string
  end

  object :reptin_timestamp do
    field :csv, :string
    field :dir, :string
    field :error, :string
    field :new, :string
    field :path, :string
    field :zip, :string
    field :new_zip, :string
  end

  object :reptin_directory do
    field :error, :string
    field :reptin, :string
  end

  object :reptin_queries do
    @desc "List diretories are timestamps"
    field :list_reptin, list_of(:string) do
      resolve &ReptinResolver.list/3
    end

    @desc "Search a specific a ptin"
    field :search_reptin, list_of(:reptin) do
      arg :bus_addr_zip, non_null(:string)
      arg :first_name, non_null(:string)
      arg :last_name, non_null(:string)
      resolve &ReptinResolver.search/3
    end
  end

  object :reptin_mutations do
    @desc "Create the reptin"
    field :create_reptin, :reptin_timestamp do
      arg :expired, non_null(:string)
      arg :url, non_null(:string)
      resolve &ReptinResolver.create/3
    end

    @desc "Drop database reptin"
    field :delete_reptin, :reptin_directory do
      resolve &ReptinResolver.delete/3
    end

    @desc "Delete timestamp directory"
    field :delete_dir, :reptin_timestamp do
      arg :date, non_null(:string)
      resolve &ReptinResolver.delete_dir/3
    end
  end

  object :reptin_subscriptions do
    @desc "Search reptin via Channel"
    field :reptin_search, list_of(:reptin) do
      config(fn _, _ ->
        {:ok, topic: ["reptins"]}
      end)

      trigger(:search_reptin,
        topic: fn _ ->
          "reptins"
        end
      )
    end
  end
end

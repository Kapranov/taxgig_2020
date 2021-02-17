defmodule ServerWeb.GraphQL.Schemas.Analyzes.AnalyzeTypes do
  @moduledoc """
  An analyze GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Analyzes.AnalyzeResolver

  @desc "The analyze on the site"
  object :analyze do
    field :id, non_null(:string), description: "service id"
    field :sum_value, :decimal
    field :sum_match, :integer
    field :sum_price, :integer
  end

  object :analyze_queries do
    @desc "Get an analyze specific service"
    field :show_analyze, list_of(:analyze) do
      arg(:service_id, non_null(:string))
      resolve(&AnalyzeResolver.show/3)
    end
  end

  object :analyze_subscriptions do
    @desc "Get an analyze information via Channel"
    field :analyze_show, :analyze do
      config(fn _, _ ->
        {:ok, topic: "analyzes"}
      end)

      trigger(:show_analyze,
        topic: fn _ ->
          "analyzes"
        end
      )
    end
  end
end

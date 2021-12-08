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

  object :sale_tax_for_tp do
    field :id, :string
    field :deadline, :string
    field :sale_tax_count, :integer
    field :state, list_of(:string)
    field :status, :string
    field :sale_tax_frequency, :sale_tax_frequency_for_tp
    field :sale_tax_industry, :sale_tax_industry_for_tp
  end

  object :project_for_tp do
    field :id, :string
    field :instant_matched, :boolean
    field :status, :string
  end

  object :sale_tax_frequency_for_tp do
    field :name, :string
  end

  object :sale_tax_industry_for_tp do
    field :name, list_of(:string)
  end

  object :analyze_sale_tax_for_tp do
    field :id, non_null(:string), description: "service id"
    field :name, :string
    field :sum_value, :decimal
    field :sum_match, :integer
    field :sum_price, :integer
    field :project, :project_for_tp
    field :sale_tax, :sale_tax_for_tp
    field :user, :user_by_tp
  end

  object :analyze_sale_tax_for_pro do
    field :id, non_null(:string), description: "service id"
    field :name, :string
    field :sum_value, :decimal
    field :sum_match, :integer
    field :sum_price, :integer
    field :user, :user_by_pro
  end

  object :user_by_tp do
    field :id, :string, description: "user id"
    field :avatar, :string
    field :first_name, :string
    field :languages, list_of(:language)
  end

  object :user_by_pro do
    field :id, :string, description: "user id"
    field :avatar, :string
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :profession, :string
    field :languages, list_of(:language)
    field :pro_ratings, list_of(:pro_rating)
  end

  object :analyze_queries do
    @desc "Get an analyze specific service"
    field :show_analyze, list_of(:analyze) do
      arg(:service_id, non_null(:string))
      resolve(&AnalyzeResolver.show/3)
    end

    @desc "Get an analyze sale_tax for role's pro"
    field :show_analyze_sale_tax_for_pro, list_of(:analyze_sale_tax_for_tp) do
      arg(:page, non_null(:integer))
      arg(:service_id, non_null(:string))
      resolve(&AnalyzeResolver.show/3)
    end

    @desc "Get an analyze sale_tax for role's tp"
    field :show_analyze_sale_tax_for_tp, list_of(:analyze_sale_tax_for_pro) do
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

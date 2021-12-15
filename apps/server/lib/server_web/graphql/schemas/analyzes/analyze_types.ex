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

  object :book_keeping_for_tp do
    field :id, :string
    field :deadline, :string
    field :tax_year, list_of(:string)
    field :book_keeping_annual_revenue, :name_by_service
    field :book_keeping_number_employee, :name_by_service
    field :book_keeping_type_client, :name_by_service
  end

  object :business_tax_return_for_tp do
    field :id, :string
    field :deadline, :string
    field :tax_year, list_of(:string)
    field :business_entity_type, :name_by_service
    field :business_number_employee, :name_by_service
    field :business_total_revenue, :name_by_service
  end

  object :sale_tax_for_tp do
    field :id, :string
    field :deadline, :string
    field :sale_tax_count, :integer
    field :state, list_of(:string)
    field :status, :string
    field :sale_tax_frequency, :name_by_service
    field :sale_tax_industry, :names_by_service
  end

  object :project_for_tp do
    field :id, :string
    field :instant_matched, :boolean
    field :status, :string
  end

  object :name_by_service do
    field :name, :string
  end

  object :names_by_service do
    field :name, list_of(:string)
  end

  object :platform_for_pro do
    field :client_limit_reach, non_null(:boolean)
    field :hero_status, non_null(:boolean)
    field :is_online, non_null(:boolean)
  end

  object :analyze_book_keeping_for_tp do
    field :id, non_null(:string), description: "service id"
    field :name, :string
    field :sum_value, :decimal
    field :sum_match, :integer
    field :sum_price, :integer
    field :book_keeping, :book_keeping_for_tp
    field :project, :project_for_tp
    field :user, :user_by_tp
  end

  object :analyze_book_keeping_for_pro do
    field :id, non_null(:string), description: "service id"
    field :name, :string
    field :sum_value, :decimal
    field :sum_match, :integer
    field :sum_price, :integer
    field :user, :user_by_pro
  end

  object :analyze_business_tax_return_for_tp do
    field :id, non_null(:string), description: "service id"
    field :name, :string
    field :sum_value, :decimal
    field :sum_match, :integer
    field :sum_price, :integer
    field :business_tax_return, :business_tax_return_for_tp
    field :project, :project_for_tp
    field :user, :user_by_tp
  end

  object :analyze_business_tax_return_for_pro do
    field :id, non_null(:string), description: "service id"
    field :name, :string
    field :sum_value, :decimal
    field :sum_match, :integer
    field :sum_price, :integer
    field :user, :user_by_pro
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
    field :platform, :platform_for_pro
    field :pro_ratings, list_of(:pro_rating)
  end

  object :analyze_queries do
    @desc "Get an analyze specific service"
    field :show_analyze, list_of(:analyze) do
      arg(:page, :integer, default_value: 0)
      arg(:service_id, non_null(:string))
      resolve(&AnalyzeResolver.show/3)
    end

    @desc "Get an analyze book_keeping for role's pro"
    field :show_analyze_book_keeping_for_pro, list_of(:analyze_book_keeping_for_tp) do
      arg(:page, non_null(:integer))
      arg(:service_id, non_null(:string))
      resolve(&AnalyzeResolver.show/3)
    end

    @desc "Get an analyze book_keeping for role's tp"
    field :show_analyze_book_keeping_for_tp, list_of(:analyze_book_keeping_for_pro) do
      arg(:page, :integer, default_value: 0)
      arg(:service_id, non_null(:string))
      resolve(&AnalyzeResolver.show/3)
    end

    @desc "Get an analyze business_tax_return for role's pro"
    field :show_analyze_business_tax_return_for_pro, list_of(:analyze_business_tax_return_for_tp) do
      arg(:page, non_null(:integer))
      arg(:service_id, non_null(:string))
      resolve(&AnalyzeResolver.show/3)
    end

    @desc "Get an analyze business_tax_return for role's tp"
    field :show_analyze_business_tax_return_for_tp, list_of(:analyze_business_tax_return_for_pro) do
      arg(:page, :integer, default_value: 0)
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
      arg(:page, :integer, default_value: 0)
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

defmodule ServerWeb.GraphQL.Schemas.Talk.ReportTypes do
  @moduledoc """
  The Report GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Talk.ReportResolver
  }

  @desc "The report on the site"
  object :report, description: "Report" do
    field :id, non_null(:string), description: "unique identifier"
    field :description, :string
    field :messages, list_of(:string)
    field :other, :boolean
    field :reasons, :string
    field :users, :user, resolve: dataloader(Data)
  end

  @desc "The report update via params"
  input_object :update_report_params, description: "update report" do
    field :description, :string
    field :messages, list_of(:string)
    field :other, :boolean
    field :reasons, :string
    field :user_id, non_null(:string)
  end

  object :report_queries do
    @desc "Get all reports"
    field :all_reports, list_of(:report) do
      resolve(&ReportResolver.list/3)
    end

    @desc "Get a specific report"
    field :show_report, :report do
      arg(:id, non_null(:string))
      resolve(&ReportResolver.show/3)
    end
  end

  object :report_mutations do
    @desc "Create the report"
    field :create_report, :report, description: "Create a new report" do
      arg :description, :string
      arg :messages, non_null(list_of(:string))
      arg :other, :boolean
      arg :reasons, :string
      arg :user_id, non_null(:string)
      resolve &ReportResolver.create/3
    end

    @desc "Update a specific report"
    field :update_report, :report do
      arg :id, non_null(:string)
      arg :report, :update_report_params
      resolve &ReportResolver.update/3
    end

    @desc "Delete a specific the report"
    field :delete_report, :report do
      arg :id, non_null(:string)
      arg :user_id, non_null(:string)
      resolve &ReportResolver.delete/3
    end
  end

  object :report_subscriptions do
    @desc "Create the report via channel"
    field :report_created, :report do
      config(fn _, _ ->
        {:ok, topic: "reports"}
      end)

      trigger(:create_report,
        topic: fn _ ->
          "reports"
        end
      )
    end
  end
end

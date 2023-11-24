defmodule ServerWeb.GraphQL.Schemas.Contracts.ProjectTypes do
  @moduledoc """
  The Project GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Contracts.ProjectResolver
  }

  @desc "The project on the site for all projects"
  object :project, description: "Project" do
    field :id, non_null(:string), description: "unique identifier"
    field :addon_price, :integer
    field :assigned, :user, resolve: dataloader(Data)
    field :book_keeping, :book_keeping, resolve: dataloader(Data)
    field :business_tax_return, :business_tax_return, resolve: dataloader(Data)
    field :by_pro_status, :boolean
    field :end_time, :date
    field :id_from_stripe_card, :string
    field :id_from_stripe_transfer, :string
    field :individual_tax_return, :individual_tax_return, resolve: dataloader(Data)
    field :instant_matched, non_null(:boolean)
    field :offer_price, :decimal
    field :room_id, :string
    field :sale_tax, :sale_tax, resolve: dataloader(Data)
    field :service_review, :service_review, resolve: dataloader(Data)
    field :status, non_null(:string)
    field :users, :user, resolve: dataloader(Data)
    field :tp_docs, list_of(:doc_for_tp), resolve: dataloader(Data)
    field :pro_docs, list_of(:doc_for_pro), resolve: dataloader(Data)
    field :plaid_accounts, list_of(:plaid_account), resolve: dataloader(Data)
    field :addons, list_of(:addon), resolve: dataloader(Data)
    field :offers, list_of(:offer), resolve: dataloader(Data)
  end

  object :doc_for_tp do
    field :id, :string
    field :access_granted, :boolean
    field :category, :string
    field :file, :picture, description: "An upload's file"
    field :projects, :project, resolve: dataloader(Data)
    field :signed_by_tp, :boolean
  end

  object :doc_for_pro do
    field :id, :string
    field :category, :string
    field :file, :picture, description: "An upload's file"
    field :projects, :project, resolve: dataloader(Data)
    field :signature, :boolean
    field :signed_by_pro, :boolean
    field :users, :user, resolve: dataloader(Data)
  end

  @desc "The project update via params"
  input_object :update_project_params, description: "update project" do
    field :addon_price, :integer
    field :assigned_id, :string
    field :book_keeping_id, :string
    field :business_tax_return_id, :string
    field :by_pro_status, :boolean
    field :end_time, :date
    field :id_from_stripe_card, :string
    field :id_from_stripe_transfer, :string
    field :id_from_stripe_charge, :string
    field :individual_tax_return_id, :string
    field :instant_matched, :boolean
    field :offer_price, :decimal
    field :room_id, :string
    field :sale_tax_id, :string
    field :service_review_id, :string
    field :status, :string
    field :user_id, non_null(:string)
  end

  object :project_queries do
    @desc "Get all projects"
    field :all_projects, list_of(:project) do
      resolve(&ProjectResolver.list/3)
    end

    @desc "Get all pro projects"
    field :pro_projects, list_of(:project) do
      resolve(&ProjectResolver.pro_list/3)
    end

    @desc "Get a specific project"
    field :show_project, :project do
      arg(:id, non_null(:string))
      resolve(&ProjectResolver.show/3)
    end
  end

  object :project_mutations do
    @desc "Create the project"
    field :create_project, :project, description: "Create a new project" do
      arg :book_keeping_id, :string
      arg :business_tax_return_id, :string
      arg :id_from_stripe_card, :string
      arg :individual_tax_return_id, :string
      arg :instant_matched, non_null(:boolean)
      arg :sale_tax_id, :string
      arg :user_id, non_null(:string)
      resolve &ProjectResolver.create/3
    end

    @desc "Update a specific project"
    field :update_project, :project do
      arg :id, non_null(:string)
      arg :project, :update_project_params
      resolve &ProjectResolver.update/3
    end

    @desc "Delete a specific the project"
    field :delete_project, :project do
      arg :id, non_null(:string)
      arg :user_id, non_null(:string)
      resolve &ProjectResolver.delete/3
    end
  end

  object :project_subscriptions do
    @desc "Show all the projects via channel"
    field :project_list, list_of(:project) do
      config fn _, _ ->
        {:ok, topic: "projects"}
      end

      trigger(:all_projects,
        topic: fn _ ->
          "projects"
        end
      )
    end

    @desc "Show the project via channel with id"
    field :project_show, :project do
      arg(:id, non_null(:string))

      config(fn args, _ ->
        {:ok, topic: args.id}
      end)

      trigger(:show_project,
        topic: fn project ->
          project.id
        end
      )
    end

    @desc "Create the project via channel"
    field :project_create, :project do
      config(fn _, _ ->
        {:ok, topic: "projects"}
      end)

      trigger(:create_project,
        topic: fn _ ->
          "projects"
        end
      )
    end
  end
end

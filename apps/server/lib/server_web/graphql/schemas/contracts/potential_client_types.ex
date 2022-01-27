defmodule ServerWeb.GraphQL.Schemas.Contracts.PotentialClientTypes do
  @moduledoc """
  The Potential Client GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Contracts.PotentialClientResolver
  }

  @desc "The potential client on the site"
  object :potential_client, description: "Potential Client" do
    field :id, non_null(:string), description: "unique identifier"
    field :error, :string
    field :project, non_null(list_of(:string))
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The potential client on the site"
  object :potential_clients, description: "Potential Client" do
    field :id, non_null(:string), description: "unique identifier"
    field :project, list_of(:single_project)
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The project on the site"
  object :single_project, description: "Project" do
    field :id, non_null(:string), description: "unique identifier"
    field :addon_price, :integer
    field :assigned, :proba
    field :book_keeping, :book_keeping, resolve: dataloader(Data)
    field :business_tax_return, :business_tax_return, resolve: dataloader(Data)
    field :by_pro_status, :boolean
    field :end_time, :date
    field :id_from_stripe_card, :string
    field :id_from_stripe_transfer, :string
    field :individual_tax_return, :individual_tax_return, resolve: dataloader(Data)
    field :instant_matched, non_null(:boolean)
    field :offer_price, :decimal
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

  object :proba do
    field :accounting_software, list_of(:accounting_software), description: "list user's accounting_software"
    field :active, :boolean, description: "accounts user active"
    field :avatar, :string, description: "accounts user avatar"
    field :bio, :string, description: "accounts user bio"
    field :birthday, :date, description: "accounts user birthday"
    field :book_keepings, list_of(:book_keeping), description: "list user's book keepings"
    field :bus_addr_zip, :string, description: "zip customer by ptin"
    field :business_tax_returns, list_of(:business_tax_return), description: "list user's business tax returns"
    field :educations, list_of(:education), description: "list user's educations"
    field :email, :string, description: "accounts user email"
    field :error, :string, description: "user error"
    field :finished_project_count, :integer, description: "virtual field with calculates all projects with status Done"
    field :first_name, :string, description: "accounts user first_name"
    field :id, :string, description: "account user's id"
    field :individual_tax_returns, list_of(:individual_tax_return), description: "list user's business tax returns"
    field :init_setup, :boolean, description: "accounts user init_setup"
    field :is2fa, :boolean, description: "two factory authorization"
    field :languages, list_of(:language), description: "languages list for user"
    field :last_name, :string, description: "accounts user last_name"
    field :middle_name, :string, description: "accounts user middle_name"
    field :on_going_project_count, :integer, description: "virtual field with calculates all projects In Progress and in Transition"
    field :otp_last, :integer, description: "2factor last code"
    field :otp_secret, :string, description: "2factor token"
    field :phone, :string, description: "accounts user phone"
    field :platform, list_of(:platform)
    field :profession, :string, description: "credentials received from searchProfession"
    field :provider, :string, description: "accounts user provider"
    field :role, :boolean, description: "accounts user role"
    field :rooms, list_of(:room)
    field :sale_taxes, list_of(:sale_tax), description: "list user's sale_taxes"
    field :sex, :string, description: "accounts user sex"
    field :street, :string, description: "accounts user street"
    field :total_earned, :decimal, description: "sum of offerPrice and addonPrice from projects Done"
    field :work_experiences, list_of(:work_experience), description: "list user's work_experiences"
    field :zip, :integer, description: "accounts user zip"
  end

  @desc "The potential client update via params"
  input_object :update_potential_client_params, description: "update potential client" do
    field :project, list_of(:string)
  end

  object :potential_client_queries do
    @desc "Get all potential clients"
    field :all_potential_clients, :potential_clients do
      resolve(&PotentialClientResolver.list/3)
    end

    @desc "Get a specific potential client"
    field :show_potential_client, :potential_clients do
      arg(:id, non_null(:string))
      resolve(&PotentialClientResolver.show/3)
    end
  end

  object :potential_client_mutations do
    @desc "Create the potential client"
    field :create_potential_client, :potential_clients, description: "Create a new potential client" do
      arg :project, non_null(list_of(:string))
      arg :user_id, non_null(:string)
      resolve &PotentialClientResolver.create/3
    end

    @desc "Update a specific potential client"
    field :update_potential_client, :potential_clients do
      arg :id, non_null(:string)
      arg :potential_client, :update_potential_client_params
      resolve &PotentialClientResolver.update/3
    end

    @desc "Delete a specific the potential client"
    field :delete_potential_client, :potential_client do
      arg :id, non_null(:string)
      resolve &PotentialClientResolver.delete/3
    end
  end

  object :potential_client_subscriptions do
    @desc "Create the potential client via channel"
    field :potential_client_created, :potential_client do
      config(fn _, _ ->
        {:ok, topic: "potential_clients"}
      end)

      trigger(:create_potential_client,
        topic: fn _ ->
          "potential_clients"
        end
      )
    end
  end
end

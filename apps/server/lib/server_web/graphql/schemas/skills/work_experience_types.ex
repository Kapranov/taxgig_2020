defmodule ServerWeb.GraphQL.Schemas.Skills.WorkExperienceTypes do
  @moduledoc """
  The WorkExperience GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Skills.WorkExperienceResolver
  }

  @desc "WorkExperience on the site"
  object :work_experience, description: "WorkExperience" do
    field :id, non_null(:string), description: "unique identifier"
    field :end_date, :date, description: "WorkExperience endDate"
    field :name, :string, description: "WorkExperience name"
    field :position, :string, description: "WorkExperience position"
    field :start_date, :date, description: "WorkExperience startDate"
    field :users, :user, resolve: dataloader(Data)
  end

  @desc "WorkExperience update via params"
  input_object :update_work_experience_params, description: "create WorkExperience" do
    field :end_date, :date, description: "Required endDate"
    field :name, :string, description: "Required name"
    field :position, :string, description: "a position"
    field :start_date, :date, description: "Required startDate"
    field :user_id, non_null(:string)
  end

  object :work_experience_queries do
    @desc "Get all WorkExperience"
    field :all_work_experiences, list_of(:work_experience) do
      resolve(&WorkExperienceResolver.list/3)
    end

    @desc "Get a specific work experience"
    field :show_work_experience, :work_experience do
      arg(:id, non_null(:string))
      resolve(&WorkExperienceResolver.show/3)
    end
  end

  object :work_experience_mutations do
    @desc "Create WorkExperience"
    field :create_work_experience, :work_experience, description: "Create a ane WorkExperience" do
      arg :end_date, :date
      arg :name, :string
      arg :position, :string
      arg :start_date, :date
      arg :user_id, non_null(:string)
      resolve &WorkExperienceResolver.create/3
    end

    @desc "Create WorkExperience by Admin"
    field :create_work_experience_by_admin, :work_experience, description: "Create a ane WorkExperience by admin" do
      arg :end_date, :date
      arg :name, :string
      arg :position, :string
      arg :start_date, :date
      arg :user_id, non_null(:string)
      resolve &WorkExperienceResolver.create_for_admin/3
    end

    @desc "Update a specific WorkExperience"
    field :update_work_experience, :work_experience do
      arg :id, non_null(:string)
      arg :work_experience, :update_work_experience_params
      resolve &WorkExperienceResolver.update/3
    end

    @desc "Update a specific WorkExperience by admin"
    field :update_work_experience_by_admin, :work_experience do
      arg :id, non_null(:string)
      arg :work_experience, :update_work_experience_params
      resolve &WorkExperienceResolver.update_for_admin/3
    end

    @desc "Delete a specific WorkExperience"
    field :delete_work_experience, :work_experience do
      arg :id, non_null(:string)
      resolve &WorkExperienceResolver.delete/3
    end

    @desc "Delete a specific WorkExperience by Admin"
    field :delete_work_experience_by_admin, :work_experience do
      arg :id, non_null(:string)
      resolve &WorkExperienceResolver.delete_for_admin/3
    end
  end

  object :work_experience_subscriptions do
    @desc "Create WorkExperience via Channel"
    field :work_experience_created, :work_experience do
      config(fn _, _ ->
        {:ok, topic: "work_experiences"}
      end)

      trigger(:create_work_experience,
        topic: fn _ ->
          "work_experiences"
        end
      )
    end
  end
end

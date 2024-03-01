defmodule ServerWeb.GraphQL.Schemas.Skills.EducationTypes do
  @moduledoc """
  The Education GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Skills.EducationResolver
  }

  @desc "The Education on the site"
  object :education, description: "Education" do
    field :id, non_null(:string), description: "unique identifier"
    field :course, :string, description: "education course"
    field :graduation, :date, description: "education graduation"
    field :universities, :university, resolve: dataloader(Data)
    field :users, :user, resolve: dataloader(Data)
  end

  @desc "The Education update via params"
  input_object :update_education_params, description: "create Education" do
    field :course, :string, description: "Required course"
    field :graduation, :date, description: "Required graduation"
    field :university_id, :string
    field :user_id, non_null(:string)
  end

  object :education_queries do
    @desc "Get all the Education"
    field :all_educations, list_of(:education) do
      resolve(&EducationResolver.list/3)
    end

    @desc "Get a specific the education"
    field :show_education, :education do
      arg(:id, non_null(:string))
      resolve(&EducationResolver.show/3)
    end
  end

  object :education_mutations do
    @desc "Create the Education"
    field :create_education, :education, description: "Create a new Education" do
      arg :course, non_null(:string)
      arg :graduation, non_null(:date)
      arg :university_id, non_null(:string)
      arg :user_id, non_null(:string)
      resolve &EducationResolver.create/3
    end

    @desc "Create the Education byAdmin"
    field :create_education_by_admin, :education, description: "Create a new Education by Admin" do
      arg :course, non_null(:string)
      arg :graduation, non_null(:date)
      arg :university_id, non_null(:string)
      arg :user_id, non_null(:string)
      resolve &EducationResolver.create_for_admin/3
    end

    @desc "Update a specific Education"
    field :update_education, :education do
      arg :id, non_null(:string)
      arg :education, :update_education_params
      resolve &EducationResolver.update/3
    end

    @desc "Update a specific Education by admin"
    field :update_education_by_admin, :education do
      arg :id, non_null(:string)
      arg :education, :update_education_params
      resolve &EducationResolver.update_for_admin/3
    end

    @desc "Delete a specific the education"
    field :delete_education, :education do
      arg :id, non_null(:string)
      resolve &EducationResolver.delete/3
    end

    @desc "Delete a specific the education by admin"
    field :delete_education_by_admin, :education do
      arg :id, non_null(:string)
      resolve &EducationResolver.delete_for_admin/3
    end
  end

  object :education_subscriptions do
    @desc "Create an EducationResolver via Channel"
    field :education_created, :education do
      config(fn _, _ ->
        {:ok, topic: "educations"}
      end)

      trigger(:create_education,
        topic: fn _ ->
          "educations"
        end
      )
    end
  end
end

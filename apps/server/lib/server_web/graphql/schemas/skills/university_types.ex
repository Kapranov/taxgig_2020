defmodule ServerWeb.GraphQL.Schemas.Skills.UniversityTypes do
  @moduledoc """
  The University GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Skills.UniversityResolver

  @desc "The University on the site"
  object :university, description: "University" do
    field :id, non_null(:string), description: "unique identifier"
    field :name, :string, description: "university name"
  end

  @desc "The university update via params"
  input_object :update_university_params, description: "create university" do
    field :name, non_null(:string), description: "Required name"
  end

  object :university_queries do
    @desc "Get all universities"
    field :all_universities, list_of(:university) do
      resolve(&UniversityResolver.list/3)
    end

    @desc "Get a specific university"
    field :show_university, :university do
      arg(:id, non_null(:string))
      resolve(&UniversityResolver.show/3)
    end
  end

  object :university_mutations do
    @desc "Create the University"
    field :create_university, :university, description: "Create a new university" do
      arg :name, non_null(:string)
      resolve &UniversityResolver.create/3
    end
  end

  object :university_subscriptions do
    @desc "Create the University via Channel"
    field :university_created, :university do
      config(fn _, _ ->
        {:ok, topic: "universities"}
      end)

      trigger(:create_university,
        topic: fn _ ->
          "universities"
        end
      )
    end
  end
end

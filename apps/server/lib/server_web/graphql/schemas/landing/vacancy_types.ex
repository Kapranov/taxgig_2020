defmodule ServerWeb.GraphQL.Schemas.Landing.VacancyTypes do
  @moduledoc """
  The Vacancy GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Landing.VacancyResolver

  @desc "The vacancy on the site"
  object :vacancy do
    field :id, non_null(:string), description: "vacancy id"
    field :content, non_null(:string), description: "vacancy content"
    field :department, non_null(:string), description: "vacancy department"
    field :title, non_null(:string), description: "vacancy title"
  end

  @desc "The vacancy update via params"
  input_object :update_vacancy_params do
    field :content, :string
    field :department, :string
    field :title, :string
  end

  object :vacancy_queries do
    @desc "Get all vacancies"
    field :vacancies, list_of(:vacancy) do
      resolve(&VacancyResolver.list/3)
    end

    @desc "Get a specific vacancy"
    field :vacancy, :vacancy do
      arg(:id, non_null(:string))
      resolve(&VacancyResolver.show/3)
    end
  end

  object :vacancy_mutations do
    @desc "Create the Vacancy"
    field :create_vacancy, :vacancy do
      arg :content, :string
      arg :department, :string
      arg :title, :string
      resolve &VacancyResolver.create/3
    end

    @desc "Update a specific vacancy"
    field :update_vacancy, :vacancy do
      arg :id, non_null(:string)
      arg :vacancy, :update_vacancy_params
      resolve &VacancyResolver.update/3
    end

    @desc "Delete a specific the vacancy"
    field :delete_vacancy, :vacancy do
      arg :id, non_null(:string)
      resolve &VacancyResolver.delete/3
    end
  end

  object :vacancy_subscriptions do
    @desc "Create the Vacancy via Channel"
    field :vacancy_created, :vacancy do
      config(fn _, _ ->
        {:ok, topic: "vacancies"}
      end)

      trigger(:create_vacancy,
        topic: fn _ ->
          "vacancies"
        end
      )
    end
  end
end

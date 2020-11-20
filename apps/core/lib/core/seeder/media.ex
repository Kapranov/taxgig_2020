defmodule Core.Seeder.Media do
  @moduledoc """
  Seeds for `Core.Media` context.
  """

  alias Core.{
    Contracts.Project,
    Media.Document,
    Repo
  }

  alias Faker.Internet

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(Document)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_documents()
  end

  defp seed_documents do
    project_ids =
      Enum.map(Repo.all(Project), fn(data) -> data.id end)

    {prj1, prj2, prj3, prj4, prj5, prj6, prj7} = {
      Enum.at(project_ids, 0),
      Enum.at(project_ids, 1),
      Enum.at(project_ids, 2),
      Enum.at(project_ids, 3),
      Enum.at(project_ids, 4),
      Enum.at(project_ids, 5),
      Enum.at(project_ids, 6)
    }

    case Repo.aggregate(Document, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%Document{
            access_granted:                 random_boolean(),
            category:                       random_integer(),
            document_link:                  Internet.url(),
            format:                         random_integer(),
            name:                           random_integer(),
            signature_required_from_client: random_boolean(),
            signed_by_client:               random_boolean(),
            signed_by_pro:                  random_boolean(),
            size:                           random_float(),
            project_id:                     prj1
          }),
          Repo.insert!(%Document{
            access_granted:                 random_boolean(),
            category:                       random_integer(),
            document_link:                  Internet.url(),
            format:                         random_integer(),
            name:                           random_integer(),
            signature_required_from_client: random_boolean(),
            signed_by_client:               random_boolean(),
            signed_by_pro:                  random_boolean(),
            size:                           random_float(),
            project_id:                     prj2
          }),
          Repo.insert!(%Document{
            access_granted:                 random_boolean(),
            category:                       random_integer(),
            document_link:                  Internet.url(),
            format:                         random_integer(),
            name:                           random_integer(),
            signature_required_from_client: random_boolean(),
            signed_by_client:               random_boolean(),
            signed_by_pro:                  random_boolean(),
            size:                           random_float(),
            project_id:                     prj3
          }),
          Repo.insert!(%Document{
            access_granted:                 random_boolean(),
            category:                       random_integer(),
            document_link:                  Internet.url(),
            format:                         random_integer(),
            name:                           random_integer(),
            signature_required_from_client: random_boolean(),
            signed_by_client:               random_boolean(),
            signed_by_pro:                  random_boolean(),
            size:                           random_float(),
            project_id:                     prj4
          }),
          Repo.insert!(%Document{
            access_granted:                 random_boolean(),
            category:                       random_integer(),
            document_link:                  Internet.url(),
            format:                         random_integer(),
            name:                           random_integer(),
            signature_required_from_client: random_boolean(),
            signed_by_client:               random_boolean(),
            signed_by_pro:                  random_boolean(),
            size:                           random_float(),
            project_id:                     prj5
          }),
          Repo.insert!(%Document{
            access_granted:                 random_boolean(),
            category:                       random_integer(),
            document_link:                  Internet.url(),
            format:                         random_integer(),
            name:                           random_integer(),
            signature_required_from_client: random_boolean(),
            signed_by_client:               random_boolean(),
            signed_by_pro:                  random_boolean(),
            size:                           random_float(),
            project_id:                     prj6
          }),
          Repo.insert!(%Document{
            access_granted:                 random_boolean(),
            category:                       random_integer(),
            document_link:                  Internet.url(),
            format:                         random_integer(),
            name:                           random_integer(),
            signature_required_from_client: random_boolean(),
            signed_by_client:               random_boolean(),
            signed_by_pro:                  random_boolean(),
            size:                           random_float(),
            project_id:                     prj7
          })
        ]
    end
  end

  @spec random_float() :: float()
  def random_float do
    :random.uniform() * 100
    |> Float.round(2)
  end

  @spec random_boolean() :: boolean()
  defp random_boolean do
    value = ~W(true false)a
    Enum.random(value)
  end

  @spec random_integer() :: integer()
  defp random_integer(n \\ 99) do
    Enum.random(1..n)
  end
end

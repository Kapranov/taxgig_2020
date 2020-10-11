defmodule Core.Seeder.Media do
  @moduledoc """
  Seeds for `Core.Media` context.
  """

  alias Core.{
    Accounts.User,
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
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {user, tp1, tp2, tp3, pro1, pro2, pro3} = {
      Enum.at(user_ids, 0),
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
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
            user_id:                        user
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
            user_id:                        tp1
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
            user_id:                        tp2
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
            user_id:                        tp3
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
            user_id:                        pro1
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
            user_id:                        pro2
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
            user_id:                        pro3
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

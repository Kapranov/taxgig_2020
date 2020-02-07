defmodule ServerWeb.GraphQL.Resolvers.Accounts.ProfileResolver do
  @moduledoc """
  The Profile GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.Profile,
    Repo
  }

  def list(_parent, _args, _info) do
    struct = Accounts.list_profile()
    {:ok, struct}
  end

  def show(_parent, %{id: user_id}, _info) do
    if is_nil(user_id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Accounts.get_profile!(user_id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "An User #{user_id} not found!"}
      end
    end
  end

  def update(_root, %{id: user_id, profile: params}, _info) do
    if is_nil(user_id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        Repo.get!(Profile, user_id)
        |> Profile.changeset(params)
        |> Repo.update
      rescue
        Ecto.NoResultsError ->
          {:error, "The Profile #{user_id} not found!"}
      end
    end
  end

  def delete(_parent, %{id: user_id}, _info) do
    if is_nil(user_id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Accounts.get_profile!(user_id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "The Profile #{user_id} not found!"}
      end
    end
  end
end

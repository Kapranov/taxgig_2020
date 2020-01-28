defmodule ServerWeb.GraphQL.Resolvers.Accounts.SubscriberResolver do
  @moduledoc """
  The Subscriber GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.Subscriber,
    Repo
  }

  def list(_parent, _args, _info) do
    struct = Accounts.list_subscriber()
    {:ok, struct}
  end

  def show(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Accounts.get_subscriber!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Subscriber #{id} not found!"}
      end
    end
  end

  def create(_parent, args, _info) do
    args
    |> Accounts.create_subscriber()
    |> case do
      {:ok, struct} ->
        {:ok, struct}
      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  def update(_root, %{id: id, subscriber: params}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        Repo.get!(Subscriber, id)
        |> Subscriber.changeset(params)
        |> Repo.update
      rescue
        Ecto.NoResultsError ->
          {:error, "The Subscriber #{id} not found!"}
      end
    end
  end

  def delete(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Accounts.get_subscriber!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "The Subscriber #{id} not found!"}
      end
    end
  end

  defp extract_error_msg(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {error, _details}} ->
      [
        field: field,
        message: String.capitalize(error)
      ]
    end)
  end
end

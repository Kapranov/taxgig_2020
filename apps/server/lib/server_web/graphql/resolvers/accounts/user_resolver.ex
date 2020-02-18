defmodule ServerWeb.GraphQL.Resolvers.Accounts.UserResolver do
  @moduledoc """
  The User GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Repo
  }

  @type t :: User.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(map(), map(), map()) :: success_list | error_tuple
  def list(_parent, _args, _info) do
    struct = Accounts.list_user()
    {:ok, struct}
  end

  @spec show(map(), %{id: bitstring}, map()) :: result
  def show(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Accounts.get_user!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "An User #{id} not found!"}
      end
    end
  end

  @spec create(map(), map(), map()) :: result
  def create(_parent, args, _info) do
    args
    |> Accounts.create_user()
    |> case do
      {:ok, struct} ->
        {:ok, struct}
      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  @spec update(map(), %{id: bitstring, user: map()}, map()) :: result
  def update(_root, %{id: id, user: params}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        Repo.get!(User, id)
        |> User.changeset(params)
        |> Repo.update
      rescue
        Ecto.NoResultsError ->
          {:error, "An User #{id} not found!"}
      end
    end
  end

  @spec delete(map(), %{id: bitstring}, map()) :: result
  def delete(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Accounts.get_user!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "An User #{id} not found!"}
      end
    end
  end

  @spec extract_error_msg(%Ecto.Changeset{}) :: %Ecto.Changeset{}
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

defmodule ServerWeb.GraphQL.Resolvers.Products.MatchValueRelatesResolver do
  @moduledoc """
  The MatchValueRelate GraphQL resolvers.
  """

  alias Core.{
    Repo,
    Services,
    Services.MatchValueRelate
  }

  @type t :: MatchValueRelate.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple


  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: success_list()
  def list(_parent, _args, _info) do
    struct = Services.list_match_value_relate()
    {:ok, struct}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.admin_role == false do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for user admin to perform action Show"]]}
    else
      try do
        struct = Services.get_match_value_relate!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The MatchValueRelate #{id} not found!"}
      end
    end
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) || current_user.admin_role == false do
      {:error, [[field: :current_user, message: "Permission denied for user admin to perform action Create"]]}
    else
      args
      |> Services.create_match_value_relate()
      |> case do
        {:ok, data} ->
          {:ok, data}
        {:error, changeset} ->
          {:error, extract_error_msg(changeset)}
      end
    end
  end

  @spec update(any, %{id: bitstring, match_value_relate: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, match_value_relate: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.admin_role == false do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for user admin to perform action Update"]]}
    else
      try do
        Repo.get!(MatchValueRelate, id)
        |> MatchValueRelate.changeset(params)
        |> Repo.update
      rescue
        Ecto.NoResultsError ->
          {:error, "The MatchValueRelate #{id} not found!"}
      end
    end
  end

  @spec delete(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.admin_role == false do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for user admin to perform action Delete"]]}
    else
      try do
        struct = Services.get_match_value_relate!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "The MatchValueRelate #{id} not found!"}
      end
    end
  end

  @spec find(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def find(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.admin_role == false do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for user admin to perform action Find"]]}
    else
      try do
        struct = Services.get_match_value_relate!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The MatchValueRelate #{id} not found!"}
      end
    end
  end

  @spec extract_error_msg(Ecto.Changeset.t()) :: Ecto.Changeset.t()
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

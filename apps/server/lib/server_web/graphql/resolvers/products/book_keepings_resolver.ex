defmodule ServerWeb.GraphQL.Resolvers.Products.BookKeepingsResolver do
  @moduledoc """
  The BookKeeping GraphQL resolvers.
  """

  alias Core.{
    Repo,
    Services,
    Services.BookKeeping
  }

  @type t :: BookKeeping.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      data = Services.list_book_keeping()
      {:ok, data}
    end
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      try do
        data = Services.get_book_keeping!(id)
        {:ok, data}
      rescue
        Ecto.NoResultsError ->
          {:error, "The BookKeeping #{id} not found!"}
      end
    end
  end

  @spec role_client(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def role_client(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action RoleClient"]]}
    else
      try do
        case BookKeeping.find_role_by_user(id) do
          true ->
            {:error, nil}
          false ->
            data = Services.get_book_keeping!(id)
            {:ok, data}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The BookKeeping #{id} not found!"}
      end
    end
  end

  @spec role_pro(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def role_pro(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action RolePro"]]}
    else
      try do
        case BookKeeping.find_role_by_user(id) do
          true ->
            data = Services.get_book_keeping!(id)
            {:ok, data}
          false ->
            {:error, nil}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The BookKeeping #{id} not found!"}
      end
    end
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for current_user to perform action Create"]]}
    else
      args
      |> Services.create_book_keeping()
      |> case do
        {:ok, data} ->
          {:ok, data}
        {:error, changeset} ->
          {:error, extract_error_msg(changeset)}
      end
    end
  end

  @spec update(any, %{id: bitstring, book_keeping: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, book_keeping: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      try do
        Repo.get!(BookKeeping, id)
        |> BookKeeping.changeset(params)
        |> Repo.update
      rescue
        Ecto.NoResultsError ->
          {:error, "The BookKeeping #{id} not found!"}
      end
    end
  end

  @spec delete(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      try do
        data = Services.get_book_keeping!(id)
        Repo.delete(data)
      rescue
        Ecto.NoResultsError ->
          {:error, "The BookKeeping #{id} not found!"}
      end
    end
  end

  @spec find(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def find(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]}
    else
      try do
        data = Services.get_book_keeping!(id)
        {:ok, data }
      rescue
        Ecto.NoResultsError ->
          {:error, "The BookKeeping #{id} not found!"}
      end
    end
  end

  @spec extract_error_msg(Ecto.Changeset.t()) :: list
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

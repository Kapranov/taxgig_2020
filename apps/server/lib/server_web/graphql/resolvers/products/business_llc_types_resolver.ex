defmodule ServerWeb.GraphQL.Resolvers.Products.BusinessLlcTypesResolver do
  @moduledoc """
  The BusinessLlcType GraphQL resolvers.
  """

  alias Core.{
    Repo,
    Services,
    Services.BusinessLlcType
  }

  @type t :: BusinessLlcType.t()
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
      data = Services.list_business_llc_type()
      {:ok, data}
    end
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      try do
        data = Services.get_business_llc_type!(id)
        {:ok, data}
      rescue
        Ecto.NoResultsError ->
          {:error, "The BusinessLlcType #{id} not found!"}
      end
    end
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for current_user to perform action Create"]]}
    else
      args
      |> Services.create_business_llc_type()
      |> case do
        {:ok, data} ->
          {:ok, data}
        {:error, changeset} ->
          {:error, extract_error_msg(changeset)}
      end
    end
  end

  @spec update(any, %{id: bitstring, business_llc_type: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, business_llc_type: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      try do
        Repo.get!(BusinessLlcType, id)
        |> BusinessLlcType.changeset(params)
        |> Repo.update
      rescue
        Ecto.NoResultsError ->
          {:error, "The BusinessLlcType #{id} not found!"}
      end
    end
  end

  @spec delete(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      try do
        data = Services.get_business_llc_type!(id)
        Repo.delete(data)
      rescue
        Ecto.NoResultsError ->
          {:error, "The BusinessLlcType #{id} not found!"}
      end
    end
  end

  @spec find(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def find(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]}
    else
      try do
        data = Services.get_business_llc_type!(id)
        {:ok, data }
      rescue
        Ecto.NoResultsError ->
          {:error, "The BusinessLlcType #{id} not found!"}
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

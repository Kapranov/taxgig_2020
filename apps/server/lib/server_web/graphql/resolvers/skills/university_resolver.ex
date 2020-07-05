defmodule ServerWeb.GraphQL.Resolvers.Skills.UniversityResolver do
  @moduledoc """
  The University GraphQL resolvers.
  """

  alias Core.{
    Skills,
    Skills.University,
    Repo
  }

  @type t :: University.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: success_list()
  def list(_parent, _args, _info) do
    struct = Skills.list_university()
    {:ok, struct}
  end

  @spec show(any, %{id: bitstring}, Absinthe.Resolution.t()) :: result()
  def show(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Skills.get_university!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The University #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :id, message: "Can't be blank"]]}
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: result()
  def create(_parent, args, _info) do
    if is_nil(args[:name]) do
      {:error, [[field: :name, message: "Can't be blank"]]}
    else
      args
      |> Skills.create_university()
      |> case do
        {:ok, struct} ->
          {:ok, struct}
        {:error, changeset} ->
          {:error, extract_error_msg(changeset)}
      end
    end
  end

  @spec delete(any, %{id: bitstring}, Absinthe.Resolution.t()) :: result()
  def delete(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Skills.get_university!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "The University #{id} not found!"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [[field: :id, message: "Can't be blank"]]}
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

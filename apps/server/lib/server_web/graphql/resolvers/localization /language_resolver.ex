defmodule ServerWeb.GraphQL.Resolvers.Localization.LanguageResolver do
  @moduledoc """
  The Language GraphQL resolvers.
  """

  alias Core.{
    Localization,
    Localization.Language,
    Repo
  }

  @type t :: Language.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: success_list
  def list(_parent, _args, _info) do
    struct = Localization.list_language()
    {:ok, struct}
  end

  @spec show(any, %{id: bitstring}, Absinthe.Resolution.t()) :: result
  def show(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Localization.get_language!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Language #{id} not found!"}
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: result
  def create(_parent, args, _info) do
    args
    |> Localization.create_language()
    |> case do
      {:ok, struct} ->
        {:ok, struct}
      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  @spec update(any, %{id: bitstring, language: map()}, Absinthe.Resolution.t()) :: result
  def update(_root, %{id: id, language: params}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        Repo.get!(Language, id)
        |> Language.changeset(params)
        |> Repo.update
      rescue
        Ecto.NoResultsError ->
          {:error, "The Language #{id} not found!"}
      end
    end
  end

  @spec delete(any, %{id: bitstring}, Absinthe.Resolution.t()) :: result
  def delete(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Localization.get_language!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "The Language #{id} not found!"}
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

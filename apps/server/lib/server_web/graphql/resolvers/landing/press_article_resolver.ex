defmodule ServerWeb.GraphQL.Resolvers.Landing.PressArticleResolver do
  @moduledoc """
  The PressArticle GraphQL resolvers.
  """

  alias Core.{
    Landing,
    Landing.PressArticle,
    Repo
  }

  @type t :: Faq.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(map(), map(), map()) :: success_list | error_tuple
  def list(_parent, _args, _info) do
    struct = Landing.list_press_article()
    {:ok, struct}
  end

  @spec show(map(), %{id: bitstring}, map()) :: result
  def show(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Landing.get_press_article!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Press Article #{id} not found!"}
      end
    end
  end

  @spec create(map(), map(), map()) :: result
  def create(_parent, args, _info) do
    args
    |> Landing.create_press_article()
    |> case do
      {:ok, struct} ->
        {:ok, struct}
      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  @spec update(map(), %{id: bitstring, press_article: map()}, map()) :: result
  def update(_root, %{id: id, press_article: params}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        Repo.get!(PressArticle, id)
        |> PressArticle.changeset(params)
        |> Repo.update
      rescue
        Ecto.NoResultsError ->
          {:error, "The Press Article #{id} not found!"}
      end
    end
  end

  @spec delete(map(), %{id: bitstring}, map()) :: result
  def delete(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Landing.get_press_article!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "The Press Article #{id} not found!"}
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

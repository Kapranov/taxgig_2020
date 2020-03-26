defmodule ServerWeb.GraphQL.Resolvers.Landing.FaqCategoryResolver do
  @moduledoc """
  The FaqCategory GraphQL resolvers.
  """

  alias Core.{
    Landing,
    Landing.FaqCategory,
    Repo
  }

  @type t :: FaqCategory.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: success_list()
  def list(_parent, _args, _info) do
    struct = Landing.list_faq_category()
    {:ok, struct}
  end

  @spec find_faq_category(any, %{id: bitstring}, Absinthe.Resolution.t()) :: success_tuple() | nil
  def find_faq_category(_parent, %{id: id}, _info) do
    struct = Landing.find_by_faq_category_id(id)
    {:ok, struct}
  end

  @spec show(any, %{id: bitstring}, Absinthe.Resolution.t()) :: result()
  def show(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Landing.get_faq_category!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Faq Category #{id} not found!"}
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: result()
  def create(_parent, args, _info) do
    args
    |> Landing.create_faq_category()
    |> case do
      {:ok, struct} ->
        {:ok, struct}
      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  @spec update(any, %{id: bitstring, faq_category: map()}, Absinthe.Resolution.t()) :: result()
  def update(_root, %{id: id, faq_category: params}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        Repo.get!(FaqCategory, id)
        |> FaqCategory.changeset(params)
        |> Repo.update
      rescue
        Ecto.NoResultsError ->
          {:error, "The Faq Category #{id} not found!"}
      end
    end
  end

  @spec delete(any, %{id: bitstring}, Absinthe.Resolution.t()) :: result()
  def delete(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Landing.get_faq_category!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "The Faq Category #{id} not found!"}
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

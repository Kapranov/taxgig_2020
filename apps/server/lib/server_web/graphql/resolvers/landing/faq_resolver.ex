defmodule ServerWeb.GraphQL.Resolvers.Landing.FaqResolver do
  @moduledoc """
  The Faq GraphQL resolvers.
  """

  alias Core.{
    Landing,
    Landing.Faq,
    Repo
  }

  @type t :: Faq.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: success_list()
  def list(_parent, _args, _info) do
    struct = Landing.list_faq()
    {:ok, struct}
  end

  @spec show(any, %{id: bitstring}, Absinthe.Resolution.t()) :: result()
  def show(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Landing.get_faq!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Faq #{id} not found!"}
      end
    end
  end

  @spec search_titles(any, %{title: bitstring}, Absinthe.Resolution.t()) :: result()
  def search_titles(_parent, args, _info) do
    if is_nil(args) do
      {:error, [[field: :title, message: "Can't be blank"]]}
    else
      try do
        if is_nil(args[:title]) do
          {:error, [[field: :title, message: "Can't be blank"]]}
        else
          struct = Landing.search_title(args[:title])
          {:ok, struct}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The Faq #{args[:title]} not found!"}
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: result()
  def create(_parent, args, _info) do
    args
    |> Landing.create_faq()
    |> case do
      {:ok, struct} ->
        {:ok, struct}
      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  @spec update(any, %{id: bitstring, faq: map()}, Absinthe.Resolution.t()) :: result()
  def update(_root, %{id: id, faq: params}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        Repo.get!(Faq, id)
        |> Faq.changeset(params)
        |> Repo.update
      rescue
        Ecto.NoResultsError ->
          {:error, "The Faq #{id} not found!"}
      end
    end
  end

  @spec delete(any, %{id: bitstring}, Absinthe.Resolution.t()) :: result()
  def delete(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Landing.get_faq!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "The Faq #{id} not found!"}
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

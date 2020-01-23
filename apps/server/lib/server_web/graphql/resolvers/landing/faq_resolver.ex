defmodule ServerWeb.GraphQL.Resolvers.Landing.FaqResolver do
  @moduledoc """
  The Faq GraphQL resolvers.
  """

  alias Core.{
    Landing,
    Landing.Faq,
    Repo
  }

  def list(_parent, _args, _info) do
    struct = Landing.list_faq()
    {:ok, struct}
  end

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

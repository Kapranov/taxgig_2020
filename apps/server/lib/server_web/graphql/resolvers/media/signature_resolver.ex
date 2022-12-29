defmodule ServerWeb.GraphQL.Resolvers.Media.SignatureResolver do
  @moduledoc """
  The Signatures GraphQL resolvers.
  """

  alias Core.{
    Media,
    Media.Signature,
    Queries,
    Repo
  }

  @type t :: Signature.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for current_user to perform action List"]]}
    else
      struct = Queries.by_list(Signature, :pro_doc_id, args[:pro_doc_id])
      {:ok, struct}
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: result()
  def create(_parent, args, _info) do
    args
    |> Media.create_signature()
    |> case do
      {:ok, struct} ->
        {:ok, struct}
      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  @spec update(any, %{id: bitstring, signature: map()}, Absinthe.Resolution.t()) :: result()
  def update(_root, %{id: id, signature: params}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        Repo.get!(Signature, id)
        |> Signature.changeset(params)
        |> Repo.update
      rescue
        Ecto.NoResultsError ->
          {:error, "The Signature #{id} not found!"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :id, message: "Can't be blank"], [field: :signature, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring}, Absinthe.Resolution.t()) :: result()
  def delete(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Media.get_signature!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "The Signature #{id} not found!"}
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

defmodule ServerWeb.GraphQL.Resolvers.Accounts.DeletedUserResolver do
  @moduledoc """
  The Deleted User GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Accounts.DeletedUser,
    Repo
  }

  @type t :: DeletedUser.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{:filter => map()}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, %{filter: args}, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) || current_user.admin == false do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      case args do
        %{page: page, limit_counter: counter} ->
          if page < counter do
            data =
              Accounts.list_deleted_user()
              |> Enum.take(page)

            {:ok, data}
          else
            data =
              Accounts.list_deleted_user()
              |> Enum.take(counter)

            {:ok, data}
          end
        %{page: page} ->
            data =
              Accounts.list_deleted_user()
              |> Enum.take(page)

            {:ok, data}
        %{limit_counter: counter} ->
            data =
              Accounts.list_deleted_user()
              |> Enum.take(counter)
            {:ok, data}
        _ ->
          {:ok, []}
      end
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.admin == false do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      try do
        struct = Accounts.get_deleted_user!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Deleted User #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, _resolutions) do
    args
    |> Accounts.create_deleted_user()
    |> case do
      {:ok, struct} ->
        {:ok, struct}
      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  @spec create_for_admin(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create_for_admin(_parent, args, %{context: %{current_user: current_user}}) do
    if current_user.admin do
      args
      |> Accounts.create_deleted_user()
      |> case do
        {:ok, struct} ->
          {:ok, struct}
        {:error, changeset} ->
          {:error, extract_error_msg(changeset)}
      end
    else
      {:error, [[field: :id, message: "Permission denied for current user"]]}
    end
  end

  @spec create_for_admin(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create_for_admin(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :deleted_user, message: "Can't be blank"]]}
  end

  @spec update(any, %{id: bitstring, deleted_user: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, deleted_user: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.admin == false do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      try do
        Repo.get!(DeletedUser, id)
        |> Accounts.update_deleted_user(params)
        |> case do
          {:ok, struct} ->
            {:ok, struct}
          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The Deleted User #{id} not found!"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :deleted_user, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.admin == false do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      try do
        struct = Accounts.get_deleted_user!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "The Deleted User #{id} not found!"}
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

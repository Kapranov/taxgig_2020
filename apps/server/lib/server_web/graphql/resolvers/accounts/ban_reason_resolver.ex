defmodule ServerWeb.GraphQL.Resolvers.Accounts.BanReasonResolver do
  @moduledoc """
  The Ban Reason GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.BanReason,
    Accounts.User,
    Repo
  }

  @type t :: BanReason.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) || current_user.admin == false do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      struct = Accounts.list_ban_reason()
      {:ok, struct}
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
        struct = Accounts.get_ban_reason!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Ban Reason #{id} not found xxxx!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) || current_user.admin == false do
      {:error, [[field: :current_user, message: "Permission denied for current_user to perform action Create"]]}
    else
      args
      |> Accounts.create_ban_reason()
      |> case do
        {:ok, struct} ->
          {:ok, struct}
        {:error, changeset} ->
          {:error, extract_error_msg(changeset)}
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec update(any, %{id: bitstring, ban_reason: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, ban_reason: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.admin == false do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      try do
        Repo.get!(BanReason, id)
        |> Accounts.update_ban_reason(params)
        |> case do
          {:ok, struct} ->
            {:ok, struct}
          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The Ban Reason #{id} not found!"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :ban_reason, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.admin == false do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      try do
        struct = Accounts.get_ban_reason!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "The Ban Reason #{id} not found!"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
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

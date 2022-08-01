defmodule ServerWeb.GraphQL.Resolvers.Talk.RoomResolver do
  @moduledoc """
  The Room GraphQL resolvers.
  """

  alias Core.{
    Accounts.Platform,
    Accounts.User,
    Queries,
    Repo,
    Talk,
    Talk.Room
  }

  @type t :: Room.t()
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
      struct = Queries.by_list(Room, :user_id, current_user.id)
      {:ok, struct}
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      try do
        struct = Talk.get_room!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The room #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    case Queries.by_names(Room, :user_id, :name, args[:name], current_user.id) do
      [] ->
        case Repo.get_by(Platform, %{user_id: args[:user_id]}) do
          nil -> {:error, [[field: :user_id, message: "Please create Platform for your user_id"]]}
          data ->
            if data.payment_active == true do
              case Talk.create_room(current_user, Map.merge(args, %{active: true})) do
                {:ok, room} -> {:ok, room}
                {:error, _changeset} -> {:error, "Something went wrong with your room"}
              end
            else
              case Talk.create_room(current_user, Map.merge(args, %{active: false})) do
                {:ok, room} -> {:ok, room}
                {:error, _changeset} -> {:error, "Something went wrong with your room"}
              end
            end
        end
      [_] -> {:error, [[field: :name, message: "Something went wrong with your name"]]}
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _resolution) do
    {:error, "Unauthenticated"}
  end

  @spec update(any, %{id: bitstring, room: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, room: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      case params[:user_id] == current_user.id do
        true  ->
          try do
            Repo.get!(Room, id)
            |> Talk.update_room(Map.delete(params, :user_id))
            |> case do
              {:ok, struct} ->
                {:ok, struct}
              {:error, changeset} ->
                {:error, extract_error_msg(changeset)}
            end
          rescue
            Ecto.NoResultsError ->
              {:error, "The Room #{id} not found!"}
          end
        false -> {:error, "permission denied"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :addon, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id, user_id: user_id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      case user_id == current_user.id do
        true  ->
          try do
            struct = Talk.get_room!(id)
            Repo.delete(struct)
            |> case do
              {:ok, struct} ->
                {:ok, struct}
              {:error, changeset} ->
                {:error, extract_error_msg(changeset)}
            end
          rescue
            Ecto.NoResultsError ->
              {:error, "The Room #{id} not found!"}
          end
        false -> {:error, "permission denied"}
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

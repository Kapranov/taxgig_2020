defmodule ServerWeb.GraphQL.Resolvers.Talk.RoomResolver do
  @moduledoc """
  The Room GraphQL resolvers.
  """

  import Ecto.Query

  alias Core.{
    Accounts.Platform,
    Accounts.User,
    Queries,
    Repo,
    Talk,
    Talk.Message,
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

  @spec list_by_project_id(any, %{project_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def list_by_project_id(_parent, %{project_id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      query = from p in Room, where: p.project_id == ^id
      struct = Repo.all(query)
      {:ok, struct}
    end
  end

  @spec list_by_project_id(any, %{atom => any}, any) :: result()
  def list_by_project_id(_parent, _args, _info) do
    {:error, "there is projectId none record"}
  end

  @spec list_by_participant(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list_by_participant(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      query = from p in Room, where: p.participant_id == ^current_user.id
      struct = Repo.all(query)
      {:ok, struct}
    end
  end

  @spec list_by_participant(any, %{atom => any}, any) :: result()
  def list_by_participant(_parent, _args, _info) do
    {:error, "there is projectId none record"}
  end

  @spec list_by_current_participant(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list_by_current_participant(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      data1 = Queries.by_list(Room, :user_id, current_user.id)
      data2 = from p in Room, where: p.participant_id == ^current_user.id
      data = Repo.all(data2)
      Absinthe.Subscription.publish(ServerWeb.Endpoint, data1 ++ data, rooms_by_user_and_participant_all: "rooms")
      {:ok, data1 ++ data}
    end
  end

  @spec list_by_current_participant(any, %{atom => any}, any) :: result()
  def list_by_current_participant(_parent, _args, _info) do
    {:error, "there is projectId none record"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    try do
      struct = Talk.get_room!(id)
      count =
        Queries.aggregate_for_room(Room, Message, id, current_user)
        |> Enum.count
      {:ok, Map.merge(struct, %{unread_msg: count})}
    rescue
      Ecto.NoResultsError ->
        {:error, "The room #{id} not found!"}
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec show_by_participant(any, %{participant_id: bitstring, project_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show_by_participant(_parent, %{participant_id: participant_id, project_id: project_id}, %{context: %{current_user: current_user}}) do
    case Repo.get_by(Room, %{user_id: current_user.id, participant_id: participant_id, project_id: project_id}) do
      nil ->
        {:error, "No record found"}
      struct ->
        count =
          Queries.aggregate_for_room(Room, Message, struct.id, current_user)
          |> Enum.count
        {:ok, Map.merge(struct, %{unread_msg: count})}
    end
  end

  @spec show_by_participant(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show_by_participant(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    participant = Repo.get_by(User, id: args[:participant_id])
    case is_nil(participant) do
      true ->
        {:error, "there is participant_id doesn't exist"}
      false ->
        case participant.role == current_user.role do
          true ->
            {:error, "user_id role cannot match the role in participant_id"}
          false ->
            case Repo.get_by(Room, %{participant_id: args[:participant_id], project_id: args[:project_id]}) do
              nil ->
                case Repo.get_by(Platform, %{user_id: args[:user_id]}) do
                  nil -> {:error, [[field: :user_id, message: "Please create Platform for your user_id"]]}
                  data ->
                    if data.payment_active == true do
                      case Talk.create_room(current_user, Map.merge(args, %{active: true})) do
                        {:ok, room} ->
                          struct = Queries.by_list(Room, :user_id, current_user.id)
                          structs = from p in Room, where: p.participant_id == ^current_user.id
                          data = Repo.all(structs)
                          merge_data = struct ++ data
                          Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, room_all: "rooms")
                          Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, rooms_by_project_all: args[:project_id])
                          Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, rooms_by_participant_all: "rooms")
                          Absinthe.Subscription.publish(ServerWeb.Endpoint, merge_data, rooms_by_current_participant_user_all: "rooms")
                          {:ok, room}
                        {:error, _changeset} -> {:error, "Something went wrong with your room"}
                      end
                    else
                      case Talk.create_room(current_user, Map.merge(args, %{active: false})) do
                        {:ok, room} ->
                          struct = Queries.by_list(Room, :user_id, current_user.id)
                          structs = from p in Room, where: p.participant_id == ^current_user.id
                          data = Repo.all(structs)
                          merge_data = struct ++ data
                          Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, room_all: "rooms")
                          Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, rooms_by_project_all: struct.project_id)
                          Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, rooms_by_participant_all: "rooms")
                          Absinthe.Subscription.publish(ServerWeb.Endpoint, merge_data, rooms_by_current_participant_user_all: "rooms")
                          {:ok, room}
                        {:error, _changeset} -> {:error, "Something went wrong with your room"}
                      end
                    end
                end
              _ -> {:error, "You already have a chat with this participant in selected project"}
            end
        end
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
      try do
        Repo.get!(Room, id)
        |> Talk.update_room(params)
        |> case do
          {:ok, struct} ->
            data = Queries.by_list(Room, :user_id, current_user.id)
            Absinthe.Subscription.publish(ServerWeb.Endpoint, data, room_all: "rooms")
            Absinthe.Subscription.publish(ServerWeb.Endpoint, data, rooms_by_project_all: struct.project_id)
            Absinthe.Subscription.publish(ServerWeb.Endpoint, data, rooms_by_participant_all: "rooms")
            {:ok, struct}
          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The Room #{id} not found!"}
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

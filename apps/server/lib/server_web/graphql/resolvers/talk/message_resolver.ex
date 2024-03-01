defmodule ServerWeb.GraphQL.Resolvers.Talk.MessageResolver do
  @moduledoc """
  The Message GraphQL resolvers.
  """

  import Ecto.Query

  alias Core.{
    Accounts,
    Accounts.User,
    Notifications,
    Notifications.Notify,
    Queries,
    Repo,
    Talk,
    Talk.Message,
    Talk.Room
  }

  alias Mailings.Mailer

  @type r :: Room.t()
  @type t :: Message.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t} | {:ok, [r]}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple
  # @type task :: %__MODULE__{ pid: pid() | nil, ref: reference(), owner: pid() }

  @spec list(any, %{room_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, %{room_id: room_id}, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      struct = Talk.list_by_room_id(room_id)
      Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, msg_by_room: room_id)
      {:ok, struct}
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec list_by_room_id(any, %{room_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def list_by_room_id(_parent, %{filter: args, room_id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      query = from p in Message, where: p.room_id == ^id
      case Repo.all(query) do
        nil ->
          {:error, "none correct roomId for current_user"}
        data ->
          case args do
            %{page: page, limit_counter: counter} ->
              if page < counter do
                {:ok, Enum.take(data, page)}
              else
              {:ok, Enum.take(data, counter)}
              end
            %{page: page} ->
              {:ok, Enum.take(data, page)}
            %{limit_counter: counter} ->
              {:ok, Enum.take(data, counter)}
          end
      end
    end
  end

  @spec list_by_room_id(any, %{atom => any}, any) :: result()
  def list_by_room_id(_parent, _args, _info) do
    {:error, "there is roomId none record"}
  end

  @spec list_by_room_id_for_admin(any, %{room_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def list_by_room_id_for_admin(_parent, %{filter: args, room_id: id}, %{context: %{current_user: current_user}}) do
    if current_user.admin do
      query = from p in Message, where: p.room_id == ^id
      case Repo.all(query) do
        nil ->
          {:error, "none correct roomId for current_user"}
        data ->
          case args do
            %{page: page, limit_counter: counter} ->
              if page < counter do
                {:ok, Enum.take(data, page)}
              else
              {:ok, Enum.take(data, counter)}
              end
            %{page: page} ->
              {:ok, Enum.take(data, page)}
            %{limit_counter: counter} ->
              {:ok, Enum.take(data, counter)}
          end
      end
    else
      {:error, [[field: :current_user, message: "Permission denied for user current user"]]}
    end
  end

  @spec list_by_room_id_for_admin(any, %{atom => any}, any) :: result()
  def list_by_room_id_for_admin(_parent, _args, _info) do
    {:error, "there is roomId none record"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      try do
        struct = Talk.get_message!(id)
        Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, message_show: id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Message #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec search(any, %{project_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def search(_parent, %{project_id: project_id}, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      struct = Talk.list_by_project_id(project_id)
      Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, msg_by_project: project_id)
      {:ok, struct}
    end
  end

  @spec search(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def search(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec search_message(any, %{room_id: bitstring, keywords: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def search_message(_parent, %{room_id: room_id, keywords: term}, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      data = Talk.search(room_id, term)
      {:ok, data}
    end
  end

  @spec search_message(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def search_message(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for current_user to perform action Create"]]}
    else
      room = Repo.get_by(Room, %{id: args[:room_id]})
      case Accounts.by_role(current_user.id) do
        false ->
          if Accounts.by_role(args[:recipient_id]) == true do
            Talk.create_message(current_user, room, args)
            |> case do
              {:ok, struct} ->
                {:ok, _struct} = Talk.update_room(room, %{last_msg: struct.id})
                {:ok, notify} = Notifications.create_notify(%{
                  is_hidden: false,
                  is_read: false,
                  project_id: Repo.preload(struct, :room).room.project_id,
                  room_id: struct.room_id,
                  sender_id: struct.user_id,
                  template: 3,
                  user_id: struct.recipient_id
                })
                mailing_to(notify.user_id, "new_message_pro", notify.project_id)
                data = Queries.by_list(Room, :user_id, args[:recipient_id])
                query = from p in Message, where: p.room_id == ^args[:room_id]
                messages = Repo.all(query)
                notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                data1 = Queries.by_list(Room, :user_id, current_user.id)
                data2 = from p in Room, where: p.participant_id == ^current_user.id
                data3 = Repo.all(data2)
                Absinthe.Subscription.publish(ServerWeb.Endpoint, data, room_all: "rooms")
                Absinthe.Subscription.publish(ServerWeb.Endpoint, messages, messages_by_room_all: args[:room_id])
                Absinthe.Subscription.publish(ServerWeb.Endpoint, data, rooms_by_project_all: room.project_id)
                Absinthe.Subscription.publish(ServerWeb.Endpoint, data, rooms_by_participant_all: "rooms")
                Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                Absinthe.Subscription.publish(ServerWeb.Endpoint, data1 ++ data3, rooms_by_user_and_participant_all: "rooms")
                {:ok, struct}
              {:error, changeset} ->
                {:error, extract_error_msg(changeset)}
            end
          else
            {:error, [[field: :recipient_id, message: "Permission denied for client's role"]]}
          end
        true ->
          if Accounts.by_role(args[:recipient_id]) == false do
            Talk.create_message(current_user, room, args)
            |> case do
              {:ok, struct} ->
                {:ok, _struct} = Talk.update_room(room, %{last_msg: struct.id})
                {:ok, notify} = Notifications.create_notify(%{
                  is_hidden: false,
                  is_read: false,
                  project_id: Repo.preload(struct, :room).room.project_id,
                  room_id: struct.room_id,
                  sender_id: struct.user_id,
                  template: 2,
                  user_id: struct.recipient_id
                })
                mailing_to(notify.user_id, "new_message_client", notify.project_id)
                data = Queries.by_list(Room, :user_id, args[:recipient_id])
                query = from p in Message, where: p.room_id == ^args[:room_id]
                messages = Repo.all(query)
                data1 = Queries.by_list(Room, :user_id, current_user.id)
                data2 = from p in Room, where: p.participant_id == ^current_user.id
                data3 = Repo.all(data2)
                Absinthe.Subscription.publish(ServerWeb.Endpoint, data, room_all: "rooms")
                Absinthe.Subscription.publish(ServerWeb.Endpoint, messages, messages_by_room_all: args[:room_id])
                Absinthe.Subscription.publish(ServerWeb.Endpoint, data, rooms_by_project_all: room.project_id)
                Absinthe.Subscription.publish(ServerWeb.Endpoint, data, rooms_by_participant_all: "rooms")
                Absinthe.Subscription.publish(ServerWeb.Endpoint, data1 ++ data3, rooms_by_user_and_participant_all: "rooms")
                {:ok, struct}
              {:error, changeset} ->
                {:error, extract_error_msg(changeset)}
            end
          else
            {:error, [[field: :recipient_id, message: "Permission denied for client's role"]]}
          end
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec update(any, %{id: bitstring, message: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, message: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      try do
        Repo.get!(Message, id)
        |> Talk.update_message(params)
        |> case do
          {:ok, struct} ->
            query = from p in Message, where: p.room_id == ^struct.room_id
            data = Repo.all(query)
            data1 = Queries.by_list(Room, :user_id, current_user.id)
            data2 = from p in Room, where: p.participant_id == ^current_user.id
            data3 = Repo.all(data2)
            Absinthe.Subscription.publish(ServerWeb.Endpoint, data, messages_by_room_all: struct.room_id)
            Absinthe.Subscription.publish(ServerWeb.Endpoint, data1 ++ data3, rooms_by_user_and_participant_all: "rooms")
            {:ok, struct}
          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The Message #{id} not found!"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :message, message: "Can't be blank"]]}
  end

  @spec update_by_read(any, %{id: [bitstring]}, %{context: %{current_user: User.t()}}) :: result()
  def update_by_read(_parent, %{id: idx}, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      Enum.reduce(idx, [], fn(x, acc) ->
        try do
          Message
          |> Repo.get!(x)
          |> Talk.update_message(%{is_read: true})
          |> case do
            {:ok, struct} ->
              query = from p in Message, where: p.room_id == ^struct.room_id
              data = Repo.all(query)
              Absinthe.Subscription.publish(ServerWeb.Endpoint, data, messages_by_room_all: struct.room_id)
              {:ok, struct}
            {:error, _changeset} ->
              acc
          end
        rescue
          Ecto.NoResultsError -> acc
        end
      end)
    end
  end

  @spec update_by_read(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update_by_read(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :message, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring, user_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id, user_id: user_id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      case user_id == current_user.id do
        true  ->
          try do
            struct = Talk.get_message!(id)
            Repo.delete(struct)
          rescue
            Ecto.NoResultsError ->
              {:error, "The Message #{id} not found!"}
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

  @spec mailing_to(String.t(), String.t(), String.t()) :: map
  defp mailing_to(user_id, template, project_id) do
    email_and_name = Accounts.by_email(user_id)
    Task.async(fn ->
      Mailer.send_by_notification(email_and_name.email, template, email_and_name.first_name, project_id)
    end)
  end
end

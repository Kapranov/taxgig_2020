defmodule Chat.ChatRooms do
  @moduledoc false

  use DynamicSupervisor

  alias Chat.{ChatRoom, ChatRoomRegistry, UserSessions}

  @name __MODULE__

  def create(room) do
    case find(room) do
      {:ok, _pid} ->
        {:error, :already_exists}
      {:error, :unexisting_room} ->
        {:ok, _pid} = start(room)
        :ok
    end
  end

  def join(room, [as: session_id]) do
    case find(room) do
      {:ok, pid} ->
        try_join_chatroom(room, session_id, pid)
      {:error, :unexisting_room} ->
        send_error_message(session_id, room <> " does not exists")
    end
  end

  def send(msg, [to: room]) do
    case find(room) do
      {:ok, pid} -> ChatRoom.send(pid, msg)
      error -> error
    end
  end

  def start_link(_arg) do
    DynamicSupervisor.start_link(@name, [], name: :chatroom_supervisor)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp try_join_chatroom(room, session_id, chatroom_pid) do
    case ChatRoom.join(chatroom_pid, session_id) do
      :ok ->
        send_welcome_message(session_id, room)
      {:error, :already_joined} ->
        send_error_message(session_id, "you already joined the " <> room <> " room!")
    end
  end

  defp find(room) do
    case Registry.lookup(ChatRoomRegistry, room) do
      [] -> {:error, :unexisting_room}
      [{pid, nil}] -> {:ok, pid}
    end
  end

  defp send_welcome_message(session_id, room) do
    UserSessions.notify({room, "welcome to the " <> room <> " chat room!"}, to: session_id)
  end

  defp send_error_message(session_id, msg) do
    UserSessions.notify({:error, msg}, to: session_id)
  end

  defp start(chatroom_name) do
    name = {:via, Registry, {ChatRoomRegistry, chatroom_name}}
    spec = %{id: ChatRoom, start: {ChatRoom, :start_link, [name]}, restart: :temporary}
    DynamicSupervisor.start_child(:chatroom_supervisor, spec)
  end
end

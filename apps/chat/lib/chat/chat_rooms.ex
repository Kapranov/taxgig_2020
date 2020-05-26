defmodule Chat.ChatRooms do
  @moduledoc false

  use DynamicSupervisor

  alias Chat.{ChatRoom, UserSessions}

  @name __MODULE__

  def join(room, session_id) do
    case find_chatroom(room) do
      {:ok, pid} ->
        try_join_chatroom(room, session_id, pid)
      {:error, :unexisting_room} ->
        send_error_message(session_id, room <> " does not exists")
    end
  end

  def send(room, msg) do
    case find_chatroom(room) do
      {:ok, pid} -> ChatRoom.send(pid, msg)
      error -> error
    end
  end

  def create(room) do
    case find_chatroom(room) do
      {:ok, _pid} ->
        {:error, :already_exists}
      {:error, :unexisting_room} ->
        {:ok, _pid} = start(room)
        :ok
    end
  end

  def start_link(_arg) do
    DynamicSupervisor.start_link(@name, [], name: :chatroom_supervisor)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp start(name) do
    spec = %{id: ChatRoom, start: {ChatRoom, :start_link, [name]}, restart: :temporary}
    DynamicSupervisor.start_child(:chatroom_supervisor, spec)
  end

  defp try_join_chatroom(room, session_id, chatroom_pid) do
    case ChatRoom.join(chatroom_pid, session_id) do
      :ok ->
        send_welcome_message(session_id, room)
      {:error, :already_joined} ->
        send_error_message(session_id, "you already joined the " <> room <> " room!")
    end
  end

  defp find_chatroom(room) do
    case ChatRoom.find(room) do
      [] -> {:error, :unexisting_room}
      [{pid, nil}] -> {:ok, pid}
    end
  end

  defp send_welcome_message(session_id, room) do
    UserSessions.notify({room, "welcome to the " <> room <> " chat room!"}, to: session_id)
  end

  defp send_error_message(session_id, message) do
    UserSessions.notify({:error, message}, to: session_id)
  end
end

defmodule Chat.ChatRooms do
  @moduledoc false

  alias Chat.ChatRoom
  alias Chat.ChatRoomSupervisor

  def join(room, client) do
    case find_chatroom(room) do
      {:ok, pid} ->
        try_join_chatroom(room, client, pid)
      {:error, :unexisting_room} ->
        send_error_msg(client, room <> " does not exists")
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
        {:ok, _pid} = ChatRoomSupervisor.create(room)
        :ok
    end
  end

  defp try_join_chatroom(room, client, chatroom_pid) do
    case ChatRoom.join(chatroom_pid, client) do
      :ok ->
        send_welcome_msg(client, room)
      {:error, :already_joined} ->
        send_error_msg(client, "you already joined the " <> room <> " room!")
    end
  end

  defp find_chatroom(room) do
    case ChatRoom.find(room) do
      [] -> {:error, :unexisting_room}
      [{pid, nil}] -> {:ok, pid}
    end
  end

  defp send_welcome_msg(client, room) do
    Kernel.send client, {room, "welcome to the " <> room <> " chat room!"}
  end

  defp send_error_msg(client, msg) do
    Kernel.send client, {:error, msg}
  end
end

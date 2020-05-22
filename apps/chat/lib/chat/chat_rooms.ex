defmodule Chat.ChatRooms do
  @moduledoc false

  def join(_room_name, subscriber) do
    Chat.ChatRoom.join(subscriber)
  end

  def send(_room_name, message) do
    Chat.ChatRoom.send(message)
  end
end

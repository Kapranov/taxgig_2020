defmodule Chat.SendMessageToChatRoom do
  @moduledoc false

  alias Chat.ChatRooms

  def on(message, room, user_id) do
    case ChatRooms.send(message, to: room, as: user_id) do
      :ok ->
        :ok
      {:error, :unexisting_room} ->
        {:error, "#{room} does not exists"}
    end
  end
end

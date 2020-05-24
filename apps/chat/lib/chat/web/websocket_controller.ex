defmodule Chat.Web.WebSocketController do
  @moduledoc false

  @behaviour :cowboy_websocket

  alias Chat.ChatRooms

  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def websocket_init(state \\ nil) do
    {:ok, state}
  end

  def websocket_handle({:text, command_as_json}, state) do
    handle(from_json(command_as_json), state)
  end

  def websocket_handle(_msg, state) do
    {:ok, state}
  end

  def websocket_info({chatroom_name, msg}, state) do
    response = %{
      message: msg,
      room: chatroom_name
    }

    {:reply, {:text, to_json(response)}, state}
  end

  def websocket_terminate(_reason, _req, _state) do
    :ok
  end

  defp handle(%{"command" => "join", "room" => room}, state) do
    :ok = ChatRooms.join(room, self())

    response = %{
      message: "welcome to the " <> room <> " chat room!",
      room: room
    }

    {:reply, {:text, to_json(response)}, state}
  end

  defp handle(command = %{"command" => "join"}, state) do
    handle(Map.put(command, "room", "default"), state)
  end

  defp handle(%{"room" => room, "message" => msg}, state) do
    :ok = ChatRooms.send(room, msg)
    {:ok, state}
  end

  defp handle(_command, state) do
    response = %{
      error: "a_chat_room already exists"
    }

    {:reply, {:text, to_json(response)}, state}
  end

  defp to_json(response), do: Jason.encode!(response)
  defp from_json(json), do: Jason.decode!(json)
end

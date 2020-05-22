defmodule Chat.Web.WebSocketController do
  @moduledoc false

  @behaviour :cowboy_websocket

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

  def websocket_info(msg, state) do
    response = %{
      message: msg,
      room: "default"
    }

    {:reply, {:text, to_json(response)}, state}
  end

  def websocket_terminate(_reason, _req, _state) do
    :ok
  end

  defp handle(%{"command" => "join"}, state) do
    :ok = Chat.ChatRooms.join("default", self())

    response = %{
      message: "welcome to the default chat room!",
      room: "default"
    }

    {:reply, {:text, to_json(response)}, state}
  end

  defp handle(%{"room" => room, "message" => msg}, state) do
    :ok = Chat.ChatRooms.send(room, msg)
    {:ok, state}
  end

  defp to_json(response), do: Jason.encode!(response)
  defp from_json(json), do: Jason.decode!(json)
end

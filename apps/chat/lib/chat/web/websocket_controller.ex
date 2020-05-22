defmodule Chat.Web.WebSocketController do
  @moduledoc false

  @behaviour :cowboy_websocket

  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def websocket_init(state \\ nil) do
    {:ok, state}
  end

  def websocket_handle({:text, "join"}, state) do
    :ok = Chat.ChatRooms.join("default", self())

    response = %{
      message: "welcome to the default chat room!",
      room: "default"
    }

    {:reply, {:text, as_json(response)}, state}
  end

  def websocket_handle({:text, msg}, state) do
    :ok = Chat.ChatRooms.send("default", msg)
    {:ok, state}
  end

  def websocket_handle(_message, state) do
    {:ok, state}
  end

  def websocket_info(msg, state) do
    {:reply, {:text, msg}, state}
  end

  def websocket_terminate(_reason, _req, _state) do
    :ok
  end

  defp as_json(response), do: Jason.encode!(response)
end

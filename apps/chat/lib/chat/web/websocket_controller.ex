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
    :ok = Chat.ChatRoom.join(self())
    {:reply, {:text, "welcome to the awesome chat room!"}, state}
  end

  def websocket_handle({:text, msg}, state) do
    :ok = Chat.ChatRoom.send(msg)
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
end

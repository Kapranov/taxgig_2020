defmodule Chat.Web.WebSocketController do
  @moduledoc false

  @behaviour :cowboy_websocket

  alias Chat.{UserSessions, ChatRooms}

  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def websocket_init(_) do
    UserSessions.subscribe(self(), to: "default-user-session")
    {:ok, nil}
  end

  def websocket_handle({:text, command_as_json}, state) do
    case from_json(command_as_json) do
      {:error, _reason} -> {:ok, state}
      {:ok, command} -> handle(command, state)
    end
  end

  def websocket_handle(_msg, state) do
    {:ok, state}
  end

  def websocket_info({:error, msg}, state) do
    response = %{error: msg}
    {:reply, {:text, to_json(response)}, state}
  end

  def websocket_info({chatroom_name, msg}, state) do
    response = %{
      message: msg,
      room: chatroom_name
    }

    {:reply, {:text, to_json(response)}, state}
  end

  def websocket_terminate(_reason, _state) do
    :ok
  end

  defp handle(%{"command" => "join", "room" => room}, state) do
    ChatRooms.join(room, as: "default-user-session")
    {:ok, state}
  end

  defp handle(command = %{"command" => "join"}, state) do
    handle(Map.put(command, "room", "default"), state)
  end

  defp handle(%{"room" => room, "message" => msg}, state) do
    case ChatRooms.send(msg, [to: room]) do
      :ok ->
        {:ok, state}
      {:error, :unexisting_room} ->
        response = %{error: room <> " does not exists"}
        {:reply, {:text, to_json(response)}, state}
    end
  end

  defp handle(%{"command" => "create", "room" => room}, state) do
    response = case ChatRooms.create(room) do
      :ok -> %{success: room <> " has been created!"}
      {:error, :already_exists} ->  %{error: room <> " already exists"}
    end

    {:reply, {:text, to_json(response)}, state}
  end

  defp handle(_not_handled_command, state), do: {:ok, state}

  defp to_json(response), do: Jason.encode!(response)
  defp from_json(json), do: Jason.decode(json)
end

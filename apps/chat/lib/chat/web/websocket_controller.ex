defmodule Chat.Web.WebSocketController do
  @moduledoc false

  @behaviour :cowboy_websocket

  alias Chat.{UserSessions, ChatRooms}

  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def websocket_init(_) do
    UserSessions.subscribe(self(), to: "default-user-session")
    {:ok, "default-user-session"}
  end

  def websocket_handle({:text, command_as_json}, session_id) do
    case from_json(command_as_json) do
      {:error, _reason} -> {:ok, session_id}
      {:ok, command} -> handle(command, session_id)
    end
  end

  def websocket_handle(_msg, session_id) do
    {:ok, session_id}
  end

  def websocket_info({:error, msg}, session_id) do
    response = %{error: msg}
    {:reply, {:text, to_json(response)}, session_id}
  end

  def websocket_info({chatroom_name, msg}, session_id) do
    response = %{
      message: msg,
      room: chatroom_name
    }

    {:reply, {:text, to_json(response)}, session_id}
  end

  def websocket_info({_session_id, chatroom_name, msg}, session_id) do
    response = %{
      message: msg,
      room: chatroom_name
    }

    {:reply, {:text, to_json(response)}, session_id}
  end

  def websocket_terminate(_reason, _session_id) do
    :ok
  end

  defp handle(%{"command" => "join", "room" => room}, session_id) do
    ChatRooms.join(room, as: session_id)
    {:ok, session_id}
  end

  defp handle(command = %{"command" => "join"}, session_id) do
    handle(Map.put(command, "room", "default"), session_id)
  end

  defp handle(%{"room" => room, "message" => msg}, session_id) do
    case ChatRooms.send(msg, to: room, as: session_id) do
      :ok ->
        {:ok, session_id}
      {:error, :unexisting_room} ->
        response = %{error: room <> " does not exists"}
        {:reply, {:text, to_json(response)}, session_id}
    end
  end

  defp handle(%{"command" => "create", "room" => room}, session_id) do
    response = case ChatRooms.create(room) do
      :ok -> %{success: room <> " has been created!"}
      {:error, :already_exists} ->  %{error: room <> " already exists"}
    end

    {:reply, {:text, to_json(response)}, session_id}
  end

  defp handle(_not_handled_command, session_id), do: {:ok, session_id}

  defp to_json(response), do: Jason.encode!(response)
  defp from_json(json), do: Jason.decode(json)
end

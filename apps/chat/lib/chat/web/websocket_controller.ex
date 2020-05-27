defmodule Chat.Web.WebSocketController do
  @moduledoc """
  Implementation of the WebSocket transport
  """

  @behaviour :cowboy_websocket

  alias Chat.{UserSessions, ChatRooms}

  def init(req, state) do
    access_token = access_token_from(req)

    case find_user_session_by(access_token) do
      nil ->
        {:ok, :cowboy_req.reply(400, req), state}
      user_session ->
        {:cowboy_websocket, req, user_session}
    end
  end

  @doc """
  Websocket callbacks
  """
  def websocket_init(user_session) do
    UserSessions.subscribe(self(), to: user_session)
    {:ok, user_session}
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

  def websocket_info({from_user, chatroom_name, msg}, session_id) do
    response = %{
      from: from_user,
      message: msg,
      room: chatroom_name
    }

    {:reply, {:text, to_json(response)}, session_id}
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

  defp find_user_session_by(access_token) do
    case access_token do
      "AN_INVALID_ACCESS_TOKEN" -> nil
      "A_USER_ACCESS_TOKEN" -> "a-user"
      _ -> "default-user-session"
    end
  end

  defp access_token_from(req) do
    {"access_token", access_token} =
      :cowboy_req.parse_qs(req)
      |> Enum.find(fn({key, _value}) -> key == "access_token" end)
    access_token
  end
end

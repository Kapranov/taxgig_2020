defmodule Chat.Web.WebSocketController do
  @moduledoc """
  Implementation of the WebSocket transport
  """

  @behaviour :cowboy_websocket

  alias Chat.{UserSessions, ChatRooms}

  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  @doc """
  Websocket callbacks
  """
  def websocket_init(_) do
    #
    # {access_token, _req} = :cowboy_req.qs_val("access_token", req)
    #
    # {QVals, _} = cowboy_req:qs_vals(Req),
    # QVals = cowboy_req:parse_qs(Req),
    #
    # {QVals, _} = cowboy_req:qs_vals(Req2)
    # QVals = cowboy_req:parse_qs(Req2)
    #
    # {access_token, _req} = :cowboy_req.match_qs(["access_token"], req)
    #
    # data = :cowboy_req.parse_qs(req)
    # {access_token, _req} = :lists.keyfind(<<"access_token">>, 1, data)
    #
    # {echo := Echo} = cowboy_req:match_qs([{echo, [], :undefined}], Req0),
    #
    # {access_token, _} = :cowboy_req.match_qs([{"access_token", [], :undefined}], req)
    # access_token = ["A_USER_ACCESS_TOKEN", "default-user-session"] |> Enum.random
    access_token = "A_USER_ACCESS_TOKEN"
    user_session = find_user_session_by(access_token)
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

  def websocket_terminate(_reason, _req, _session_id) do
    :ok
  end

  def time_as_string do
    {hh, mm, ss} = :erlang.time()
    :io_lib.format("~2.10.0B:~2.10.0B:~2.10.0B", [hh, mm, ss])
    |> :erlang.list_to_binary()
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
      "A_USER_ACCESS_TOKEN" -> "a-user"
      _ -> "default-user-session"
    end
  end
end

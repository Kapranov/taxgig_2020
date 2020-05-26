defmodule Chat.UserSessions do
  @moduledoc false

  alias Chat.UserSession
  alias Chat.UserSessionSupervisor

  def create(user_session_id) do
    case UserSessionSupervisor.find(user_session_id) do
      nil ->
        UserSessionSupervisor.create(user_session_id)
        :ok
      _pid ->
        {:error, :already_exists}
    end
  end

  def subscribe(client_pid, [to: user_session_id]) do
    case UserSessionSupervisor.find(user_session_id) do
      nil -> {:error, :session_not_exists}
      pid -> UserSession.subscribe(pid, client_pid)
    end
  end

  def send(message, [to: user_session_id]) do
    case UserSessionSupervisor.find(user_session_id) do
      nil -> {:error, :session_not_exists}
      pid -> UserSession.send(pid, message)
    end
  end
end

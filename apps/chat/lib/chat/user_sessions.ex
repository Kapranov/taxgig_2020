defmodule Chat.UserSessions do
  @moduledoc false

  alias Chat.UserSession
  alias Chat.UserSessionSupervisor

  def create(user_session_id) do
    case UserSession.exists?(user_session_id) do
      true -> {:error, :already_exists}
      false ->
        UserSessionSupervisor.create(user_session_id)
        :ok
    end
  end

  def subscribe(client_pid, to: user_session_id) do
    case UserSession.find(user_session_id) do
      nil -> {:error, :session_not_exists}
      pid -> UserSession.subscribe(pid, client_pid)
    end
  end

  def send(msg, to: user_session_id) do
    case UserSession.find(user_session_id) do
      nil -> {:error, :session_not_exists}
      pid -> UserSession.send(pid, msg)
    end
  end
end

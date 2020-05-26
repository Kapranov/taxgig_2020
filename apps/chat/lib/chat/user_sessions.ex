defmodule Chat.UserSessions do
  @moduledoc false

  use DynamicSupervisor

  alias Chat.UserSession

  @name __MODULE__

  def create(user_session_id) do
    case find(user_session_id) do
      nil ->
        start(user_session_id)
      _pid ->
        {:error, :already_exists}
    end
  end

  def subscribe(client_pid, [to: user_session_id]) do
    case find(user_session_id) do
      nil -> {:error, :session_not_exists}
      pid -> UserSession.subscribe(pid, client_pid)
    end
  end

  def send(message, [to: user_session_id]) do
    case find(user_session_id) do
      nil -> {:error, :session_not_exists}
      pid -> UserSession.send(pid, message)
    end
  end

  def start_link(_arg) do
    DynamicSupervisor.start_link(@name, [], name: @name)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp start(user_session_id) do
    name = {:via, Registry, {UserSessionRegistry, user_session_id}}
    spec = %{id: Chat.UserSession, start: {Chat.UserSession, :start_link, [name]}, restart: :temporary}
    {:ok, _pid} = DynamicSupervisor.start_child(@name, spec)
    :ok
  end

  defp find(user_session_id) do
    case Registry.lookup(UserSessionRegistry, user_session_id) do
      [] -> nil
      [{pid, nil}] -> pid
    end
  end
end

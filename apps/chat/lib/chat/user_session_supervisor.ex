defmodule Chat.UserSessionSupervisor do
  @moduledoc false

  use DynamicSupervisor

  alias Chat.UserSessionRegistry

  @name __MODULE__

  def start_link(_arg) do
    DynamicSupervisor.start_link(@name, [], name: :user_session_supervisor)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def create(user_session_id) do
    name = {:via, Registry, {UserSessionRegistry, user_session_id}}
    spec = %{id: Chat.UserSession, start: {Chat.UserSession, :start_link, [name]}, restart: :temporary}
    DynamicSupervisor.start_child(:user_session_supervisor, spec)
  end

  def find(user_session_id) do
    case Registry.lookup(UserSessionRegistry, user_session_id) do
      [] -> nil
      [{pid, nil}] -> pid
    end
  end
end

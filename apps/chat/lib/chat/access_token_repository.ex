defmodule Chat.AccessTokenRepository do
  @moduledoc false

  use GenServer

  @name __MODULE__

  def add(access_token, user_session) do
    :ok = GenServer.call(:access_token_repository, {:add, access_token, user_session})
  end

  def find_user_session_by(access_token) do
    GenServer.call(:access_token_repository, {:find_user_session_by, access_token})
  end

  def start_link(_opts) do
    GenServer.start_link(@name, [], name: :access_token_repository)
  end

  def init(_args) do
    {:ok, %{}}
  end

  def handle_call({:add, access_token, user_session}, _from, state) do
    {:reply, :ok, Map.put(state, access_token, user_session)}
  end

  def handle_call({:find_user_session_by, access_token}, _from, state) do
    {:reply, Map.get(state, access_token), state}
  end
end

defmodule Chat do
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    case Mix.env do
      :benchmark ->
        [host: host, port: _port, ip: _ip] = Application.get_env(:server, ServerWeb.Endpoint)[:url]
        Logger.info("Running #{inspect(__MODULE__)} with Cowboy using http://#{host}:#{port()}")
      :dev ->
        [ip: _ip, scheme: schema, host: host, port: _port] = Application.get_env(:server, ServerWeb.Endpoint)[:url]
        Logger.info("Running #{inspect(__MODULE__)} with Cowboy using #{schema}://#{host}:#{port()}")
      :prod -> nil
      :test ->
        [host: host, port: _port, ip: _ip] = Application.get_env(:server, ServerWeb.Endpoint)[:url]
        Logger.info("Running #{inspect(__MODULE__)} with Cowboy using http://#{host}:#{port()}")
    end

    Chat.Application.start_link([])
  end

  @spec port :: integer()
  defp port, do: Application.get_env(:chat, :port, 4005)
end

defmodule Chat do
  @moduledoc false

  use Application
  require Logger

  @port Application.compile_env(:chat, :port, 4005)
  @url Application.compile_env(:server, ServerWeb.Endpoint)[:url]


  def start(_type, _args) do
    [ip: _ip, scheme: schema, host: host, port: _port] = @url
    case Mix.env do
      :benchmark ->
        Logger.info("Running #{inspect(__MODULE__)} with Cowboy using http://#{host}:#{port()}")
      :test ->
        Logger.info("Running #{inspect(__MODULE__)} with Cowboy using http://#{host}:#{port()}")
      :dev ->
        Logger.info("Running #{inspect(__MODULE__)} with Cowboy using #{schema}://#{host}:#{port()}")
      :prod -> nil
    end

    Chat.Application.start_link([])
  end

  @spec port :: integer()
  defp port, do: @port
end

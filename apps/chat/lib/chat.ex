defmodule Chat do
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    [ip: _ip, scheme: schema, host: host, port: _port] = Application.get_env(:server, ServerWeb.Endpoint)[:url]
    Logger.info("Running #{inspect(__MODULE__)} with Cowboy using #{schema}://#{host}:#{port()}")
    Chat.Application.start_link([])
  end

  defp port, do: Application.get_env(:chat, :port, 4005)
end

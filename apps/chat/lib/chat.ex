defmodule Chat do
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    Logger.info("Starting application… Chat at port: #{port()}")
    Chat.Application.start_link([])
  end

  defp port, do: Application.get_env(:chat, :port, 4005)
end

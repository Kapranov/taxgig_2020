defmodule Graphy.Config do
  @moduledoc false

  @port 4006

  @spec http_port :: integer()
  def http_port do
    case System.get_env("PORT") do
      nil ->
        Application.get_env(:graphy, :http_port) || @port
      port_as_string ->
        String.to_integer(port_as_string)
    end
  end
end

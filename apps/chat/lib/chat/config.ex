defmodule Chat.Config do
  @moduledoc false

  @port 4005
  @ten_minutes 1000 * 60 * 10
  @token "taxgig"

  def http_port do
    case System.get_env("PORT") do
      nil ->
        Application.get_env(:chat, :http_port) || @port
      port_as_string ->
        String.to_integer(port_as_string)
    end
  end

  def timer do
    case System.get_env("TIMER") do
      nil ->
        Application.get_env(:chat, :timer) || @ten_minutes
      timer_as_string ->
        String.to_integer(timer_as_string)
    end
  end

  def token do
    case System.get_env("TIMER") do
      nil ->
        Application.get_env(:chat, :token) || @token
      token ->
        token
    end
  end
end

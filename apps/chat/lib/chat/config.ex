defmodule Chat.Config do
  @moduledoc false

  @port Application.compile_env(:chat, :http_port) || 4005
  @ten_minutes Application.compile_env(:chat, :timer) || 1000 * 60 * 10
  @token Application.compile_env(:chat, :token) || "taxgig"

  def http_port do
    case System.get_env("PORT") do
      nil ->
        @port
      port_as_string ->
        String.to_integer(port_as_string)
    end
  end

  def timer do
    case System.get_env("TIMER") do
      nil ->
        @ten_minutes
      timer_as_string ->
        String.to_integer(timer_as_string)
    end
  end

  def token do
    case System.get_env("TIMER") do
      nil ->
        @token
      token ->
        token
    end
  end
end

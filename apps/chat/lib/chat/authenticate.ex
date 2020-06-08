defmodule Chat.Authenticate do
  @moduledoc false

  import Plug.Conn

  @auth_scheme "Bearer"

  def init(opts), do: opts

  def call(conn, opts) do
    header_content =
      if is_nil(opts[:token]) do
        nil
      else
        @auth_scheme <> " #{opts[:token]}"
      end

    conn
    |> get_auth_header()
    |> authenticate(header_content)
  end

  defp get_auth_header(conn) do
    {conn, get_req_header(conn, "authorization")}
  end

  defp authenticate({conn, [token]}, token), do: conn

  defp authenticate({conn, _}, _token) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{"code" => 401, "message" => "Not Authorized"}))
    |> halt()
  end
end

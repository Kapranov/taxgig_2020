defmodule Chat.Authenticate do
  @moduledoc false

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    conn |> get_auth_header() |> authenticate(opts[:token])
  end

  defp get_auth_header(conn) do
    {conn, get_req_header(conn, "authorization")}
  end

  defp authenticate({conn, [token]}, token), do: conn

  defp authenticate({conn, _}, _token) do
    conn |> send_resp(401, "Not Authorized") |> halt()
  end

  # [token] = Regex.run(~r/Bearer\s*(.*)/, header_content, capture: :all_but_first)
  # [_, [token]] = Regex.scan(~r/^Bearer|\w+/, header_content)
  # [_, token] = Regex.run(~r/Bearer\s*(.*)/, header_content)
  # [_, token] = String.split(header_content)
end

defmodule Chat.API.Doc do
  @moduledoc """
  Resource for API Doc
  """

  import Plug.Conn

  def show(conn) do
    send_resp(conn, 200, "Chat websocket manual")
  end
end

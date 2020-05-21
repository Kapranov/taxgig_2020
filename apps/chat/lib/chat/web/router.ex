defmodule Chat.Web.Router do
  @moduledoc false

  use Plug.Router

  alias Chat.Web.WebSocketController

  @name __MODULE__

  plug Plug.Static, at: "/", from: :chat
  plug :match
  plug :dispatch

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  def dispatch do
    [
      {:_,
        [
          {"/chat", WebSocketController, []},
          {:_, Plug.Cowboy.Handler, {@name, []}}
        ]
      }
    ]
  end
end

defmodule Chat.Web.Router do
  @moduledoc false

  use Plug.Router

  alias Chat.Web.WebSocketController
  alias Chat.Web.ChatRoomWebSocketController

  @name __MODULE__

  plug Plug.Static, at: "/", from: :chat, only: ~w(index.html)
  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "God Bless Trumpy Bear!")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  def dispatch do
    [
      {:_,
        [
          {"/chat", WebSocketController, []},
          {"/room", ChatRoomWebSocketController, []},
          {:_, Plug.Cowboy.Handler, {@name, []}}
        ]
      }
    ]
  end
end

defmodule Chat.Web.Router do
  @moduledoc false

  use Plug.Router

  alias Chat.Web.WebSocketController
  alias Plug.Cowboy.Handler
  alias Plug.Static

  @name __MODULE__

  plug Static, at: "/", from: :chat, only: ~w(chat.html)
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
          {:_, Handler, {@name, []}}
        ]
      }
    ]
  end
end

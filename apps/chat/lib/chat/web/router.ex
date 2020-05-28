defmodule Chat.Web.Router do
  @moduledoc """
  This module handles all routing for the Server,
  a plug responsible for logging request info, parsing request body's as JSON,
  matching routes, and dispatching responses.
  """

  use Plug.Router

  alias Chat.Web.WebSocketController
  alias Plug.Cowboy.Handler
  alias Plug.Static
  alias Chat.API.Doc

  if Mix.env == :dev, do: use Plug.Debugger

  @name __MODULE__
  @error "Oops... Nothing here :("

  plug(Plug.Logger)
  plug Static, at: "/", from: :chat, only: ~w(chat.html)
  plug :match
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)
  plug :dispatch

  get "/" do
    send(conn, 200, message())
  end

  get "/api/doc" do
    Doc.show(conn)
  end

  match _ do
    send(conn, :not_found, @error <> year_as_string() <> " " <> "#{time_as_string()}")
  end

  def dispatch do
    [
      {:_,
        [
          {"/ws", WebSocketController, %{}},
          {"/chat", WebSocketController, []},
          {:_, Handler, {@name, []}}
        ]
      }
    ]
  end

  defp message do
    %{
      channel: "realDonaldTrump",
      message: "God Bless Trumpy Bear! ;-)"
    }
  end

  defp send(conn, code, data) when is_integer(code) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(code, Jason.encode!(data))
  end

  defp send(conn, code, data) when is_atom(code) do
    code =
      case code do
        :ok                -> 200
        :not_found         -> 404
        :malformed_data    -> 400
        :non_authenticated -> 401
        :forbidden_access  -> 403
        :server_error      -> 500
        :error             -> 504
      end

    send(conn, code, data)
  end

  defp year_as_string do
    {y, m, d} = :erlang.date()
    "#{m}-#{d}-#{y}"
  end

  defp time_as_string do
    {hh, mm, ss} = :erlang.time()
    :io_lib.format("~2.10.0B:~2.10.0B:~2.10.0B", [hh, mm, ss])
    |> :erlang.list_to_binary()
  end
end

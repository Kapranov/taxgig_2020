defmodule Chat.Web.Endpoint do
  @moduledoc """
  This module handles all routing for the Server,
  a plug responsible for logging request info, parsing request body's as JSON,
  matching routes, and dispatching responses.
  """

  use Plug.Router
  use Plug.ErrorHandler

  require EEx

  alias Chat.API.Doc
  alias Chat.Config
  alias Chat.Web.SocketHandler
  alias Plug.Cowboy.Handler
  alias Plug.Static

  if Mix.env == :dev, do: use Plug.Debugger

  @content_type "application/json"
  @error "Oops... Nothing here :("
  @name __MODULE__

  plug(Plug.Logger, log: :debug)
  plug Chat.Authenticate, token: Config.token()
  plug Static, at: "/", from: :chat, only: ~w(chat.html)
  plug :match
  plug(Plug.Parsers, parsers: [:json], pass: [@content_type], json_decoder: Jason)
  plug :dispatch

  get "/" do
    send(conn, 200, message())
  end

  EEx.function_from_file(:defp, :chat_html, "priv/static/chat.html.eex", [])

  get "/live" do
    send_resp(conn, 200, chat_html())
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
          {"/chat", SocketHandler, []},
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
    |> put_resp_content_type(@content_type)
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

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect(kind, label: :kind)
    IO.inspect(reason, label: :reason)
    IO.inspect(stack, label: :stack)
    send_resp(conn, conn.status, "Something went wrong")
  end
end


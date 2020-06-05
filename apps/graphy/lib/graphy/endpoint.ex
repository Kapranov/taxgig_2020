defmodule Graphy.Endpoint do
  @moduledoc false

  use Plug.Router
  use Plug.ErrorHandler

  alias Plug.Cowboy.Handler

  if Mix.env == :dev, do: use Plug.Debugger

  @content_type "application/json"
  @error "Oops... Nothing here :("
  @name __MODULE__

  plug(Plug.Logger, log: :debug)
  plug(Plug.Parsers, parsers: [:json], pass: [@content_type], json_decoder: Jason)
  plug :match
  plug :dispatch

  get "/" do
    send(conn, 200, message())
  end

  match _ do
    send(conn, :not_found, @error)
  end

  def dispatch do
    [
      {:_,
        [
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

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect(kind, label: :kind)
    IO.inspect(reason, label: :reason)
    IO.inspect(stack, label: :stack)
    send_resp(conn, conn.status, "Something went wrong")
  end
end

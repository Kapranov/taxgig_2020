defmodule ServerWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :server
  use Absinthe.Phoenix.Endpoint

  [val1, val2, _] = Application.get_env(:server, ServerWeb.Endpoint)[:url]

  host = val1 |> elem(1)
  port = val2 |> elem(1) |> to_string

  origin =
    case Mix.env() do
      :prod -> ["https://api.taxgig.com"]
      :dev -> ["http://" <> host <> ":" <> port]
      _ -> false
    end

  socket "/socket", ServerWeb.UserSocket,
    websocket: [check_origin: origin],
    longpoll: false

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, {:multipart, length: 10_000_000}, :json, Absinthe.Plug.Parser],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug ServerWeb.Router
end

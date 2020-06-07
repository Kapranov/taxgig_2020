defmodule ServerWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :server
  use Absinthe.Phoenix.Endpoint

  alias Absinthe.Plug.Parser, as: AbsintheParser
  alias Phoenix.CodeReloader

  alias Plug.{
    Parsers,
    RequestId,
    Telemetry
  }

  alias ServerWeb.{
    Router,
    UserSocket
  }

  socket "/socket", UserSocket, websocket: true, longpoll: false

  if code_reloading? do
    plug CodeReloader
  end

  plug Plug.Static, at: "/", from: {:server, "priv/docs"}, gzip: false

  plug RequestId
  plug Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Parsers,
    parsers: [:urlencoded, {:multipart, length: 10_000_000}, :json, AbsintheParser],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug CORSPlug
  plug Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  @spec init(any(), %{atom => any}) :: {:ok, any()}
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end

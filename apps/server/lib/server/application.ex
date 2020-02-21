defmodule Server.Application do
  @moduledoc false

  use Application

  require Logger

  @doc """
  Starts the endpoint supervision tree.
  """
  @spec start(Application.start_type(), term()) ::
        {:error, reason :: term()} | {:ok, pid()} |
        {:ok, pid(), Application.state()}
  def start(_type, _args) do
    import Supervisor.Spec

    load_version()

    children = [
      supervisor(ServerWeb.Endpoint, []),
      supervisor(Absinthe.Subscription, [ServerWeb.Endpoint])
    ]

    opts = [strategy: :one_for_one, name: Server.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Callback that changes the configuration from the app callback.
  """
  def config_change(changed, _new, removed) do
    ServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  @spec load_version :: String.t()
  def load_version do
    [vsn, hash, date] =
      case File.read("VERSION") do
        {:ok, data} -> data |> String.split("\n")
        _ -> [nil, nil, nil]
      end

    version = %{vsn: vsn, hash: hash, date: date}
    Logger.info("Loading app version: #{inspect(version)}")
    Application.put_env(:server, :version, version)
  end
end

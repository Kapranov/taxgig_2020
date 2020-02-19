defmodule Server.Application do
  @moduledoc false

  use Application

  require Logger

  alias Core.Config
  alias ServerWeb.Endpoint

  @name Mix.Project.config()[:name]
  @version Mix.Project.config()[:version]

  @doc """
  """
  @spec user_agent :: String.t()
  def user_agent do
    info = "#{Endpoint.url()} <#{Config.get([:instance, :email], "")}>"
    "#{named_version()}; #{info}"
  end

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
    Endpoint.config_change(changed, removed)
    :ok
  end

  @spec named_version :: String.t()
  def named_version, do: "#{@name} #{@version}"

  # def version, do: Application.get_env(:server, :version)

  def version do
    case :application.get_key(:server, :version) do
      {:ok, version} -> to_string(version)
      _ -> "unknown"
    end
  end

  def version(key), do: version()[key]

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

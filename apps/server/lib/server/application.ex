defmodule Server.Application do
  @moduledoc false

  use Application

  require Logger

  @doc """
  Starts the endpoint supervision tree.
  """
  @spec start(Application.start_type(), start_args :: term()) ::
          {:ok, pid()} | {:ok, pid(), Application.state()} | {:error, reason :: term()}
  def start(_type, _args) do
    load_version()

    children = [
      ServerWeb.Endpoint,
      #{Phoenix.PubSub, name: Server.PubSub},
      {Phoenix.PubSub, [name: Server.PubSub, adapter: Phoenix.PubSub.PG2]},
      ServerWeb.Presence,
      {Absinthe.Subscription, ServerWeb.Endpoint},
      Supervisor.child_spec({Task.Supervisor, [name: Server.TaskSupervisor, max_restarts: 3]}, id: :task_supervisor, restart: :transient, shutdown: 30_000)
    ]

    opts = [strategy: :one_for_one, name: Server.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Callback that changes the configuration from the app callback.
  """
  @spec config_change(list(tuple()), list(tuple()), list(any())) :: :ok
  def config_change(changed, _new, removed) do
    ServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  @spec load_version() :: map()
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

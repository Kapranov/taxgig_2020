defmodule Mailings.Application do
  @moduledoc false

  use Application

  @spec start(Application.start_type(), start_args :: term()) ::
          {:ok, pid()} | {:ok, pid(), Application.state()} | {:error, reason :: term()}
  def start(_type, _args) do
    children = []

    opts = [strategy: :one_for_one, name: Mailings.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @spec version() :: String.t()
  def version() do
    case :application.get_key(:mailings, :vsn) do
      {:ok, version} -> to_string(version)
      _ -> "unknown"
    end
  end
end

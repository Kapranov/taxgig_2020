defmodule TalkJob.Application do
  @moduledoc false

  use Application

  @spec start(Application.start_type(), start_args :: term()) ::
          {:ok, pid()} | {:ok, pid(), Application.state()} | {:error, reason :: term()}
  def start(_type, _args) do
    children = [
      TalkJob.Repo,
      %{id: TalkJob.ProducerRegistry, start: {Registry, :start_link, [[keys: :unique, name: TalkJob.ProducerRegistry]]}},
      {DynamicSupervisor, strategy: :one_for_one, name: TalkJob.ProducerSupervisor}
    ]
    opts = [strategy: :one_for_one, name: TalkJob.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

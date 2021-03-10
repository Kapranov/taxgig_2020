defmodule Reptin.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      %{
        id: RethinkDB.Connection,
        start: {RethinkDB.Connection, :start_link, [[port: 28015, host: 'taxgig.com', name: :rethinkdb_connection]]}
      },
      %{
        id: Reptin.Database,
        start: {Reptin.Database, :start_link, [[db: "ptin", host: 'taxgig.com', port: 28015]]}
      }
    ]
    opts = [strategy: :one_for_one, name: Reptin.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

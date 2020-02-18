defmodule ServerWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ServerWeb.ConnCase, async: true`, although
  this option is not recommendded for other databases.
  """

  use ExUnit.CaseTemplate

  alias Phoenix.ConnTest
  alias Core.Repo
  alias Ptin.Repo, as: DB
  alias Ecto.Adapters.SQL.Sandbox, as: Adapter

  using do
    quote do
      use Phoenix.ConnTest
      use ExSpec
      alias Core.Accounts.User
      alias ServerWeb.Router.Helpers, as: Routes
      import Server.Factory

      @salt Application.get_env(:server, ServerWeb.Endpoint)[:salt]
      @secret Application.get_env(:server, ServerWeb.Endpoint)[:secret_key_base]

      def auth_conn(%Plug.Conn{} = conn, %User{} = user) do
        token = Phoenix.Token.sign(@secret, @salt, user.id)

        conn
        |> Plug.Conn.put_req_header("authorization", "Bearer #{token}")
        |> Plug.Conn.put_req_header("accept", "application/json")
      end

      @endpoint ServerWeb.Endpoint
    end
  end

  setup tags do
    :ok = Adapter.checkout(Repo) || Adapter.checkout(DB)

    unless tags[:async] do
      Adapter.mode(Repo, {:shared, self()})
      Adapter.mode(DB, {:shared, self()})
    end

    {:ok, conn: ConnTest.build_conn()}
  end
end

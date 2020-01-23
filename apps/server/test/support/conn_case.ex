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
  alias Ecto.Adapters.SQL.Sandbox, as: Adapter

  using do
    quote do
      use Phoenix.ConnTest
      use ExSpec
      alias ServerWeb.Router.Helpers, as: Routes
      import Server.Factory

      @endpoint ServerWeb.Endpoint
    end
  end

  setup tags do
    :ok = Adapter.checkout(Repo)

    unless tags[:async], do: Adapter.mode(Repo, {:shared, self()})

    {:ok, conn: ConnTest.build_conn()}
  end
end

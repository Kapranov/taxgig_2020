defmodule ServerWeb.Router do
  use ServerWeb, :router

  alias Absinthe.{
    Plug,
    Plug.GraphiQL
  }

  alias ServerWeb.{
    Context,
    GraphQL.Schema,
    UserSocket
  }

  pipeline :api do
    plug Context
    plug :accepts, ["json"]
    plug :inspect_conn, []
  end

  scope "/api", ServerWeb do
    pipe_through :api
  end


  scope "/" do
    pipe_through :api

    if Mix.env() == :dev || :test do
      forward "/graphiql", GraphiQL,
        analyze_complexity: true,
        max_complexity: 200,
        interface: :advanced,
        json_codec: Jason,
        schema: Schema,
        socket: UserSocket
    end

    forward "/", Plug, schema: Schema
  end

  def inspect_conn(conn, _) do
    "\n" |> IO.inspect()
    IO.inspect("#{inspect(conn.params)}")
    conn.request_path |> IO.inspect(label: :path)
    conn.params["operationName"] |> IO.inspect(label: :operationName)
    :io.format("~nquery: ~n~s~n", [conn.params["query"]])
    conn.params["variables"] |> IO.inspect(label: :variables)

    conn
  end
end

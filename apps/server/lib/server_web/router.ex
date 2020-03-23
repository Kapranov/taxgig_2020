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
  end

  scope "/api", ServerWeb do
    pipe_through :api
  end

  scope "/" do
    pipe_through :api

    if Mix.env() == :dev do
      forward "/graphiql", GraphiQL,
        analyze_complexity: true,
        max_complexity: 200,
        interface: :advanced,
        json_codec: Jason,
        schema: Schema,
        socket: UserSocket
    end

    forward "/api", Plug, schema: Schema
  end
end

defmodule Server.AbsintheHelpers do
  @moduledoc """
  Absinthe helpers for tests
  """

  use Phoenix.ConnTest

  alias Core.Accounts.User

  @endpoint ServerWeb.Endpoint
  @salt Application.get_env(:server, ServerWeb.Endpoint)[:salt]
  @secret Application.get_env(:server, ServerWeb.Endpoint)[:secret_key_base]

  def authenticate_conn(%Plug.Conn{} = conn, %User{} = user) do
    token = Phoenix.Token.sign(@secret, @salt, user.id)

    conn
    |> Plug.Conn.put_req_header("authorization", "Bearer #{token}")
    |> Plug.Conn.put_req_header("accept", "application/json")
  end

  def query_skeleton(query, query_name) do
    %{
      "operationName" => "#{query_name}",
      "query" => "query #{query_name} #{query}",
      "variables" => "{}"
    }
  end

  def mutation_skeleton(query) do
    %{
      "operationName" => "",
      "query" => "mutation #{query}",
      "variables" => ""
    }
  end

  def graphql_query(conn, options) do
    conn
    |> post("/graphiql", build_query(options[:query], options[:variables]))
    |> json_response(200)
  end

  defp build_query(query, variables) do
    %{
      "query" => query,
      "variables" => variables
    }
  end
end

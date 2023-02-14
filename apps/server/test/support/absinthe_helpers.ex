defmodule Server.AbsintheHelpers do
  @moduledoc """
  Absinthe helpers for tests
  """

  import Phoenix.ConnTest

  alias Core.Accounts.User

  @endpoint ServerWeb.Endpoint
  @salt Application.compile_env(:server, ServerWeb.Endpoint)[:salt]
  @secret Application.compile_env(:server, ServerWeb.Endpoint)[:secret_key_base]

  @spec authenticate_conn(Plug.Conn.t(), User.t()) :: Plug.Conn.t()
  def authenticate_conn(%Plug.Conn{} = conn, %User{} = user) do

    token =
      if is_nil(user), do: nil, else: Phoenix.Token.sign(@secret, @salt, user.id)

    conn
    |> Plug.Conn.put_req_header("authorization", "Bearer #{token}")
    |> Plug.Conn.put_req_header("accept", "application/json")
  end

  @spec authenticate_conn(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def authenticate_conn(%Plug.Conn{} = conn, _opts) do
    conn
  end

  @spec query_skeleton(String.t(), String.t()) :: %{atom => String.t()}
  def query_skeleton(query, query_name) do
    %{
      "operationName" => "#{query_name}",
      "query" => "query #{query_name} #{query}",
      "variables" => "{}"
    }
  end

  @spec mutation_skeleton(String.t()) :: %{atom => String.t()}
  def mutation_skeleton(query) do
    %{
      "operationName" => "",
      "query" => "mutation #{query}",
      "variables" => ""
    }
  end

  @spec graphql_query(Plug.Conn.t(), map()) :: %{atom => map()}
  def graphql_query(conn, options) do
    conn
    |> post("/graphiql", build_query(options[:query], options[:variables]))
    |> json_response(200)
  end

  @spec build_query(String.t(), String.t()) :: %{atom => any}
  defp build_query(query, variables) do
    %{
      "query" => query,
      "variables" => variables
    }
  end
end

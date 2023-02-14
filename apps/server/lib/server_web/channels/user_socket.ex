defmodule ServerWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: ServerWeb.GraphQL.Schema

  alias Phoenix.Token
  alias ServerWeb.Endpoint

  @max_age Application.compile_env(:server, Endpoint)[:max_age]
  @salt Application.compile_env(:server, Endpoint)[:salt]
  @secret Application.compile_env(:server, Endpoint)[:secret_key_base]

  def connect(%{"Authorization" => header_content}, socket, _connection_info) do
    [[_, token]] = Regex.scan(~r/^Bearer (.*)/, header_content)
    case Token.verify(@secret, @salt, token, max_age: @max_age) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}
      {:error, _} ->
        :error
    end
  end

  def connect(_params, _socket, connect_info) do
    IO.inspect connect_info
    :error
  end

  def id(_socket), do: nil
end

defmodule ServerWeb.Context do
  @moduledoc false

  @behaviour Plug

  import Plug.Conn

  alias Absinthe.Plug
  alias Core.Accounts
  alias Core.Accounts.User
  alias ServerWeb.Endpoint
  alias Phoenix.Token

  @type opts :: [context: map]

  @max_age Application.get_env(:server, Endpoint)[:max_age]
  @salt Application.get_env(:server, Endpoint)[:salt]
  @secret Application.get_env(:server, Endpoint)[:secret_key_base]

  @spec init(opts :: opts()) :: map()
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, _) do
    context = build_context(conn)
    Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  @spec build_context(Plug.Conn.t()) :: %{current_user: User.t()} | map()
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
      {:ok, current_user} <- authorize(token) do
        %{current_user: current_user}
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    case Token.verify(@secret, @salt, token, max_age: @max_age) do
      {:error, :invalid} ->
        {:error, "invalid authorization token"}
      {:error, :expired} ->
        {:error, "token has been expired or revoked"}
      {:ok, user_id} ->
        try do
          with struct <- Accounts.get_user!(user_id) do
            {:ok, struct}
          end
        rescue
          Ecto.NoResultsError ->
            {:error, "An User #{user_id} not found!"}
        end
    end
  end
end

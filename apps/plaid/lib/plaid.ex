defmodule Plaid do
  @moduledoc """
  An HTTP Client for Plaid.

  [Plaid API Docs](https://plaid.com/docs/api)
  """

  use HTTPoison.Base

  @client_id Application.compile_env(:plaid, :client_id)
  @options Application.compile_env(:plaid, :httpoison_options, [])
  @root_uri Application.compile_env(:plaid, :root_uri)
  @secret Application.compile_env(:plaid, :secret)

  defmodule MissingClientIdError do
    defexception message: """
                 The `client_id` is required for calls to Plaid. Please either configure `client_id`
                 in your config.exs file or pass it into the function via the `config` argument.

                 config :plaid, client_id: "your_client_id"
                 """
  end

  defmodule MissingSecretError do
    defexception message: """
                 The `secret` is required for calls to Plaid. Please either configure `secret`
                 in your config.exs file or pass it into the function via the `config` argument.

                 config :plaid, secret: "your_secret"
                 """
  end

  defmodule MissingPublicKeyError do
    defexception message: """
                 The `public_key` is required for some unauthenticated endpoints. Please either
                 configure `public_key` in your config.exs or pass it into the function
                 via the `config` argument.

                 config :plaid, public_key: "your_public_key"
                 """
  end

  defmodule MissingRootUriError do
    defexception message: """
                 The root_uri is required to specify the Plaid environment to which you are
                 making calls, i.e. sandbox, development or production. Please configure root_uri in
                 your config.exs file.

                 config :plaid, root_uri: "https://sandbox.plaid.com/" (test)
                 config :plaid, root_uri: "https://development.plaid.com/" (development)
                 config :plaid, root_uri: "https://production.plaid.com/" (production)
                 """
  end

  @doc """
  Makes request with credentials.
  """
  @spec make_request_with_cred(atom, String.t(), map, map, map, Keyword.t()) :: {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def make_request_with_cred(method, endpoint, config, body \\ %{}, headers \\ %{}, options \\ []) do
    request_endpoint = "#{get_root_uri(config)}#{endpoint}"
    cred = Map.delete(config, :root_uri)
    request_body = Map.merge(body, cred) |> Jason.encode!()
    request_headers = get_request_headers() |> Map.merge(headers) |> Map.to_list()
    options = httpoison_request_options() ++ options
    request(method, request_endpoint, request_body, request_headers, options)
  end

  @doc """
  Gets the `client_id` and `secret` from config argument or the library configuration.
  """
  @spec validate_cred(map) :: map | no_return
  def validate_cred(config) do
    %{
      client_id: get_client_id(config),
      secret: get_secret(config),
      root_uri: get_root_uri(config)
    }
  end

  defp get_client_id(config) do
    case Map.get(config, :client_id) || @client_id do
      nil ->
        raise MissingClientIdError
      client_id ->
        client_id
    end
  end

  defp get_secret(config) do
    case Map.get(config, :secret) || @secret do
      nil ->
        raise MissingSecretError
      secret ->
        secret
    end
  end

  defp get_root_uri(config) do
    case Map.get(config, :root_uri) || @root_uri do
      nil ->
        raise MissingRootUriError
      root_uri ->
        root_uri
    end
  end

  defp get_request_headers do
    Map.new()
    |> Map.put("Content-Type", "application/json")
  end

  defp httpoison_request_options, do: @options
end

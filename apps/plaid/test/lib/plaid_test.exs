defmodule PlaidTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open()
    Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  defp cleanup_config do
    Application.put_env(:plaid, :client_id, "test_id")
    Application.put_env(:plaid, :secret, "test_secret")
    Application.put_env(:plaid, :public_key, "s3cret")
  end
end

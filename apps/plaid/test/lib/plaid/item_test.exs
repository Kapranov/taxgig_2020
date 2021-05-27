defmodule Plaid.ItemTest do
  use ExUnit.Case

  import Plaid.Factory

  setup do
    bypass = Bypass.open()
    Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "item" do
    test "create_public_token/1 request POST and returns map", %{bypass: bypass} do
      body = http_response_body(:create_public_token)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "sandbox/public_token/create" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Jason.encode!(body))
      end)

      params = %{
        initial_products: ["your_initial_products"],
        institution_id: "your_institution_id",
        options: %{webhook: "your_webhook"},
        public_key: "your_public_key"
      }

      assert {:ok, resp} = Plaid.Item.create_public_token(params)
      assert resp["public_token"] == body["public_token"]
      assert resp["expiration"]   == body["expiration"]
      assert resp["request_id"]   == body["request_id"]
    end

    test "exchange_public_token/1 requests POST and returns map", %{bypass: bypass} do
      body = http_response_body(:exchange_public_token)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "item/public_token/exchange" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Jason.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Item.exchange_public_token(%{public_token: "public-token"})
      assert resp["access_token"] == body["access_token"]
      assert resp["item_id"]      == body["item_id"]
      assert resp["request_id"]   == body["request_id"]
    end
  end
end

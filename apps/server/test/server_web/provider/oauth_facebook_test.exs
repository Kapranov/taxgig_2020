defmodule ServerWeb.Provider.OauthFacebookTest do
  use ExUnit.Case
  doctest ServerWeb.Provider.OauthFacebook

  import Mox

  test "get Facebook login url" do
    facebook_auth_url = "https://www.facebook.com/v6.0/dialog/oauth?response_type=code"
    client_id = Application.get_env(:server, :client_id, 123)
    client_secret = Application.get_env(:server, :client_secret, 123)
    redirect_uri = Application.get_env(:server, :redirect_uri, "https://taxgig.me:4001/graphiql")

    url = "#{facebook_auth_url}client_id=#{client_id}&client_secret=#{client_secret}&redirect_uri=#{redirect_uri}"

    HTTPoisonFacebookMock
    |> expect(:generate_url, fn -> "#{url}" end)

    assert HTTPoisonFacebookMock.generate_url() =~ url
  end

  test "get refresh token login url" do
    facebook_code_url = "https://graph.facebook.com/oauth/client_code?"
    client_id = Application.put_env(:server, :client_id, 123)
    client_secret = Application.get_env(:server, :client_secret, 123)
    redirect_uri = Application.get_env(:server, Facebook)[:redirect_uri]
    token = "1234"
    url = "#{facebook_code_url}client_id=#{client_id}&client_secret=#{client_secret}&redirect_uri=#{redirect_uri}&access_token=#{token}"

    HTTPoisonFacebookMock
    |> expect(:generate_refresh_token_url, fn _ -> "#{url}" end)

    assert HTTPoisonFacebookMock.generate_refresh_token_url(token) =~ url
  end

  test "get token" do
  end

  test "get refresh token" do
  end

  test "get verify token" do
  end

  test "get user profile" do
  end

  test "return error with incorrect token" do
  end

  test "return error with incorrect when token is nil" do
  end

  test "return error with incorrect when token string is blank" do
  end

  test "return error with incorrect when token is integer" do
  end

  test "return error with incorrect when token is float" do
  end

  test "return error with incorrect refresh token" do
  end

  test "return error with incorrect refresh when token is nil" do
  end

  test "return error with incorrect refresh when token string is blank" do
  end

  test "return error with incorrect refresh when token is integer" do
  end

  test "return error with incorrect refresh when token is float" do
  end

  test "return error with incorrect verify token" do
  end

  test "return error with incorrect verify when token is nil" do
  end

  test "return error with incorrect verify when token string is blank" do
  end

  test "return error with incorrect verify when token is integer" do
  end

  test "return error with incorrect verify when token is float" do
  end

  test "return error with incorrect user profile" do
  end

  test "return error with incorrect user profile when token is nil" do
  end

  test "return error with incorrect user profile when token string is blank" do
  end

  test "return error with incorrect user profile when token string is integer" do
  end

  test "return error with incorrect user profile when token string is float" do
  end

  test "return error with incorrect user email" do
  end

  test "return error with incorrect user email when token is nil" do
  end

  test "return error with incorrect user email when token string is blank" do
  end

  test "return error with incorrect user email when token is integer" do
  end

  test "return error with incorrect user email when token is float" do
  end
end

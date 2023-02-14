defmodule ServerWeb.Provider.OauthGoogleTest do
  use ExUnit.Case
  doctest ServerWeb.Provider.OauthGoogle

  import Mox

  test "get login url" do
    google_auth_url = "https://accounts.google.com/o/oauth2/v2/auth?response_type=code"
    client_id = Application.put_env(:server, :client_id, 123)
    scope = Application.put_env(:server, :scope, "profile+email")
    redirect_uri = Application.compile_env(:server, Google)[:redirect_uri]

    url = "#{google_auth_url}&client_id=#{client_id}&scope=#{scope}&redirect_uri=#{redirect_uri}"

    HTTPoisonGoogleMock
    |> expect(:generate_url, fn -> "#{url}" end)

    assert HTTPoisonGoogleMock.generate_url() =~ url
  end

  test "get refresh token login url" do
    google_auth_url = "https://accounts.google.com/o/oauth2/v2/auth?response_type=code&access_type=offline&prompt=consent&include_granted_scopes=true"
    client_id = Application.put_env(:server, :client_id, 123)
    scope = Application.put_env(:server, :scope, "profile+email")
    redirect_uri = Application.compile_env(:server, Google)[:redirect_uri]

    url = "#{google_auth_url}&client_id=#{client_id}&scope=#{scope}&redirect_uri=#{redirect_uri}"

    HTTPoisonGoogleMock
    |> expect(:generate_refresh_token_url, fn -> "#{url}" end)

    assert HTTPoisonGoogleMock.generate_refresh_token_url() =~ url
  end

  test "get token" do
    data = %{
      "access_token" => "123456789",
      "expires_in" => 1234,
      "id_token" => "123456789",
      "scope" => "openid userinfo.profile userinfo.email",
      "token_type" => "Bearer"
    }

    HTTPoisonGoogleMock
    |> expect(:token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.token("ok_code") == {:ok, data}
  end

  test "get refresh token" do
    data = %{
      "access_token" => "123456789",
      "expires_in" => 1234,
      "id_token" => "123456789",
      "scope" => "openid userinfo.email userinfo.profile",
      "token_type" => "Bearer"
    }

    HTTPoisonGoogleMock
    |> expect(:refresh_token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.refresh_token("1234") == {:ok, data}
  end

  test "get verify token" do
    data = %{
      "access_type" => "online",
      "aud" => "123456789",
      "azp" => "123456789",
      "email" => "test@example.com",
      "email_verified" => "true",
      "exp" => "123456789",
      "expires_in" => "1234",
      "scope" => "userinfo.profile userinfo.email openid",
      "sub" => "123456789"
    }

    HTTPoisonGoogleMock
    |> expect(:verify_token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.verify_token("1234") == {:ok, data}
  end

  test "get user profile" do
    data = %{
      "email" => "test@example.com",
      "email_verified" => true,
      "family_name" => "xxx",
      "given_name" => "xxx",
      "locale" => "xx",
      "name" => "xxx xxx",
      "picture" => "xxx",
      "sub" => "123456789"
    }

    HTTPoisonGoogleMock
    |> expect(:user_profile, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.user_profile("1234") == {:ok, data}
  end

  test "get user email" do
    data = %{
      "email" => "test@example.com",
      "family_name" => "xxx",
      "given_name" => "xxx",
      "id" => "123456789",
      "locale" => "xx",
      "name" => "xxx xxx",
      "picture" => "xxx",
      "verified_email" => true
    }

    HTTPoisonGoogleMock
    |> expect(:user_email, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.user_email("1234") == {:ok, data}
  end

  test "return error with incorrect token" do
    data = %{
      "error" => "invalid_grant",
      "error_description" => "Bad Request"
    }

    HTTPoisonGoogleMock
    |> expect(:token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.token("wrong_token") == {:ok, data}
  end

  test "return error with incorrect when token is nil" do
    data = {
      :error,
      [field: :code, message: "Code is invalid or can't be blank"]
    }

    HTTPoisonGoogleMock
    |> expect(:token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.token(nil) == {:ok, data}
  end

  test "return error with incorrect when token string is blank" do
    data = %{
      "error" => "invalid_request",
      "error_description" => "Missing required parameter: code"
    }

    HTTPoisonGoogleMock
    |> expect(:token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.token("") == {:ok, data}
  end

  test "return error with incorrect when token is integer" do
    data = {
      :error,
      [field: :code, message: "Code is invalid and not string"]
    }

    HTTPoisonGoogleMock
    |> expect(:token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.token(123) == {:ok, data}
  end

  test "return error with incorrect when token is float" do
    data = {
      :error,
      [field: :code, message: "Code is invalid or can't be blank"]
    }

    HTTPoisonGoogleMock
    |> expect(:token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.token(1.23) == {:ok, data}
  end

  test "return error with incorrect refresh token" do
    data = %{
      "error" => "invalid_grant",
      "error_description" => "Bad Request"
    }

    HTTPoisonGoogleMock
    |> expect(:refresh_token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.refresh_token("wrong_token") == {:ok, data}
  end

  test "return error with incorrect refresh when token is nil" do
    data = {
      :error,
      [field: :token, message: "Token is invalid or can't be blank"]
    }

    HTTPoisonGoogleMock
    |> expect(:refresh_token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.refresh_token(nil) == {:ok, data}
  end

  test "return error with incorrect refresh when token string is blank" do
    data = %{
      "error" => "invalid_request",
      "error_description" => "Missing required parameter: refresh_token"
    }

    HTTPoisonGoogleMock
    |> expect(:refresh_token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.refresh_token("") == {:ok, data}
  end

  test "return error with incorrect refresh when token is integer" do
    data = {
      :error,
      [field: :token, message: "Token is invalid and not string"]
    }

    HTTPoisonGoogleMock
    |> expect(:refresh_token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.refresh_token(123) == {:ok, data}
  end

  test "return error with incorrect refresh when token is float" do
    data = {
      :error,
      [field: :token, message: "Token is invalid or can't be blank"]
    }

    HTTPoisonGoogleMock
    |> expect(:refresh_token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.refresh_token(1.23) == {:ok, data}
  end

  test "return error with incorrect verify token" do
    data = %{
      "error_description" => "Invalid Value"
    }

    HTTPoisonGoogleMock
    |> expect(:verify_token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.verify_token("wrong_token") == {:ok, data}
  end

  test "return error with incorrect verify when token is nil" do
    data = {
      :error,
      [field: :token, message: "Token is invalid or can't be blank"]
    }

    HTTPoisonGoogleMock
    |> expect(:verify_token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.verify_token(nil) == {:ok, data}
  end

  test "return error with incorrect verify when token string is blank" do
    data = %{
      "error_description" => "Either access_token, id_token, or token_handle required"
    }

    HTTPoisonGoogleMock
    |> expect(:verify_token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.verify_token("") == {:ok, data}
  end

  test "return error with incorrect verify when token is integer" do
    data = {
      :error,
      [field: :token, message: "Token is invalid and not string"]
    }

    HTTPoisonGoogleMock
    |> expect(:verify_token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.verify_token(123) == {:ok, data}
  end

  test "return error with incorrect verify when token is float" do
    data = {
      :error,
      [field: :token, message: "Token is invalid or can't be blank"]
    }

    HTTPoisonGoogleMock
    |> expect(:verify_token, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.verify_token(1.23) == {:ok, data}
  end

  test "return error with incorrect user profile" do
    data = %{
      "error" => "invalid_request",
      "error_description" => "Invalid Credentials"
    }

    HTTPoisonGoogleMock
    |> expect(:user_profile, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.user_profile("wrong_token") == {:ok, data}
  end

  test "return error with incorrect user profile when token is nil" do
    data = {
      :error,
      [field: :token, message: "Token is invalid or can't be blank"]
    }

    HTTPoisonGoogleMock
    |> expect(:user_profile, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.user_profile(nil) == {:ok, data}
  end

  test "return error with incorrect user profile when token string is blank" do
    data = %{
      "error" => "invalid_request",
      "error_description" => "Invalid Credentials"
    }

    HTTPoisonGoogleMock
    |> expect(:user_profile, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.user_profile("") == {:ok, data}
  end

  test "return error with incorrect user profile when token string is integer" do
    data = {
      :error,
      [field: :token, message: "Token is invalid and not string"]
    }

    HTTPoisonGoogleMock
    |> expect(:user_profile, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.user_profile(123) == {:ok, data}
  end

  test "return error with incorrect user profile when token string is float" do
    data = {
      :error,
      [field: :token, message: "Token is invalid or can't be blank"]
    }

    HTTPoisonGoogleMock
    |> expect(:user_profile, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.user_profile(1.23) == {:ok, data}
  end

  test "return error with incorrect user email" do
    data = %{
      "error" => %{
        "code" => 401,
        "message" => "Request is missing required authentication credential",
        "status" => "UNAUTHENTICATED"
      }
    }

    HTTPoisonGoogleMock
    |> expect(:user_email, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.user_email("wrong_token") == {:ok, data}
  end

  test "return error with incorrect user email when token is nil" do
    data = {
      :error,
      [field: :token, message: "Token is invalid or can't be blank"]
    }

    HTTPoisonGoogleMock
    |> expect(:user_email, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.user_email(nil) == {:ok, data}
  end

  test "return error with incorrect user email when token string is blank" do
    data = %{
      "error" => %{
        "code" => 401,
        "message" => "Request is missing required authentication credential.",
        "status" => "UNAUTHENTICATED"
      }
    }

    HTTPoisonGoogleMock
    |> expect(:user_email, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.user_email("") == {:ok, data}
  end

  test "return error with incorrect user email when token is integer" do
    data = {
      :error,
      [field: :token, message: "Token is invalid and not string"]
    }

    HTTPoisonGoogleMock
    |> expect(:user_email, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.user_email(123) == {:ok, data}
  end

  test "return error with incorrect user email when token is float" do
    data = {
      :error,
      [field: :token, message: "Token is invalid or can't be blank"]
    }

    HTTPoisonGoogleMock
    |> expect(:user_email, fn _ -> {:ok, data} end)

    assert HTTPoisonGoogleMock.user_email(1.23) == {:ok, data}
  end
end

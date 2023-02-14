defmodule ServerWeb.Provider.OauthLinkedInTest do
  use ExUnit.Case

  import Mox

  test "get login url" do
    linkedin_auth_url = "https://www.linkedin.com/oauth/v2/authorization?response_type=code"
    client_id = Application.compile_env(:server, :client_id, 123)
    redirect_uri = Application.compile_env(:community, :redirect_uri, "https://taxgig.me:4001/graphiql")
    state = Application.compile_env(:server, :state, "pureagency")
    scope = Application.compile_env(:server, :scope, "r_liteprofile%20r_emailaddress%20")

    url = "#{linkedin_auth_url}&client_id=#{client_id}&redirect_uri=#{redirect_uri}&state=#{state}&scope=#{scope}"

    HTTPoisonLinkedInMock
    |> expect(:generate_url, fn -> "#{url}" end)

    assert HTTPoisonLinkedInMock.generate_url() =~ url
  end

  test "get refresh token url" do
    data = "created_refresh_token_url"

    HTTPoisonLinkedInMock
    |> expect(:generate_refresh_token_url, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.generate_refresh_token_url("ok_token") == {:ok, data}
  end

  test "get token" do
    data = %{
      "access_token" => "ok_token",
      "expires_in" => 5184000
    }

    HTTPoisonLinkedInMock
    |> expect(:token, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.token("ok_code") == {:ok, data}
  end

  test "get refresh token" do
    data = %{
      "error" => "access_denied",
      "error_description" => "Refresh token not allowed"
    }

    HTTPoisonLinkedInMock
    |> expect(:refresh_token, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.refresh_token("ok_token") == {:ok, data}
  end

  test "get verify token" do
    data = "correct_email"

    HTTPoisonLinkedInMock
    |> expect(:verify_token, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.verify_token("ok_token") == {:ok, data}
  end

  test "get user profile" do
    data = %{
      "localizedFirstName" => "xxx",
      "localizedLastName" => "xxx",
      "profilePicture" => %{
        "displayImage~" => %{
          "elements" => [%{
            "identifiers" => [%{
                "identifier" => "image_url"
            }]
          }]
        }
      }
    }

    HTTPoisonLinkedInMock
    |> expect(:user_profile, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.user_profile("ok_token") == {:ok, data}
  end

  test "get user email" do
    data = %{
      "elements" => [
        %{
          "handle~" => %{"emailAddress" => "test@example.com"}
        }
      ]
    }

    HTTPoisonLinkedInMock
    |> expect(:user_email, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.user_email("ok_token") == {:ok, data}
  end

  test "return error with incorrect refresh token url" do
    data = "wrong_url"

    HTTPoisonLinkedInMock
    |> expect(:generate_refresh_token_url, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.generate_refresh_token_url("wrong_token") == {:ok, data}
  end

  test "return error with incorrect refresh token url when token is nil" do
    data = {
      :error,
      [field: :token, message: "Token is invalid and not string"]
    }

    HTTPoisonLinkedInMock
    |> expect(:generate_refresh_token_url, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.generate_refresh_token_url(nil) == {:ok, data}
  end

  test "return error with incorrect refresh token url when token string is blank" do
    data = "wrong_url"

    HTTPoisonLinkedInMock
    |> expect(:generate_refresh_token_url, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.generate_refresh_token_url("") == {:ok, data}
  end

  test "return error with incorrect refresh token url when token string is integer" do
    data = {
      :error,
      [field: :code, message: "Code is invalid or can't be blank"]
    }

    HTTPoisonLinkedInMock
    |> expect(:generate_refresh_token_url, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.generate_refresh_token_url(123) == {:ok, data}
  end

  test "return error with incorrect refresh token url when token string is float" do
    data = {
      :error,
      [field: :token, message: "Token is invalid and not string"]
    }

    HTTPoisonLinkedInMock
    |> expect(:generate_refresh_token_url, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.generate_refresh_token_url(123) == {:ok, data}
  end

  test "return error with incorrect when token is nil" do
    data = {
      :error,
      [field: :code, message: "Code is invalid or can't be blank"]
    }

    HTTPoisonLinkedInMock
    |> expect(:token, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.token(nil) == {:ok, data}
  end

  test "return error with incorrect when token string is blank" do
    data = %{
      "error" => "invalid_request",
      "error_description" => "A required parameter \"code\" is missing"
    }

    HTTPoisonLinkedInMock
    |> expect(:token, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.token("") == {:ok, data}
  end

  test "return error with incorrect when token string is integer" do
    data = {
      :error,
      [field: :code, message: "Code is invalid and not string"]
    }

    HTTPoisonLinkedInMock
    |> expect(:token, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.token(123) == {:ok, data}
  end

  test "return error with incorrect when token string is float" do
    data = {
      :error,
      [field: :code, message: "Code is invalid or can't be blank"]
    }

    HTTPoisonLinkedInMock
    |> expect(:token, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.token(1.23) == {:ok, data}
  end

  test "return error with incorrect when refresh token is nil" do
    data = {
      :error,
      [field: :token, message: "Token is invalid or can't be blank"]
    }

    HTTPoisonLinkedInMock
    |> expect(:refresh_token, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.refresh_token(nil) == {:ok, data}
  end

  test "return error with incorrect when refresh token string is blank" do
    data = %{
      "error" => "invalid_request",
      "error_description" => "A required parameter \"refresh_token\" is missing"
    }

    HTTPoisonLinkedInMock
    |> expect(:refresh_token, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.refresh_token("") == {:ok, data}
  end

  test "return error with incorrect when refresh token is integer" do
    data = {
      :error,
      [field: :token, message: "Token is invalid and not string"]
    }

    HTTPoisonLinkedInMock
    |> expect(:refresh_token, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.refresh_token(123) == {:ok, data}
  end

  test "return error with incorrect when refresh token is float" do
    data = {
      :error,
      [field: :token, message: "Token is invalid or can't be blank"]
    }

    HTTPoisonLinkedInMock
    |> expect(:refresh_token, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.refresh_token(1.23) == {:ok, data}
  end

  test "return error with incorrect verify token when token is nil" do
    data = {
      :error,
      [field: :token, message: "Token is invalid or can't be blank"]
    }

    HTTPoisonLinkedInMock
    |> expect(:verify_token, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.verify_token(nil) == {:ok, data}
  end

  test "return error with incorrect verify token when token string is blank" do
    data = {:error, "Invalid access token"}

    HTTPoisonLinkedInMock
    |> expect(:verify_token, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.verify_token("") == {:ok, data}
  end

  test "return error with incorrect verify token when token is integer" do
    data = {
      :error,
      [field: :token, message: "Token is invalid and not string"]
    }

    HTTPoisonLinkedInMock
    |> expect(:verify_token, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.verify_token(123) == {:ok, data}
  end

  test "return error with incorrect verify token when token is float" do
    data = {
      :error,
      [field: :token, message: "Token is invalid or can't be blank"]
    }

    HTTPoisonLinkedInMock
    |> expect(:verify_token, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.verify_token(1.23) == {:ok, data}
  end

  test "return error with incorrect user profile when token is nil" do
    data = {
      :error,
      [field: :token, message: "Token is invalid or can't be blank"]
    }

    HTTPoisonLinkedInMock
    |> expect(:user_profile, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.user_profile(nil) == {:ok, data}
  end

  test "return error with incorrect user profile when token string is blank" do
    data = %{
      "message" => "Empty oauth2 access token",
      "serviceErrorCode" => 65604,
      "status" => 401
    }

    HTTPoisonLinkedInMock
    |> expect(:user_profile, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.user_profile("") == {:ok, data}
  end

  test "return error with incorrect user profile when token is integer" do
    data = {
      :error,
      [field: :token, message: "Token is invalid and not string"]
    }

    HTTPoisonLinkedInMock
    |> expect(:user_profile, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.user_profile(123) == {:ok, data}
  end

  test "return error with incorrect user profile when token is float" do
    data = {
      :error,
      [field: :token, message: "Token is invalid or can't be blank"]
    }

    HTTPoisonLinkedInMock
    |> expect(:user_profile, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.user_profile(1.23) == {:ok, data}
  end

  test "return error with incorrect user email when token is nil" do
    data = {
      :error,
      [field: :token, message: "Token is invalid or can't be blank"]
    }

    HTTPoisonLinkedInMock
    |> expect(:user_email, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.user_email(nil) == {:ok, data}
  end

  test "return error with incorrect user email when token string is blank" do
    data = %{
      "message" => "Empty oauth2 access token",
      "serviceErrorCode" => 65604,
      "status" => 401
    }

    HTTPoisonLinkedInMock
    |> expect(:user_email, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.user_email("") == {:ok, data}
  end

  test "return error with incorrect user email when token is integer" do
    data = {
      :error,
      [field: :token, message: "Token is invalid and not string"]
    }

    HTTPoisonLinkedInMock
    |> expect(:user_email, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.user_email(123) == {:ok, data}
  end

  test "return error with incorrect user email when token is float" do
    data = {
      :error,
      [field: :token, message: "Token is invalid or can't be blank"]
    }

    HTTPoisonLinkedInMock
    |> expect(:user_email, fn _ -> {:ok, data} end)

    assert HTTPoisonLinkedInMock.user_email(1.23) == {:ok, data}
  end
end

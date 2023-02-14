defmodule ServerWeb.Provider.OauthFacebookTest do
  use ExUnit.Case
  doctest ServerWeb.Provider.OauthFacebook

  import Mox

  test "get Facebook login url" do
    facebook_auth_url = "https://www.facebook.com/v6.0/dialog/oauth?response_type=code"
    client_id = Application.compile_env(:server, :client_id, 123)
    client_secret = Application.compile_env(:server, :client_secret, 123)
    redirect_uri = Application.compile_env(:server, :redirect_uri, "https://taxgig.me:4001/graphiql")

    url = "#{facebook_auth_url}client_id=#{client_id}&client_secret=#{client_secret}&redirect_uri=#{redirect_uri}"

    HTTPoisonFacebookMock
    |> expect(:generate_url, fn -> "#{url}" end)

    assert HTTPoisonFacebookMock.generate_url() =~ url
  end

  test "get refresh token login url" do
    facebook_code_url = "https://graph.facebook.com/oauth/client_code?"
    client_id = Application.put_env(:server, :client_id, 123)
    client_secret = Application.compile_env(:server, :client_secret, 123)
    redirect_uri = Application.compile_env(:server, Facebook)[:redirect_uri]
    token = "1234"
    url = "#{facebook_code_url}client_id=#{client_id}&client_secret=#{client_secret}&redirect_uri=#{redirect_uri}&access_token=#{token}"

    HTTPoisonFacebookMock
    |> expect(:generate_refresh_token_url, fn _ -> "#{url}" end)

    assert HTTPoisonFacebookMock.generate_refresh_token_url(token) =~ url
  end

  test "get token" do
    data = %{
      "access_token" => "ok_token",
      "expires_in" => 5184000,
      "token_type" => "bearer"
    }

    HTTPoisonFacebookMock
    |> expect(:token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.token("ok_code") == {:ok, data}
  end

  test "get refresh token" do
    data = %{
      "access_token" => "123456789",
      "expires_in" => 1234,
      "token_type" => "Bearer"
    }

    HTTPoisonFacebookMock
    |> expect(:refresh_token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.refresh_token("1234") == {:ok, data}
  end

  test "get verify token" do
    data = %{
      "access_token" => "123456789",
      "expires_in" => 1234,
      "token_type" => "Bearer"
    }

    HTTPoisonFacebookMock
    |> expect(:verify_token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.verify_token("1234") == {:ok, data}
  end

  test "get user profile" do
    data = %{
      "email" => "lugatex@yahoo.com",
      "first_name" => "Kapranov",
      "id" => "2823281904434541",
      "last_name" => "Oleg",
      "middle_name" => "George",
      "name" => "Oleg George Kapranov",
      "picture" => %{
        "data" => %{
          "url" => "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=2823281904434541&height=100&width=100&ext=1598436540&hash=AeTgxQxfu2AJ2jD4"
        }
      }
    }

    HTTPoisonFacebookMock
    |> expect(:user_profile, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.user_profile("1234") == {:ok, data}
  end

  test "return error with incorrect token" do
    data = %{
      "error" => %{
        "code" => 100,
        "fbtrace_id" => "AWzoID6UdArEa7F6hcoBtXR",
        "message" => "Invalid verification code format.",
        "type" => "OAuthException"
      }
    }

    HTTPoisonFacebookMock
    |> expect(:token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.token("wrong_code") == {:ok, data}
  end

  test "return error with incorrect when token is nil" do
    data = %{
      "error" => "invalid_grant",
      "error_description" => "Malformed auth code."
    }

    HTTPoisonFacebookMock
    |> expect(:token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.token(nil) == {:ok, data}
  end

  test "return error with incorrect when token string is blank" do
    data = %{
      "error" => %{
        "code" => 100,
        "fbtrace_id" => "Anq_VCkPHqLsRSHVkaH5QBT",
        "message" => "Invalid verification code format.",
        "type" => "OAuthException"
      }
    }

    HTTPoisonFacebookMock
    |> expect(:token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.token("") == {:ok, data}
  end

  test "return error with incorrect when token is integer" do
    data = %{
      "error" => "invalid_grant",
      "error_description" => "Malformed auth code."
    }

    HTTPoisonFacebookMock
    |> expect(:token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.token(123) == {:ok, data}
  end

  test "return error with incorrect when token is float" do
    data = %{
      "error" => "invalid_grant",
      "error_description" => "Malformed auth code."
    }

    HTTPoisonFacebookMock
    |> expect(:token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.token(1.23) == {:ok, data}
  end

  test "return error with incorrect refresh token" do
    data = %{
      "error" => %{
        "code" => 190,
        "fbtrace_id" => "AwyYN3kZXvTpi3aeTwiwdxg",
        "message" => "Invalid OAuth access token.",
        "type" => "OAuthException"
      }
    }

    HTTPoisonFacebookMock
    |> expect(:refresh_token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.refresh_token("wrong_token") == {:ok, data}
  end

  test "return error with incorrect refresh when token is nil" do
    data = %{
      "error" => "invalid_grant",
      "error_description" => "Bad Request"
    }

    HTTPoisonFacebookMock
    |> expect(:refresh_token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.refresh_token(nil) == {:ok, data}
  end

  test "return error with incorrect refresh when token string is blank" do
    data = %{
      "error" => %{
        "code" => 1,
        "fbtrace_id" => "AFKOyMGCT0oCcEHlDYreK_K",
        "message" => "fb_exchange_token parameter not specified",
        "type" => "OAuthException"
      }
    }

    HTTPoisonFacebookMock
    |> expect(:refresh_token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.refresh_token("") == {:ok, data}
  end

  test "return error with incorrect refresh when token is integer" do
    data = %{
      "error" => "invalid_grant",
      "error_description" => "Bad Request"
    }

    HTTPoisonFacebookMock
    |> expect(:refresh_token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.refresh_token(123) == {:ok, data}
  end

  test "return error with incorrect refresh when token is float" do
    data = %{
      "error" => "invalid_grant",
      "error_description" => "Bad Request"
    }

    HTTPoisonFacebookMock
    |> expect(:refresh_token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.refresh_token(1.23) == {:ok, data}
  end

  test "return error with incorrect verify token" do
    data = %{
      "error" => %{
        "code" => 190,
        "fbtrace_id" => "AGFWQe-SGPzCLau6fFAAKD2",
        "message" => "Invalid OAuth access token.",
        "type" => "OAuthException"
      }
    }

    HTTPoisonFacebookMock
    |> expect(:verify_token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.verify_token("wrong_token") == {:ok, data}
  end

  test "return error with incorrect verify when token is nil" do
    data = %{
      "error" => "invalid_verify_token",
      "error_description" => "Invalid Value"
    }

    HTTPoisonFacebookMock
    |> expect(:verify_token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.verify_token(nil) == {:ok, data}
  end

  test "return error with incorrect verify when token string is blank" do
    data = %{
      "access_token" => "",
      "token_type" => "bearer"
    }

    HTTPoisonFacebookMock
    |> expect(:verify_token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.verify_token("") == {:ok, data}
  end

  test "return error with incorrect verify when token is integer" do
    data = %{
      "error" => "invalid_verify_token",
      "error_description" => "Invalid Value"
    }

    HTTPoisonFacebookMock
    |> expect(:verify_token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.verify_token(123) == {:ok, data}
  end

  test "return error with incorrect verify when token is float" do
    data = %{
      "error" => "invalid_verify_token",
      "error_description" => "Invalid Value"
    }

    HTTPoisonFacebookMock
    |> expect(:verify_token, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.verify_token(1.23) == {:ok, data}
  end

  test "return error with incorrect user profile" do
    data = %{
      "error" => %{
        "code" => 190,
        "fbtrace_id" => "AolF-nAHv2qpJv7QhVd5UcY",
        "message" => "Invalid OAuth access token.",
        "type" => "OAuthException"
      }
    }

    HTTPoisonFacebookMock
    |> expect(:user_profile, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.user_profile("wrong_token") == {:ok, data}
  end

  test "return error with incorrect user profile when token is nil" do
    data = %{
      "error" => "invalid_request",
      "error_description" => "Invalid Credentials"
    }

    HTTPoisonFacebookMock
    |> expect(:user_profile, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.user_profile(nil) == {:ok, data}
  end

  test "return error with incorrect user profile when token string is blank" do
    data = %{
      "error" => %{
        "code" => 2500,
        "fbtrace_id" => "ACfeR_VM4Vx0xWjVKJhvoZt",
        "message" => "An active access token must be used to query information about the current user.",
        "type" => "OAuthException"
      }
    }

    HTTPoisonFacebookMock
    |> expect(:user_profile, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.user_profile("") == {:ok, data}
  end

  test "return error with incorrect user profile when token string is integer" do
    data = %{
      "error" => "invalid_request",
      "error_description" => "Invalid Credentials"
    }

    HTTPoisonFacebookMock
    |> expect(:user_profile, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.user_profile(123) == {:ok, data}
  end

  test "return error with incorrect user profile when token string is float" do
    data = %{
      "error" => "invalid_request",
      "error_description" => "Invalid Credentials"
    }

    HTTPoisonFacebookMock
    |> expect(:user_profile, fn _ -> {:ok, data} end)

    assert HTTPoisonFacebookMock.user_profile(1.23) == {:ok, data}
  end
end

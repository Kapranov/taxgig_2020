defmodule ServerWeb.Provider.InMemoryTest do
  use ExUnit.Case
  doctest ServerWeb.Provider.OauthGoogle

  alias ServerWeb.Provider.{
    OauthGoogle,
    OauthLinkedIn
  }

  test "get Google login url" do
    Application.put_env(:server, :client_id, 123)
    url = "https://accounts.google.com/o/oauth2/v2/auth?response_type=code"
    assert OauthGoogle.generate_url() =~ url
  end

  test "get Google refresh token url" do
    Application.put_env(:server, :client_id, 123)
    url = "https://accounts.google.com/o/oauth2/v2/auth?response_type=code"
    assert OauthGoogle.generate_refresh_token_url() =~ url
  end

  test "get Google token" do
    assert OauthGoogle.token("ok_code") == {:ok, %{"access_token" => "token1"}}
  end

  test "get Google refresh token" do
    assert OauthGoogle.refresh_token("ok_token") == {:ok, %{"access_token" => "token1"}}
  end

  test "get Google verify token" do
    assert OauthGoogle.verify_token("ok_token") == {:ok, %{"name" => "josh"}}
  end

  test "get Google user profile" do
    assert OauthGoogle.user_profile("ok_token") == {:ok, %{"name" => "josh"}}
  end

  test "get Google user email" do
    assert OauthGoogle.user_email("ok_token") == {:ok, %{"name" => "josh"}}
  end

  test "return Google's error with incorrect token" do
    assert OauthGoogle.token(nil) == {:error, [field: :code, message: "Code is invalid or can't be blank"]}
    assert OauthGoogle.token(123) == {:error, [field: :code, message: "Code is invalid and not string"]}
    assert OauthGoogle.token(1.2) == {:error, [field: :code, message: "Code is invalid or can't be blank"]}
    assert OauthGoogle.refresh_token(nil) == {:error, [field: :token, message: "Token is invalid or can't be blank"]}
    assert OauthGoogle.refresh_token(123) == {:error, [field: :token, message: "Token is invalid and not string"]}
    assert OauthGoogle.refresh_token(1.2) == {:error, [field: :token, message: "Token is invalid or can't be blank"]}
    assert OauthGoogle.verify_token(nil) == {:error, [field: :token, message: "Token is invalid or can't be blank"]}
    assert OauthGoogle.verify_token(123) == {:error, [field: :token, message: "Token is invalid and not string"]}
    assert OauthGoogle.verify_token(1.2) == {:error, [field: :token, message: "Token is invalid or can't be blank"]}
    assert OauthGoogle.user_profile("wrong_token") == {:error, :bad_request }
    assert OauthGoogle.user_profile(nil) == {:error, [field: :token, message: "Token is invalid or can't be blank"]}
    assert OauthGoogle.user_profile(123) == {:error, [field: :token, message: "Token is invalid and not string"]}
    assert OauthGoogle.user_profile(1.2) == {:error, [field: :token, message: "Token is invalid or can't be blank"]}
    assert OauthGoogle.user_email("wrong_token") == {:error, :bad_request }
    assert OauthGoogle.user_email(nil) == {:error, [field: :token, message: "Token is invalid or can't be blank"]}
    assert OauthGoogle.user_email(123) == {:error, [field: :token, message: "Token is invalid and not string"]}
    assert OauthGoogle.user_email(1.2) == {:error, [field: :token, message: "Token is invalid or can't be blank"]}
  end

  test "get LinkedIn login url" do
    Application.put_env(:server, :client_id, 123)
    url = "https://www.linkedin.com/oauth/v2/authorization?response_type=code"
    assert OauthLinkedIn.generate_url() =~ url
  end

  test "get LinkedIn refresh token url" do
    Application.put_env(:server, :client_id, 123)
    url = "https://www.linkedin.com/oauth/v2/accessToken"
    assert OauthLinkedIn.generate_refresh_token_url("ok_token") =~ url
  end

  test "get LinkedIn token" do
    assert OauthLinkedIn.token("ok_code") == {:ok, %{"access_token" => "token1"}}
  end

  test "get LinkedIn refresh token" do
    assert OauthLinkedIn.refresh_token("ok_token") == {:ok, %{"access_token" => "token1"}}
  end

  test "get LinkedIn verify token" do
    assert OauthLinkedIn.verify_token("ok_token") == {:error, "Invalid access token"}
  end

  test "get LinkedIn user profile" do
    assert OauthLinkedIn.user_profile("ok_token") == {:ok, %{"name" => "josh"}}
  end

  test "get LinkedIn user email" do
    assert OauthLinkedIn.user_email("ok_token") == {:ok, %{"name" => "josh"}}
  end

  test "return LinkedIn's error with incorrect token" do
    assert OauthLinkedIn.generate_refresh_token_url("wrong_token") =~ "https://www.linkedin.com/oauth/v2/accessToken"
    assert OauthLinkedIn.generate_refresh_token_url(nil) == {:error, [field: :token, message: "Token is invalid and not string"]}
    assert OauthLinkedIn.generate_refresh_token_url(123) == {:error, [field: :code, message: "Code is invalid or can't be blank"]}
    assert OauthLinkedIn.generate_refresh_token_url(1.2) == {:error, [field: :token, message: "Token is invalid and not string"]}
    assert OauthLinkedIn.token(nil) == {:error, [field: :code, message: "Code is invalid or can't be blank"]}
    assert OauthLinkedIn.token(nil) == {:error, [field: :code, message: "Code is invalid or can't be blank"]}
    assert OauthLinkedIn.token(nil) == {:error, [field: :code, message: "Code is invalid or can't be blank"]}
    assert OauthLinkedIn.refresh_token(nil) == {:error, [field: :token, message: "Token is invalid or can't be blank"]}
    assert OauthLinkedIn.refresh_token(123) == {:error, [field: :token, message: "Token is invalid and not string"]}
    assert OauthLinkedIn.refresh_token(1.2) == {:error, [field: :token, message: "Token is invalid or can't be blank"]}
    assert OauthLinkedIn.verify_token(nil) == {:error, [field: :token, message: "Token is invalid or can't be blank"]}
    assert OauthLinkedIn.verify_token(123) == {:error, [field: :token, message: "Token is invalid and not string"]}
    assert OauthLinkedIn.verify_token(1.2) == {:error, [field: :token, message: "Token is invalid or can't be blank"]}
    assert OauthLinkedIn.user_profile("wrong_token") == {:ok, %{"error" => "bad_request"}}
    assert OauthLinkedIn.user_profile(nil) == {:error, [field: :token, message: "Token is invalid or can't be blank"]}
    assert OauthLinkedIn.user_profile(123) == {:error, [field: :token, message: "Token is invalid and not string"]}
    assert OauthLinkedIn.user_profile(1.2) == {:error, [field: :token, message: "Token is invalid or can't be blank"]}
    assert OauthLinkedIn.user_email("wrong_token") == {:ok, %{"error" => "bad_request"}}
    assert OauthLinkedIn.user_email(nil) == {:error, [field: :token, message: "Token is invalid or can't be blank"]}
    assert OauthLinkedIn.user_email(123) == {:error, [field: :token, message: "Token is invalid and not string"]}
    assert OauthLinkedIn.user_email(1.2) == {:error, [field: :token, message: "Token is invalid or can't be blank"]}
  end
end

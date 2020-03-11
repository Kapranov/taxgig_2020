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
    assert OauthGoogle.token("ok_code") == {:ok, %{
        "access_token" => "token1",
        "expires_in" => 3570,
        "id_token" => "eyJhbGciOiJSUzI1NiIsImtpZCI6IjE3ZDU1ZmY0ZTEwOTkxZDZiMGVmZDM5MmI5MWEzM2U1NGMwZTIxOGIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI2NzAxMTY3MDA4MDMtYjc2bmh1Y2Z2dGJjaTFjOWN1cmE2OXY1NnZmaml0YWQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI2NzAxMTY3MDA4MDMtYjc2bmh1Y2Z2dGJjaTFjOWN1cmE2OXY1NnZmaml0YWQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDgyMDA5MzI5NjI2MjE1NzU4MTgiLCJlbWFpbCI6ImthcHJhbm92Lmx1Z2F0ZXhAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJYY3p0RVZCTTI1VUFFRkZyYWpyR3lBIiwibmFtZSI6IkthcHJhbm92IE9sZWciLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FPaDE0R2ctbEl3VEZYVnFUZXFBUWEzbGJVV01HSXAwS3RzQkZFeHV4WTdlPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkthcHJhbm92IiwiZmFtaWx5X25hbWUiOiJPbGVnIiwibG9jYWxlIjoiZW4iLCJpYXQiOjE1ODMwODIzMDMsImV4cCI6MTU4MzA4NTkwM30.jb20PuqB2-ZqMCALYi9t2iKxiCgaYxh5ccjSzmLoS_GkxpegtVu0GnGocbHifieJCrU4K-XpjWkFtSaL9mOmVVWQXnUtXuZKIoPDQFRsD3WMlmCmXAw-fLf_cMGZqf2FbEu1uSvIWrgRIXhnZHfaGXJDp3_kWPyU-5bBNrzdSTmMmnVf2kr5b-lMHueNikTHRk2ovFn6HV_NZX318LV8Yf5EU68j-tWIEIL3IrloFTN0c7zvqIT77S2oY473fNUmRQQJ-ch9myyHMpOExm85t1duYWp8oDVScM9d3P09s_qIDAtxQAUldYjc6eszAVdfd5jPafH-5VEDq_CcYr7peA",
        "scope" => "openid https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile",
        "token_type" => "Bearer"
      }}
    assert OauthGoogle.token("wrong_code") == {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "Malformed auth code."
      }}
  end

  test "get Google refresh token" do
    assert OauthGoogle.refresh_token("ok_token") == {:ok, %{
        "access_token" => "token1",
        "expires_in" => 3530,
        "id_token" => "eyJhbGciOiJSUzI1NiIsImtpZCI6IjE3ZDU1ZmY0ZTEwOTkxZDZiMGVmZDM5MmI5MWEzM2U1NGMwZTIxOGIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI2NzAxMTY3MDA4MDMtYjc2bmh1Y2Z2dGJjaTFjOWN1cmE2OXY1NnZmaml0YWQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI2NzAxMTY3MDA4MDMtYjc2bmh1Y2Z2dGJjaTFjOWN1cmE2OXY1NnZmaml0YWQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDgyMDA5MzI5NjI2MjE1NzU4MTgiLCJlbWFpbCI6ImthcHJhbm92Lmx1Z2F0ZXhAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiIwbXE5Zl9uQXEwNzY0Z3JpWFVtZXJRIiwibmFtZSI6IkthcHJhbm92IE9sZWciLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FPaDE0R2ctbEl3VEZYVnFUZXFBUWEzbGJVV01HSXAwS3RzQkZFeHV4WTdlPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkthcHJhbm92IiwiZmFtaWx5X25hbWUiOiJPbGVnIiwibG9jYWxlIjoiZW4iLCJpYXQiOjE1ODMwODI0MTksImV4cCI6MTU4MzA4NjAxOX0.UDSTK2btMo8O8TXnuVgbZ06tGEDJ5arVF_d85N0APk4jphDd7TXqi94L3nos4UR5SK-oTSkKR9k1SYkZpw2ebgWMTRU_lAaNj81KwB0dTJqk47dVxzucsKtg_SO4LWmUPSuTFpxkggWyTgHAPFjw_WuXFmlskDJKS8o1qGz_Mz7KARnEyNLJBEyuIreIRWSFofiFhUZGe0MW7svtICt3U5kbfwitQDXdcRaCHPaCSvjMSpgiRozHOA-33nGNIw2ueJ9GN3H_AqErKmpHyyBpm9F_4noi9sC2fneY1kh062NBngbZ2kcknhCX3PtWxlAMVEG7-Ecx0bzTWxBUWem7SA",
        "scope" => "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email openid",
        "token_type" => "Bearer"
      }}
    assert OauthGoogle.refresh_token("wrong_token") == {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "Token has been expired or revoked."
      }}
  end

  test "get Google verify token" do
    assert OauthGoogle.verify_token("ok_token") == {:ok, %{
        "email" => "kapranov.lugatex@gmail.com",
        "access_type" => "online",
        "aud" => "670116700803-b76nhucfvtbci1c9cura69v56vfjitad.apps.googleusercontent.com",
        "azp" => "670116700803-b76nhucfvtbci1c9cura69v56vfjitad.apps.googleusercontent.com",
        "email_verified" => "true",
        "exp" => "1583085800",
        "expires_in" => "3320",
        "scope" => "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email openid",
        "sub" => "108200932962621575818"
      }}
    assert OauthGoogle.verify_token("wrong_token") == {:ok, %{
        "error_description" => "Invalid Value"
      }}
  end

  test "get Google user profile" do
    assert OauthGoogle.user_profile("ok_token") == {:ok, %{
        "email" => "kapranov.lugatex@gmail.com",
        "email_verified" => true,
        "sub" => "108200932962621575818",
        "family_name" => "Oleg",
        "given_name" => "Kapranov",
        "locale" => "en",
        "name" => "Kapranov Oleg",
        "picture" => "https://lh3.googleusercontent.com/a-/AOh14Gg-lIwTFXVqTeqAQa3lbUWMGIp0KtsBFExuxY7e"
      }}
    assert OauthGoogle.user_profile("wrong_token") == {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Invalid Credentials"
      }}
  end

  test "get Google user email" do
    assert OauthGoogle.user_email("ok_token") == {:ok, %{
        "email" => "kapranov.lugatex@gmail.com",
        "family_name" => "Oleg",
        "given_name" => "Kapranov",
        "id" => "108200932962621575818",
        "locale" => "en",
        "name" => "Kapranov Oleg",
        "picture" => "https://lh3.googleusercontent.com/a-/AOh14Gg-lIwTFXVqTeqAQa3lbUWMGIp0KtsBFExuxY7e",
        "verified_email" => true
      }}
    assert OauthGoogle.user_email("wrong_token") == {:ok, %{
        "error" => %{
          "code" => "401",
          "message" => "Request is missing required authentication credential. Expected OAuth 2 access token, login cookie or other valid authentication credential. See https://developers.google.com/identity/sign-in/web/devconsole-project.",
          "status" => "UNAUTHENTICATED"
        }
      }}
  end

  test "return Google's error with incorrect token" do
    assert OauthGoogle.token("wrong_code") == {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "Malformed auth code."
      }}
    assert OauthGoogle.token(nil) == {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "Malformed auth code."
      }}
    assert OauthGoogle.token(123) == {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "Malformed auth code."
      }}
    assert OauthGoogle.token(1.2) == {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "Malformed auth code."
      }}

    assert OauthGoogle.refresh_token("wrong_token") == {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "Token has been expired or revoked."
      }}
    assert OauthGoogle.refresh_token(nil) == {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "Bad Request"
      }}
    assert OauthGoogle.refresh_token(123) == {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "Bad Request"
      }}
    assert OauthGoogle.refresh_token(1.2) == {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "Bad Request"
      }}

    assert OauthGoogle.verify_token("wrong_token") == {:ok, %{
        "error_description" => "Invalid Value"
      }}
    assert OauthGoogle.verify_token(nil) == {:ok, %{
        "error" => "invalid_verify_token",
        "error_description" => "Invalid Value"
      }}
    assert OauthGoogle.verify_token(123) == {:ok, %{
        "error" => "invalid_verify_token",
        "error_description" => "Invalid Value"
      }}
    assert OauthGoogle.verify_token(1.2) == {:ok, %{
        "error" => "invalid_verify_token",
        "error_description" => "Invalid Value"
      }}

    assert OauthGoogle.user_profile("wrong_token") == {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Invalid Credentials"
      }}
    assert OauthGoogle.user_profile(nil) == {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Invalid Credentials"
      }}
    assert OauthGoogle.user_profile(123) == {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Invalid Credentials"
      }}
    assert OauthGoogle.user_profile(1.2) == {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Invalid Credentials"
      }}

    message = ~S(Request is missing required authentication credential. Expected OAuth 2 access token, login cookie or other valid authentication credential. See https://developers.google.com/identity/sign-in/web/devconsole-project. Status 401)

    assert OauthGoogle.user_email("wrong_token") == {:ok, %{
        "error" => %{
          "code" => "401",
          "message" => "Request is missing required authentication credential. Expected OAuth 2 access token, login cookie or other valid authentication credential. See https://developers.google.com/identity/sign-in/web/devconsole-project.",
          "status" => "UNAUTHENTICATED"
        }
      }}
    assert OauthGoogle.user_email(nil) == {:ok, %{
        "error" => "UNAUTHENTICATED",
        "error_description" => message
      }}
    assert OauthGoogle.user_email(123) == {:ok, %{
        "error" => "UNAUTHENTICATED",
        "error_description" => message
      }}
    assert OauthGoogle.user_email(1.2) == {:ok, %{
        "error" => "UNAUTHENTICATED",
        "error_description" => message
      }}
  end

  test "get LinkedIn login url" do
    Application.put_env(:server, :client_id, 123)
    {:ok, %{"url" => url}} = OauthLinkedIn.generate_url()
    assert url =~ "https://www.linkedin.com/oauth/v2/authorization?response_type=code&"
  end

  test "get LinkedIn refresh token url" do
    Application.put_env(:server, :client_id, 123)
    {:ok, %{"code" => url1}} = OauthLinkedIn.generate_refresh_token_url("ok_token")
    {:ok, %{"code" => url2}} = OauthLinkedIn.generate_refresh_token_url("wrong_token")
    assert url1 =~ "https://www.linkedin.com/oauth/v2/accessToken&grant_type=refresh_token&refresh_token=ok_token&"
    assert url2 =~ "https://www.linkedin.com/oauth/v2/accessToken&grant_type=refresh_token&refresh_token=wrong_token&"
  end

  test "get LinkedIn token" do
    assert OauthLinkedIn.token("ok_code") == {:ok, %{
        "access_token" => "token1",
        "expires_in" => 5183999,
        "error" => nil,
        "error_description" => nil
      }}
    assert OauthLinkedIn.token("wrong_code") == {:ok, %{
        "access_token" => nil,
        "error" => "invalid_request",
        "error_description" => "Unable to retrieve access token: authorization code not found",
        "expires_in" => nil
      }}
  end

  test "get LinkedIn refresh token" do
    assert OauthLinkedIn.refresh_token("ok_token") == {:ok, %{
        "error" => "access_denied",
        "error_description" => "Refresh token not allowed"
      }}
    assert OauthLinkedIn.refresh_token("wrong_token") == {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "The provided authorization grant or refresh token is invalid, expired or revoked."
      }}
  end

  test "get LinkedIn verify token" do
    {:ok, %{"email" => email}} = OauthLinkedIn.verify_token("ok_token")
    assert email == "lugatex@yahoo.com"
    assert OauthLinkedIn.verify_token("wrong_token") == {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}
  end

  test "get LinkedIn user profile" do
    assert OauthLinkedIn.user_profile("ok_token") == {:ok, %{
        "avatar" => "https://media-exp1.licdn.com/dms/image/C4D03AQEj8Ydcpq0Abg/profile-displayphoto-shrink_800_800/0?e=1588809600&v=beta&t=LcXUJaGScuKVx7KnWV96GF0v_6sOlN4DpE0RlddV_ko",
        "first_name" => "Oleg",
        "last_name" => "Kapranov"
      }}
    assert OauthLinkedIn.user_profile("wrong_token") == {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}
  end

  test "get LinkedIn user email" do
    assert OauthLinkedIn.user_email("ok_token") == {:ok, %{
        "email" => "lugatex@yahoo.com"
      }}
    assert OauthLinkedIn.user_email("wrong_token") == {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}
  end

  test "return LinkedIn's error with incorrect token" do
    {:ok, %{"code" => url1}} = OauthLinkedIn.generate_refresh_token_url("wrong_token")
    assert url1 =~ "https://www.linkedin.com/oauth/v2/accessToken&grant_type=refresh_token&refresh_token=wrong_token&"
    assert OauthLinkedIn.generate_refresh_token_url(nil) == {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Unable to retrieve access token: authorization code not found"
      }}
    assert OauthLinkedIn.generate_refresh_token_url(123) == {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Unable to retrieve access token: authorization code not found"
      }}
    assert OauthLinkedIn.generate_refresh_token_url(1.2) == {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Unable to retrieve access token: authorization code not found"
      }}

    assert OauthLinkedIn.token("wrong_code") == {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Unable to retrieve access token: authorization code not found",
        "access_token" => nil,
        "expires_in" => nil
      }}
    assert OauthLinkedIn.token(nil) == {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Unable to retrieve access token: authorization code not found"
      }}
    assert OauthLinkedIn.token(123) == {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Unable to retrieve access token: authorization code not found"
      }}
    assert OauthLinkedIn.token(1.2) == {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Unable to retrieve access token: authorization code not found"
      }}

    assert OauthLinkedIn.refresh_token("wrong_token") == {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "The provided authorization grant or refresh token is invalid, expired or revoked."
      }}
    assert OauthLinkedIn.refresh_token(nil) == {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "The provided authorization grant or refresh token is invalid, expired or revoked."
      }}
    assert OauthLinkedIn.refresh_token(123) == {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "The provided authorization grant or refresh token is invalid, expired or revoked."
      }}
    assert OauthLinkedIn.refresh_token(1.2) == {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "The provided authorization grant or refresh token is invalid, expired or revoked."
      }}

    assert OauthLinkedIn.verify_token("wrong_token") == {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}
    assert OauthLinkedIn.verify_token(nil) == {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}
    assert OauthLinkedIn.verify_token(123) == {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}
    assert OauthLinkedIn.verify_token(1.2) == {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}

    assert OauthLinkedIn.user_profile("wrong_token") == {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}
    assert OauthLinkedIn.user_profile(nil) == {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}
    assert OauthLinkedIn.user_profile(123) == {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}
    assert OauthLinkedIn.user_profile(1.2) == {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}

    assert OauthLinkedIn.user_email("wrong_token") == {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}
    assert OauthLinkedIn.user_email(nil) == {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}
    assert OauthLinkedIn.user_email(123) == {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}
    assert OauthLinkedIn.user_email(1.2) == {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}
  end
end

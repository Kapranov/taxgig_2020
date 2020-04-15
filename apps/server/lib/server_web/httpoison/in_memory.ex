defmodule ServerWeb.Provider.HTTPoison.InMemory do
  @moduledoc """
  In memory for test enviroment.
  """

  @code_ok    URI.decode("ok_code")
  @code_wrong URI.decode("wrong_code")

  @token_ok    URI.decode("ok_token")
  @token_wrong URI.decode("wrong_token")

  @headers1 [{"Authorization", "Bearer #{@token_ok}"}, {"Accept", "application/json"}]
  @headers2 [{"Authorization", "Bearer #{@token_wrong}"}, {"Accept", "application/json"}]
  @headers3 [{"Content-type", "application/x-www-form-urlencoded"}]

  @google_email_ok      "https://www.googleapis.com/userinfo/v2/me?access_token=#{@token_ok}"
  @google_email_wrong   "https://www.googleapis.com/userinfo/v2/me?access_token=#{@token_wrong}"
  @google_profile_ok    "https://www.googleapis.com/oauth2/v3/userinfo?access_token=#{@token_ok}"
  @google_profile_wrong "https://www.googleapis.com/oauth2/v3/userinfo?access_token=#{@token_wrong}"
  @google_token         "https://oauth2.googleapis.com/token"
  @google_verify_ok     "https://www.googleapis.com/oauth2/v3/tokeninfo?access_token=#{@token_ok}"
  @google_verify_wrong  "https://www.googleapis.com/oauth2/v3/tokeninfo?access_token=#{@token_wrong}"

  @linkedin_email   "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))"
  @linkedin_profile "https://api.linkedin.com/v2/me?projection=(localizedFirstName,localizedLastName,profilePicture(displayImage~:playableStreams))"
  @linkedin_refresh "https://www.linkedin.com/oauth/v2/accessToken"
  @linkedin_token   "https://api.linkedin.com/v2/me?oauth2_access_token=#{@token_wrong}"

  @facebook_profile "https://graph.facebook.com/me?"
  @facebook_refresh "https://graph.facebook.com/oauth/client_code?"
  @facebook_token   "https://graph.facebook.com/oauth/access_token?"
  @facebook_verify  "https://graph.facebook.com/oauth/access_token_info?"

  @body1 URI.encode_query(%{
    client_id: Application.get_env(:server, LinkedIn)[:client_id],
    client_secret: Application.get_env(:server, LinkedIn)[:client_secret],
    grant_type: "refresh_token",
    refresh_token: "ok_token"
  })

  @body2 URI.encode_query(%{
    client_id: Application.get_env(:server, LinkedIn)[:client_id],
    client_secret: Application.get_env(:server, LinkedIn)[:client_secret],
    grant_type: "refresh_token",
    refresh_token: "wrong_token"
  })

  @body3 URI.encode_query(%{
    code: @code_ok,
    client_id: Application.get_env(:server, LinkedIn)[:client_id],
    client_secret: Application.get_env(:server, LinkedIn)[:client_secret],
    redirect_uri: Application.get_env(:server, LinkedIn)[:redirect_uri],
    grant_type: "authorization_code"
  })

  @body4 URI.encode_query(%{
    code: @code_wrong,
    client_id: Application.get_env(:server, LinkedIn)[:client_id],
    client_secret: Application.get_env(:server, LinkedIn)[:client_secret],
    redirect_uri: Application.get_env(:server, LinkedIn)[:redirect_uri],
    grant_type: "authorization_code"
  })

  @body5 Jason.encode!(%{
    refresh_token: @token_ok,
    client_id: Application.get_env(:server, Google)[:client_id],
    client_secret: Application.get_env(:server, Google)[:client_secret],
    grant_type: "refresh_token"
  })

  @body6 Jason.encode!(%{
    refresh_token: @token_wrong,
    client_id: Application.get_env(:server, Google)[:client_id],
    client_secret: Application.get_env(:server, Google)[:client_secret],
    grant_type: "refresh_token"
  })

  @body7 Jason.encode!(%{
    code: @code_ok,
    client_id: Application.get_env(:server, Google)[:client_id],
    client_secret: Application.get_env(:server, Google)[:client_secret],
    redirect_uri: Application.get_env(:server, Google)[:redirect_uri],
    grant_type: "authorization_code"
  })

  @body8 Jason.encode!(%{
    code: @code_wrong,
    client_id: Application.get_env(:server, Google)[:client_id],
    client_secret: Application.get_env(:server, Google)[:client_secret],
    redirect_uri: Application.get_env(:server, Google)[:redirect_uri],
    grant_type: "authorization_code"
  })

  @spec get(String.t()) :: {:ok, %{atom => %{atom => any}}}
  def get(@google_email_ok), do: {:ok, %{body: Jason.encode!(google_email_ok())}}

  @spec get(String.t()) :: {:ok, %{atom => %{atom => any}}}
  def get(@google_email_wrong), do: {:ok, %{body: Jason.encode!(google_email_wrong())}}

  @spec get(String.t()) :: {:ok, %{atom => %{atom => any}}}
  def get(@google_profile_ok), do: {:ok, %{body: Jason.encode!(google_profile_ok())}}

  @spec get(String.t()) :: {:ok, %{atom => %{atom => any}}}
  def get(@google_profile_wrong), do: {:ok, %{body: Jason.encode!(google_profile_wrong())}}

  @spec get(String.t()) :: {:ok, %{atom => %{atom => any}}}
  def get(@google_verify_ok), do: {:ok, %{body: Jason.encode!(google_verify_ok())}}

  @spec get(String.t()) :: {:ok, %{atom => %{atom => any}}}
  def get(@google_verify_wrong), do: {:ok, %{body: Jason.encode!(google_verify_wrong())}}

  @spec get(String.t()) :: {:ok, %{atom => %{atom => any}}}
  def get(@linkedin_token), do: {:ok, %{body: Jason.encode!(%{email: "lugatex@yahoo.com"})}}

  @spec get(String.t()) :: {:ok, %{atom => %{atom => any}}}
  def get(@google_token), do: {:ok, %{body: Jason.encode!(%{email: "kapranov.lugatex@gmail.com"})}}

  @spec get(String.t()) :: {:ok, %{atom => %{atom => any}}}
  def get(@facebook_profile), do: {:ok, %{body: Jason.encode!(%{email: "lugatex@yahoo.com"})}}

  @spec get(String.t()) :: {:ok, %{atom => %{atom => any}}}
  def get(@facebook_refresh), do: {:ok, %{body: Jason.encode!(%{email: "lugatex@yahoo.com"})}}

  @spec get(String.t()) :: {:ok, %{atom => %{atom => any}}}
  def get(@facebook_token), do: {:ok, %{body: Jason.encode!(%{email: "lugatex@yahoo.com"})}}

  @spec get(String.t()) :: {:ok, %{atom => %{atom => any}}}
  def get(@facebook_verify), do: {:ok, %{body: Jason.encode!(%{email: "lugatex@yahoo.com"})}}

  @spec get(any()) :: {:ok, %{atom => %{atom => any}}}
  def get(_url), do: {:ok, %{body: Jason.encode!(google_verify_ok())}}

  @spec get(String.t(), [{Stringt.t(), String.t()}]) :: {:ok, %{atom => %{atom => any}}}
  def get(@linkedin_email, @headers1), do: {:ok, %{body: Jason.encode!(linkedin_email_ok())}}

  @spec get(String.t(), [{Stringt.t(), String.t()}]) :: {:ok, %{atom => %{atom => any}}}
  def get(@linkedin_email, @headers2), do: {:ok, %{body: Jason.encode!(linkedin_email_wrong())}}

  @spec get(String.t(), any()) :: {:ok, %{atom => %{atom => any}}}
  def get(@linkedin_email, _options), do: {:ok, %{body: Jason.encode!(linkedin_verify_ok())}}

  @spec get(String.t(), [{Stringt.t(), String.t()}]) :: {:ok, %{atom => %{atom => any}}}
  def get(@linkedin_profile, @headers1), do: {:ok, %{body: Jason.encode!(linkedin_profile_ok())}}

  @spec get(String.t(), [{Stringt.t(), String.t()}]) :: {:ok, %{atom => %{atom => any}}}
  def get(@linkedin_profile, @headers2), do: {:ok, %{body: Jason.encode!(linkedin_profile_wrong())}}

  @spec get(String.t(), any()) :: {:ok, %{atom => %{atom => any}}}
  def get(@linkedin_profile, _options), do: {:ok, %{body: Jason.encode!(linkedin_profile_ok())}}

  @spec get(any(), [{Stringt.t(), String.t()}]) :: {:ok, %{atom => %{atom => any}}}
  def get(_url, @headers1), do: {:ok, %{body: Jason.encode!(linkedin_verify_ok())}}

  @spec get(any(), [{Stringt.t(), String.t()}]) :: {:ok, %{atom => %{atom => any}}}
  def get(_url, @headers2), do: {:ok, %{body: Jason.encode!(linkedin_verify_wrong())}}

  @spec get(any(), any()) :: {:ok, %{atom => %{atom => any}}}
  def get(_url, _options), do: {:ok, %{body: Jason.encode!(linkedin_verify_ok())}}

  @spec post(String.t(), String.t()) :: {:ok, %{atom => %{atom => any}}}
  def post(@google_token, @body5), do: {:ok, %{body: Jason.encode!(google_refresh_ok())}}

  @spec post(String.t(), String.t()) :: {:ok, %{atom => %{atom => any}}}
  def post(@google_token, @body6), do: {:ok, %{body: Jason.encode!(google_refresh_wrong())}}

  @spec post(String.t(), String.t()) :: {:ok, %{atom => %{atom => any}}}
  def post(@google_token, @body7), do: {:ok, %{body: Jason.encode!(google_token_ok())}}

  @spec post(String.t(), String.t()) :: {:ok, %{atom => %{atom => any}}}
  def post(@google_token, @body8), do: {:ok, %{body: Jason.encode!(google_token_wrong())}}

  @spec post(any(), any()) :: {:ok, %{atom => %{atom => any}}}
  def post(_url, _token), do: {:ok, %{body: Jason.encode!(%{access_token: "token1"})}}

  @spec post(String.t(), %{atom => String.t()}, [{Stringt.t(), String.t()}]) :: {:ok, %{atom => %{atom => any}}}
  def post(@linkedin_refresh, @body1, @headers3), do: {:ok, %{body: Jason.encode!(linkedin_refresh_denied())}}

  @spec post(String.t(), %{atom => String.t()}, [{Stringt.t(), String.t()}]) :: {:ok, %{atom => %{atom => any}}}
  def post(@linkedin_refresh, @body2, @headers3), do: {:ok, %{body: Jason.encode!(linkedin_refresh_invalid())}}

  @spec post(String.t(), %{atom => String.t()}, [{Stringt.t(), String.t()}]) :: {:ok, %{atom => %{atom => any}}}
  def post(@linkedin_refresh, @body3, @headers3), do: {:ok, %{body: Jason.encode!(linkedin_token_ok())}}

  @spec post(String.t(), %{atom => String.t()}, [{Stringt.t(), String.t()}]) :: {:ok, %{atom => %{atom => any}}}
  def post(@linkedin_refresh, @body4, @headers3), do: {:ok, %{body: Jason.encode!(linkedin_token_wrong())}}

  @spec post(any(), any(), any()) :: {:ok, %{atom => %{atom => any}}}
  def post(_url, _token, _options), do: {:ok, %{body: Jason.encode!(linkedin_refresh_denied())}}

  @spec google_email_ok() :: %{atom => String.t() | boolean()}
  defp google_email_ok() do
    %{
      "email" => "kapranov.lugatex@gmail.com",
      "family_name" => "Oleg",
      "given_name" => "Kapranov",
      "id" => "108200932962621575818",
      "locale" => "en",
      "name" => "Kapranov Oleg",
      "picture" => "https://lh3.googleusercontent.com/a-/AOh14Gg-lIwTFXVqTeqAQa3lbUWMGIp0KtsBFExuxY7e",
      "verified_email" => true
    }
  end

  @spec google_email_wrong() :: %{atom => %{atom => String.t()}}
  defp google_email_wrong() do
    %{
      "error" => %{
        "code" => "401",
        "message" => "Request is missing required authentication credential. Expected OAuth 2 access token, login cookie or other valid authentication credential. See https://developers.google.com/identity/sign-in/web/devconsole-project.",
        "status" => "UNAUTHENTICATED"
      }
    }
  end

  @spec google_profile_ok() :: %{atom => String.t()}
  defp google_profile_ok() do
    %{
      "email" => "kapranov.lugatex@gmail.com",
      "email_verified" => true,
      "family_name" => "Oleg",
      "given_name" => "Kapranov",
      "locale" => "en",
      "name" => "Kapranov Oleg",
      "picture" => "https://lh3.googleusercontent.com/a-/AOh14Gg-lIwTFXVqTeqAQa3lbUWMGIp0KtsBFExuxY7e",
      "sub" => "108200932962621575818"
    }
  end

  @spec google_profile_wrong() :: %{atom => String.t()}
  defp google_profile_wrong() do
    %{
      "error" => "invalid_request",
      "error_description" => "Invalid Credentials"
    }
  end

  @spec google_verify_ok() :: %{atom => String.t()}
  defp google_verify_ok() do
    %{
      "access_type" => "online",
      "aud" => "670116700803-b76nhucfvtbci1c9cura69v56vfjitad.apps.googleusercontent.com",
      "azp" => "670116700803-b76nhucfvtbci1c9cura69v56vfjitad.apps.googleusercontent.com",
      "email" => "kapranov.lugatex@gmail.com",
      "email_verified" => "true",
      "exp" => "1583085800",
      "expires_in" => "3320",
      "scope" => "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email openid",
      "sub" => "108200932962621575818"
    }
  end

  @spec google_verify_wrong() :: %{atom => String.t()}
  defp google_verify_wrong() do
    %{"error_description" => "Invalid Value"}
  end

  @spec google_token_ok() :: %{atom => String.t() | integer()}
  defp google_token_ok() do
    %{
      "access_token" => "token1",
      "expires_in" => 3570,
      "id_token" => "eyJhbGciOiJSUzI1NiIsImtpZCI6IjE3ZDU1ZmY0ZTEwOTkxZDZiMGVmZDM5MmI5MWEzM2U1NGMwZTIxOGIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI2NzAxMTY3MDA4MDMtYjc2bmh1Y2Z2dGJjaTFjOWN1cmE2OXY1NnZmaml0YWQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI2NzAxMTY3MDA4MDMtYjc2bmh1Y2Z2dGJjaTFjOWN1cmE2OXY1NnZmaml0YWQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDgyMDA5MzI5NjI2MjE1NzU4MTgiLCJlbWFpbCI6ImthcHJhbm92Lmx1Z2F0ZXhAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJYY3p0RVZCTTI1VUFFRkZyYWpyR3lBIiwibmFtZSI6IkthcHJhbm92IE9sZWciLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FPaDE0R2ctbEl3VEZYVnFUZXFBUWEzbGJVV01HSXAwS3RzQkZFeHV4WTdlPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkthcHJhbm92IiwiZmFtaWx5X25hbWUiOiJPbGVnIiwibG9jYWxlIjoiZW4iLCJpYXQiOjE1ODMwODIzMDMsImV4cCI6MTU4MzA4NTkwM30.jb20PuqB2-ZqMCALYi9t2iKxiCgaYxh5ccjSzmLoS_GkxpegtVu0GnGocbHifieJCrU4K-XpjWkFtSaL9mOmVVWQXnUtXuZKIoPDQFRsD3WMlmCmXAw-fLf_cMGZqf2FbEu1uSvIWrgRIXhnZHfaGXJDp3_kWPyU-5bBNrzdSTmMmnVf2kr5b-lMHueNikTHRk2ovFn6HV_NZX318LV8Yf5EU68j-tWIEIL3IrloFTN0c7zvqIT77S2oY473fNUmRQQJ-ch9myyHMpOExm85t1duYWp8oDVScM9d3P09s_qIDAtxQAUldYjc6eszAVdfd5jPafH-5VEDq_CcYr7peA",
      "scope" => "openid https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile",
      "token_type" => "Bearer"
    }
  end

  @spec google_token_wrong() :: %{atom => String.t()}
  defp google_token_wrong() do
    %{
      "error" => "invalid_grant",
      "error_description" => "Malformed auth code."
    }
  end

  @spec google_refresh_ok() :: %{atom => String.t() | integer()}
  defp google_refresh_ok() do
    %{
      "access_token" => "token1",
      "expires_in" => 3530,
      "id_token" => "eyJhbGciOiJSUzI1NiIsImtpZCI6IjE3ZDU1ZmY0ZTEwOTkxZDZiMGVmZDM5MmI5MWEzM2U1NGMwZTIxOGIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI2NzAxMTY3MDA4MDMtYjc2bmh1Y2Z2dGJjaTFjOWN1cmE2OXY1NnZmaml0YWQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI2NzAxMTY3MDA4MDMtYjc2bmh1Y2Z2dGJjaTFjOWN1cmE2OXY1NnZmaml0YWQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDgyMDA5MzI5NjI2MjE1NzU4MTgiLCJlbWFpbCI6ImthcHJhbm92Lmx1Z2F0ZXhAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiIwbXE5Zl9uQXEwNzY0Z3JpWFVtZXJRIiwibmFtZSI6IkthcHJhbm92IE9sZWciLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FPaDE0R2ctbEl3VEZYVnFUZXFBUWEzbGJVV01HSXAwS3RzQkZFeHV4WTdlPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkthcHJhbm92IiwiZmFtaWx5X25hbWUiOiJPbGVnIiwibG9jYWxlIjoiZW4iLCJpYXQiOjE1ODMwODI0MTksImV4cCI6MTU4MzA4NjAxOX0.UDSTK2btMo8O8TXnuVgbZ06tGEDJ5arVF_d85N0APk4jphDd7TXqi94L3nos4UR5SK-oTSkKR9k1SYkZpw2ebgWMTRU_lAaNj81KwB0dTJqk47dVxzucsKtg_SO4LWmUPSuTFpxkggWyTgHAPFjw_WuXFmlskDJKS8o1qGz_Mz7KARnEyNLJBEyuIreIRWSFofiFhUZGe0MW7svtICt3U5kbfwitQDXdcRaCHPaCSvjMSpgiRozHOA-33nGNIw2ueJ9GN3H_AqErKmpHyyBpm9F_4noi9sC2fneY1kh062NBngbZ2kcknhCX3PtWxlAMVEG7-Ecx0bzTWxBUWem7SA",
      "scope" => "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email openid",
      "token_type" => "Bearer"
    }
  end

  @spec google_refresh_wrong() :: %{atom => String.t()}
  defp google_refresh_wrong() do
    %{
      "error" => "invalid_grant",
      "error_description" => "Token has been expired or revoked."
    }
  end

  @spec linkedin_profile_ok() :: %{atom => any}
  defp linkedin_profile_ok() do
    %{
      "localizedFirstName" => "Oleg",
      "localizedLastName" => "Kapranov",
      "profilePicture" => %{
        "displayImage" => "urn:li:digitalmediaAsset:C4D03AQEj8Ydcpq0Abg",
        "displayImage~" => %{
          "paging" => %{
            "count" => 10,
            "start" => 0,
            "links" => []
          },
          "elements" => [
            %{
              "artifact" => "urn:li:digitalmediaMediaArtifact:(urn:li:digitalmediaAsset:C4D03AQEj8Ydcpq0Abg,urn:li:digitalmediaMediaArtifactClass:profile-displayphoto-shrink_100_100)",
              "authorizationMethod" => "PUBLIC",
              "data" => %{
                "com.linkedin.digitalmedia.mediaartifact.StillImage" => %{
                  "storageSize" => %{
                    "width" => 100,
                    "height" => 100
                  },
                  "storageAspectRatio" => %{
                    "widthAspect" => 1,
                    "heightAspect" => 1,
                    "formatted" => "1.00:1.00"
                  },
                  "mediaType" => "image/jpeg",
                  "rawCodecSpec" => %{
                    "name" => "jpeg",
                    "type" => "image"
                  },
                  "displaySize" => %{
                    "uom" => "PX",
                    "width" => 100,
                    "height" => 100
                  },
                  "displayAspectRatio" => %{
                    "widthAspect" => 1,
                    "heightAspect" => 1,
                    "formatted" => "1.00:1.00"
                  }
                }
              },
              "identifiers" => [
                %{
                  "identifier" => "https://media-exp1.licdn.com/dms/image/C4D03AQEj8Ydcpq0Abg/profile-displayphoto-shrink_100_100/0?e=1588809600&v=beta&t=XKa_VmQmhlgDyOkEKQ9xu4_8TywTVMtzq41JvA2oRXQ",
                  "file" => "urn:li:digitalmediaFile:(urn:li:digitalmediaAsset:C4D03AQEj8Ydcpq0Abg,urn:li:digitalmediaMediaArtifactClass:profile-displayphoto-shrink_100_100,0)",
                  "index" => 0,
                  "mediaType" => "image/jpeg",
                  "identifierType" => "EXTERNAL_URL",
                  "identifierExpiresInSeconds" => 1588809600
                }
              ]
            },
            %{
              "artifact" => "urn:li:digitalmediaMediaArtifact:(urn:li:digitalmediaAsset:C4D03AQEj8Ydcpq0Abg,urn:li:digitalmediaMediaArtifactClass:profile-displayphoto-shrink_200_200)",
              "authorizationMethod" => "PUBLIC",
              "data" => %{
                "com.linkedin.digitalmedia.mediaartifact.StillImage" => %{
                  "storageSize" => %{
                    "width" => 200,
                    "height" => 200
                  },
                  "storageAspectRatio" => %{
                    "widthAspect" => 1,
                    "heightAspect" => 1,
                    "formatted" => "1.00:1.00"
                  },
                  "mediaType" => "image/jpeg",
                  "rawCodecSpec" => %{
                    "name" => "jpeg",
                    "type" => "image"
                  },
                  "displaySize" => %{
                    "uom" => "PX",
                    "width" => 200,
                    "height" => 200
                  },
                  "displayAspectRatio" => %{
                    "widthAspect" => 1,
                    "heightAspect" => 1,
                    "formatted" => "1.00:1.00"
                  }
                }
              },
              "identifiers" => [
                %{
                  "identifier" => "https://media-exp1.licdn.com/dms/image/C4D03AQEj8Ydcpq0Abg/profile-displayphoto-shrink_200_200/0?e=1588809600&v=beta&t=yXK10151AWYKTgvgFBnvY2BhkeIfC9YU-kaygfWjbjE",
                  "file" => "urn:li:digitalmediaFile:(urn:li:digitalmediaAsset:C4D03AQEj8Ydcpq0Abg,urn:li:digitalmediaMediaArtifactClass:profile-displayphoto-shrink_200_200,0)",
                  "index" => 0,
                  "mediaType" => "image/jpeg",
                  "identifierType" => "EXTERNAL_URL",
                  "identifierExpiresInSeconds" => 1588809600
                }
              ]
            },
            %{
              "artifact" => "urn:li:digitalmediaMediaArtifact:(urn:li:digitalmediaAsset:C4D03AQEj8Ydcpq0Abg,urn:li:digitalmediaMediaArtifactClass:profile-displayphoto-shrink_400_400)",
              "authorizationMethod" => "PUBLIC",
              "data" => %{
                "com.linkedin.digitalmedia.mediaartifact.StillImage" => %{
                  "storageSize" => %{
                    "width" => 400,
                    "height" => 400
                  },
                  "storageAspectRatio" => %{
                    "widthAspect" => 1,
                    "heightAspect" => 1,
                    "formatted" => "1.00:1.00"
                  },
                  "mediaType" => "image/jpeg",
                  "rawCodecSpec" => %{
                    "name" => "jpeg",
                    "type" => "image"
                  },
                  "displaySize" => %{
                    "uom" => "PX",
                    "width" => 400,
                    "height" => 400
                  },
                  "displayAspectRatio" => %{
                    "widthAspect" => 1,
                    "heightAspect" => 1,
                    "formatted" => "1.00:1.00"
                  }
                }
              },
              "identifiers" => [
                %{
                  "identifier" => "https://media-exp1.licdn.com/dms/image/C4D03AQEj8Ydcpq0Abg/profile-displayphoto-shrink_400_400/0?e=1588809600&v=beta&t=4tI_X2B4VHsX7cDmUqb8EbcWAccHbuCfXZyUlg3S1WM",
                  "file" => "urn:li:digitalmediaFile:(urn:li:digitalmediaAsset:C4D03AQEj8Ydcpq0Abg,urn:li:digitalmediaMediaArtifactClass:profile-displayphoto-shrink_400_400,0)",
                  "index" => 0,
                  "mediaType" => "image/jpeg",
                  "identifierType" => "EXTERNAL_URL",
                  "identifierExpiresInSeconds" => 1588809600
                }
              ]
            },
            %{
              "artifact" => "urn:li:digitalmediaMediaArtifact:(urn:li:digitalmediaAsset:C4D03AQEj8Ydcpq0Abg,urn:li:digitalmediaMediaArtifactClass:profile-displayphoto-shrink_800_800)",
              "authorizationMethod" => "PUBLIC",
              "data" => %{
                "com.linkedin.digitalmedia.mediaartifact.StillImage" => %{
                  "storageSize" => %{
                    "width" => 800,
                    "height" => 800
                  },
                  "storageAspectRatio" => %{
                    "widthAspect" => 1,
                    "heightAspect" => 1,
                    "formatted" => "1.00:1.00"
                  },
                  "mediaType" => "image/jpeg",
                  "rawCodecSpec" => %{
                    "name" => "jpeg",
                    "type" => "image"
                  },
                  "displaySize" => %{
                    "uom" => "PX",
                    "width" => 800,
                    "height" => 800
                  },
                  "displayAspectRatio" => %{
                    "widthAspect" => 1,
                    "heightAspect" => 1,
                    "formatted" => "1.00:1.00"
                  }
                }
              },
              "identifiers" => [
                %{
                  "identifier" => "https://media-exp1.licdn.com/dms/image/C4D03AQEj8Ydcpq0Abg/profile-displayphoto-shrink_800_800/0?e=1588809600&v=beta&t=LcXUJaGScuKVx7KnWV96GF0v_6sOlN4DpE0RlddV_ko",
                  "file" => "urn:li:digitalmediaFile:(urn:li:digitalmediaAsset:C4D03AQEj8Ydcpq0Abg,urn:li:digitalmediaMediaArtifactClass:profile-displayphoto-shrink_800_800,0)",
                  "index" => 0,
                  "mediaType" => "image/jpeg",
                  "identifierType" => "EXTERNAL_URL",
                  "identifierExpiresInSeconds" => 1588809600
                }
              ]
            }
          ]
        }
      }
    }
  end

  @spec linkedin_profile_wrong() :: %{atom => String.t() | integer()}
  defp linkedin_profile_wrong() do
    %{
      "serviceErrorCode" => 65600,
      "message" => "Invalid access token",
      "status" => 401
    }
  end

  @spec linkedin_verify_ok() :: %{atom => [map()]}
  defp linkedin_verify_ok() do
    %{
      "elements" => [
        %{
          "handle" => "urn:li:emailAddress:493632782",
          "handle~" => %{
            "emailAddress" => "lugatex@yahoo.com"
          }
        }
      ]
    }
  end

  @spec linkedin_verify_wrong() :: %{atom => String.t() | integer()}
  defp linkedin_verify_wrong() do
    %{
      "serviceErrorCode" => 65600,
      "message" => "Invalid access token",
      "status" => 401
    }
  end

  @spec linkedin_email_ok() :: %{atom => [map()]}
  defp linkedin_email_ok() do
    %{
      "elements" => [
        %{
          "handle" => "urn:li:emailAddress:493632782",
          "handle~" => %{
            "emailAddress" => "lugatex@yahoo.com"
          }
        }
      ]
    }
  end

  @spec linkedin_email_wrong() :: %{atom => String.t() | integer()}
  defp linkedin_email_wrong() do
    %{
      "serviceErrorCode" => 65600,
      "message" => "Invalid access token",
      "status" => 401
    }
  end

  @spec linkedin_refresh_denied() :: %{atom => String.t()}
  defp linkedin_refresh_denied() do
    %{
      "error" => "access_denied",
      "error_description" => "Refresh token not allowed"
    }
  end

  @spec linkedin_refresh_invalid() :: %{atom => String.t()}
  defp linkedin_refresh_invalid() do
    %{
      "error" => "invalid_grant",
      "error_description" => "The provided authorization grant or refresh token is invalid, expired or revoked."
    }
  end

  @spec linkedin_token_ok() :: %{atom => String.t() | integer()}
  defp linkedin_token_ok() do
    %{
      "access_token" => "token1",
      "expires_in" => 5183999
    }
  end

  @spec linkedin_token_wrong() :: %{atom => String.t()}
  defp linkedin_token_wrong() do
    %{
      "error" => "invalid_request",
      "error_description" => "Unable to retrieve access token: authorization code not found"
    }
  end
end

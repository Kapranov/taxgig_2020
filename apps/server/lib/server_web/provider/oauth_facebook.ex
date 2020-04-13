defmodule ServerWeb.Provider.OauthFacebook do
  @moduledoc """
  Minimalist Facebook OAuth Authentication.
  birthday, email, firstName, id, languages, lastName, middleName, name, profilePic
  """

  @behaviour ServerWeb.HTTPoison.FacebookBehaviour

  @httpoison Application.get_env(:server, :httpoison) || HTTPoison
  @facebook_auth_url "https://www.facebook.com/v6.0/dialog/oauth?"
  @google_auth_refresh_token_url "https://accounts.google.com/o/oauth2/v2/auth?response_type=code&access_type=offline&prompt=consent&include_granted_scopes=true"
  @google_token_info_url "https://www.googleapis.com/oauth2/v3/tokeninfo"
  @facebook_token_url "https://graph.facebook.com/v6.0/oauth/access_token?"
  @google_token_url "https://oauth2.googleapis.com/token"
  @google_user_profile_url "https://www.googleapis.com/oauth2/v3/userinfo"
  @google_user_email_url "https://www.googleapis.com/userinfo/v2/me"

  @spec generate_url() :: String.t()
  def generate_url do
    client_id = Application.get_env(:server, Facebook)[:client_id]
    redirect_uri = Application.get_env(:server, Facebook)[:redirect_uri]

    "#{@facebook_auth_url}&client_id=#{client_id}&redirect_uri=#{redirect_uri}"
  end

  @spec generate_refresh_token_url() :: String.t()
  def generate_refresh_token_url do
    client_id = Application.get_env(:server, Google)[:client_id]
    scope = Application.get_env(:server, Google)[:scope] || "profile"
    redirect_uri = Application.get_env(:server, Google)[:redirect_uri]

    "#{@google_auth_refresh_token_url}&client_id=#{client_id}&scope=#{scope}&redirect_uri=#{redirect_uri}"
  end

  @spec token(String.t()) :: %{atom => String.t()}
  def token(code) when not is_nil(code) and is_bitstring(code) do
    body = "#{@facebook_token_url}client_id=#{Application.get_env(:server, Facebook)[:client_id]}&redirect_uri=#{Application.get_env(:server, Facebook)[:redirect_uri]}&client_secret=#{Application.get_env(:server, Facebook)[:client_secret]}&code=#{code}?me=id,email,gender,link,locale,name,first_name,last_name,timezone,updated_time,verified"
    @httpoison.get(body)
    |> parse_body_response()
  end

  @spec token(any()) :: {:ok, %{atom => String.t()}}
  def token(_) do
    {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "Malformed auth code."
      }
    }
  end

  @spec refresh_token(String.t()) :: %{atom => any}
  def refresh_token(token) when not is_nil(token) and is_bitstring(token) do
    body = Jason.encode!(%{
      refresh_token: token,
      client_id: Application.get_env(:server, Google)[:client_id],
      client_secret: Application.get_env(:server, Google)[:client_secret],
      grant_type: "refresh_token"
    })

    @httpoison.post(@google_token_url, body)
    |> parse_body_response()
  end

  @spec refresh_token(any()) :: {:ok, %{atom => String.t()}}
  def refresh_token(_) do
    {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "Bad Request"
      }
    }
  end

  @spec verify_token(String.t()) :: %{atom => any}
  def verify_token(token) when not is_nil(token) and is_bitstring(token) do
    "#{@google_token_info_url}?access_token=#{token}"
    |> @httpoison.get()
    |> parse_body_response()
  end

  def verify_token(_) do
    {:ok, %{
        "error" => "invalid_verify_token",
        "error_description" => "Invalid Value"
      }
    }
  end

  @spec user_profile(String.t()) :: %{atom => any}
  def user_profile(token) when not is_nil(token) and is_bitstring(token) do
    "#{@google_user_profile_url}?access_token=#{token}"
    |> @httpoison.get()
    |> parse_body_response()

    # https://graph.facebook.com/2823281904434541/accounts?access_token=EAAJ3B40DJTcBAOZAd74wxMcfuwoq0MIpeTMIloG23NpQzPcXaqbFqR64O6pm21WXaPO9sSJe2YzVLJZBBQT777z6GEh5ZABYeKcbKtrQgJventYK1X9wzQkMWxiJnzCZBuJ8ed8JSQYz6LdyiwwC31Bd1cx102XG3uZBoeDd9DgZDZD
    # https://graph.facebook.com/me?fields=email&access_token=EAAJ3B40DJTcBAOZAd74wxMcfuwoq0MIpeTMIloG23NpQzPcXaqbFqR64O6pm21WXaPO9sSJe2YzVLJZBBQT777z6GEh5ZABYeKcbKtrQgJventYK1X9wzQkMWxiJnzCZBuJ8ed8JSQYz6LdyiwwC31Bd1cx102XG3uZBoeDd9DgZDZD
    # https://graph.facebook.com/me?fields=id,email,gender,link,locale,name,first_name,last_name,timezone,updated_time,verified&access_token=EAAJ3B40DJTcBAOZAd74wxMcfuwoq0MIpeTMIloG23NpQzPcXaqbFqR64O6pm21WXaPO9sSJe2YzVLJZBBQT777z6GEh5ZABYeKcbKtrQgJventYK1X9wzQkMWxiJnzCZBuJ8ed8JSQYz6LdyiwwC31Bd1cx102XG3uZBoeDd9DgZDZD
    # https://graph.facebook.com/2823281904434541/picture?type=large&width=720&height=720
    # https://graph.facebook.com/me?fields=id,email,name,first_name,last_name&access_token=token"
    # https://graph.facebook.com/me?fields=email&access_token=${token}
    "https://graph.facebook.com/{your-user-id}/accounts?access_token=#{token}"
    # |> @httpoison.get()
    # |> parse_body_response()
  end

  @spec user_profile(any()) :: {:ok, %{atom => any}}
  def user_profile(_) do
    {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Invalid Credentials"
      }
    }
  end

  @spec user_email(String.t()) :: %{atom => any}
  def user_email(token) when not is_nil(token) and is_bitstring(token) do
    "#{@google_user_email_url}?access_token=#{token}"
    |> @httpoison.get()
    |> parse_body_response()
  end

  @spec user_email(any()) :: {:ok, %{atom => String.t()}}
  def user_email(_) do
    {:ok, %{
        "error" => "UNAUTHENTICATED",
        "error_description" => "Request is missing required authentication credential. Expected OAuth 2 access token, login cookie or other valid authentication credential. See https://developers.google.com/identity/sign-in/web/devconsole-project. Status 401"
      }
    }
  end

  @spec parse_body_response({:error, any()}) :: {:error, any()}
  defp parse_body_response({:error, err}), do: {:error, err}

  @spec parse_body_response({:ok, any()}) :: %{atom => any()} | {:error, :no_body}
  defp parse_body_response({:ok, response}) do
    body = Map.get(response, :body)

    if body == nil do
      {:error, :no_body}
    else
      Jason.decode(body)
    end
  end
end

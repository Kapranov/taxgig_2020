defmodule ServerWeb.Provider.OauthGoogle do
  @moduledoc """
  Minimalist Google OAuth Authentication.
  email, familyName, givenName, locale, name, picture, verifiedEmail
  """

  @behaviour ServerWeb.HTTPoison.GoogleBehaviour

  @httpoison Application.get_env(:server, :httpoison) || HTTPoison
  @google_auth_url "https://accounts.google.com/o/oauth2/v2/auth?response_type=code"
  @google_auth_refresh_token_url "https://accounts.google.com/o/oauth2/v2/auth?response_type=code&access_type=offline&prompt=consent&include_granted_scopes=true"
  @google_token_info_url "https://www.googleapis.com/oauth2/v3/tokeninfo"
  @google_token_url "https://oauth2.googleapis.com/token"
  @google_user_profile_url "https://www.googleapis.com/oauth2/v3/userinfo"
  @google_user_email_url "https://www.googleapis.com/userinfo/v2/me"

  def generate_url do
    client_id = Application.get_env(:server, Google)[:client_id]
    scope = Application.get_env(:server, Google)[:scope] || "profile+email"
    redirect_uri = Application.get_env(:server, Google)[:redirect_uri]

    "#{@google_auth_url}&client_id=#{client_id}&scope=#{scope}&redirect_uri=#{redirect_uri}"
  end

  def generate_refresh_token_url do
    client_id = Application.get_env(:server, Google)[:client_id]
    scope = Application.get_env(:server, Google)[:scope] || "profile"
    redirect_uri = Application.get_env(:server, Google)[:redirect_uri]

    "#{@google_auth_refresh_token_url}&client_id=#{client_id}&scope=#{scope}&redirect_uri=#{redirect_uri}"
  end

  def token(code) when not is_nil(code) and is_bitstring(code) do
    decode = URI.decode(code)
    body = Jason.encode!(%{
      code: decode,
      client_id: Application.get_env(:server, Google)[:client_id],
      client_secret: Application.get_env(:server, Google)[:client_secret],
      redirect_uri: Application.get_env(:server, Google)[:redirect_uri],
      grant_type: "authorization_code"
    })

    @httpoison.post(@google_token_url, body)
    |> parse_body_response()
  end

  def token(_) do
    {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "Malformed auth code."
      }
    }
  end

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

  def refresh_token(_) do
    {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "Bad Request"
      }
    }
  end

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

  def user_profile(token) when not is_nil(token) and is_bitstring(token) do
    "#{@google_user_profile_url}?access_token=#{token}"
    |> @httpoison.get()
    |> parse_body_response()
  end

  def user_profile(_) do
    {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Invalid Credentials"
      }
    }
  end

  def user_email(token) when not is_nil(token) and is_bitstring(token) do
    "#{@google_user_email_url}?access_token=#{token}"
    |> @httpoison.get()
    |> parse_body_response()
  end

  def user_email(_) do
    {:ok, %{
        "error" => "UNAUTHENTICATED",
        "error_description" => "Request is missing required authentication credential. Expected OAuth 2 access token, login cookie or other valid authentication credential. See https://developers.google.com/identity/sign-in/web/devconsole-project. Status 401"
      }
    }
  end

  defp parse_body_response({:error, err}), do: {:error, err}
  defp parse_body_response({:ok, response}) do
    body = Map.get(response, :body)

    if body == nil do
      {:error, :no_body}
    else
      Jason.decode(body)
    end
  end
end

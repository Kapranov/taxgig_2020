defmodule ServerWeb.Provider.OauthFacebook do
  @moduledoc """
  Minimalist Facebook OAuth Authentication.
  birthday, email, firstName, id, languages, lastName, middleName, name, profilePic
  """

  @behaviour ServerWeb.HTTPoison.FacebookBehaviour

  @httpoison Application.get_env(:server, :httpoison) || HTTPoison
  @fields "first_name,last_name,middle_name,name,email,picture.type(normal){url}"
  @facebook_auth_refresh_token_url "https://graph.facebook.com/oauth/access_token?"
  @facebook_auth_url "https://www.facebook.com/v6.0/dialog/oauth?"
  @facebook_code_url "https://graph.facebook.com/oauth/client_code?"
  @facebook_token_info_url "https://graph.facebook.com/oauth/access_token_info?"
  @facebook_token_url "https://graph.facebook.com/oauth/access_token?"
  @facebook_user_profile_url "https://graph.facebook.com/me?"

  @spec generate_url(String.t()) :: String.t() | nil
  def generate_url(redirect) when not is_nil(redirect) and is_bitstring(redirect) do
    client_id = Application.get_env(:server, Facebook)[:client_id]
    client_secret = Application.get_env(:server, Facebook)[:client_secret]
    scope = Application.get_env(:server, Facebook)[:scope]
    redirect_uri = Application.get_env(:server, Facebook)[:redirect_uri]

    if Enum.find_value(redirect_uri, &(&1 == redirect)) do
      "#{@facebook_auth_url}client_id=#{client_id}&client_secret=#{client_secret}&redirect_uri=#{redirect}&scope=#{scope}"
    else
      nil
    end
  end

  @spec generate_refresh_token_url(String.t()) :: {:ok, %{atom() => String.t()}}
  def generate_refresh_token_url(token) when not is_nil(token) and is_bitstring(token) do
    client_id = Application.get_env(:server, Facebook)[:client_id]
    client_secret = Application.get_env(:server, Facebook)[:client_secret]
    redirect_uri = Application.get_env(:server, Facebook)[:redirect_uri]

    "#{@facebook_code_url}client_id=#{client_id}&client_secret=#{client_secret}&redirect_uri=#{redirect_uri}&access_token=#{token}"
    |> @httpoison.get()
    |> parse_body_response()
  end

  @spec generate_refresh_token_url(any()) :: {:ok, %{atom => String.t()}}
  def generate_refresh_token_url(_) do
    {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Unable to retrieve access token: authorization code not found"
      }}
  end

  @spec token(String.t(), String.t()) :: %{atom => String.t()} | {:ok, %{atom => String.t()}}
  def token(code, redirect) when not is_nil(code) and is_bitstring(code) and not is_nil(redirect) and is_bitstring(redirect) do
    client_id = Application.get_env(:server, Facebook)[:client_id]
    client_secret = Application.get_env(:server, Facebook)[:client_secret]
    redirect_uri = Application.get_env(:server, Facebook)[:redirect_uri]

    if Enum.find_value(redirect_uri, &(&1 == redirect)) do
      "#{@facebook_token_url}client_id=#{client_id}&redirect_uri=#{redirect}&client_secret=#{client_secret}&code=#{code}"
      |> @httpoison.get()
      |> parse_body_response()
    else
      {:ok, %{
          "error" => "invalid_grant",
          "error_description" => "Malformed auth code."
        }
      }
    end
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
    client_id = Application.get_env(:server, Facebook)[:client_id]
    client_secret = Application.get_env(:server, Facebook)[:client_secret]
    grant_type = "fb_exchange_token"

    "#{@facebook_auth_refresh_token_url}client_id=#{client_id}&client_secret=#{client_secret}&grant_type=#{grant_type}&fb_exchange_token=#{token}"
    |> @httpoison.get()
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
    "#{@facebook_token_info_url}access_token=#{token}"
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
    "#{@facebook_user_profile_url}fields=#{@fields}&access_token=#{token}"
    |> @httpoison.get()
    |> parse_body_response()
  end

  @spec user_profile(any()) :: {:ok, %{atom => any}}
  def user_profile(_) do
    {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Invalid Credentials"
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

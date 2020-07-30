defmodule ServerWeb.Provider.OauthTwitter do
  @moduledoc """
  Minimalist Twitter OAuth Authentication.
  """

  # @behaviour ServerWeb.HTTPoison.TwitterBehaviour

  @spec generate_url() :: String.t()
  def generate_url do
  end

  @spec generate_refresh_token_url(String.t()) :: {:ok, %{atom() => String.t()}}
  def generate_refresh_token_url(token) when not is_nil(token) and is_bitstring(token) do
    token
  end

  @spec generate_refresh_token_url(any()) :: {:ok, %{atom => String.t()}}
  def generate_refresh_token_url(_) do
    {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Unable to retrieve access token: authorization code not found"
      }}
  end

  @spec token(String.t()) :: %{atom => String.t()}
  def token(code) when not is_nil(code) and is_bitstring(code) do
    code
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
    token
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
    token
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
    token
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
  end

  @spec user_email(any()) :: {:ok, %{atom => String.t()}}
  def user_email(_) do
    {:ok, %{
        "error" => "UNAUTHENTICATED",
        "error_description" => "Request is missing required authentication credential. Expected OAuth 2 access token, login cookie or other valid authentication credential. See https://developers.google.com/identity/sign-in/web/devconsole-project. Status 401"
      }
    }
  end
end

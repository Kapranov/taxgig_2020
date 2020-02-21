defmodule ServerWeb.Provider.OauthLinkedIn do
  @moduledoc """
  Minimalist LinkedIn OAuth Authentication.
  emailAddress, firstName, lastName, profilePicture
  """

  @behaviour ServerWeb.HTTPoison.LinkedInBehaviour

  @httpoison Application.get_env(:server, :httpoison) || HTTPoison
  @linkedin_auth_url "https://www.linkedin.com/oauth/v2/authorization?response_type=code"
  @linkedin_token_url "https://www.linkedin.com/oauth/v2/accessToken"
  @linkedin_email_url "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))"
  @linkedin_profile_url "https://api.linkedin.com/v2/me?projection=(id,localizedFirstName,localizedLastName,profilePicture(displayImage~:playableStreams))"
  # "https://api.linkedin.com/v2/me?oauth2_access_token="
  # "https://api.linkedin.com/v1/people/~:(id)?format=json&oauth2_access_token="
  # "https://api.linkedin.com/v1/companies?format=json&is-company-admin=true&oauth2_access_token="

  def generate_url do
    client_id = Application.get_env(:server, LinkedIn)[:client_id]
    redirect_uri = Application.get_env(:server, LinkedIn)[:redirect_uri]
    state = Application.get_env(:server, LinkedIn)[:state] || "pureagency"
    scope = Application.get_env(:server, LinkedIn)[:scope] || "r_liteprofile%20r_emailaddress%20"

    "#{@linkedin_auth_url}&client_id=#{client_id}&redirect_uri=#{redirect_uri}&state=#{state}&scope=#{scope}"
  end

  def generate_refresh_token_url(token) when not is_nil(token) and is_bitstring(token) do
    grant_type = "refresh_token"
    refresh_token = token
    client_id = Application.get_env(:server, LinkedIn)[:client_id]
    client_secret = Application.get_env(:server, LinkedIn)[:client_secret]

    "#{@linkedin_token_url}&grant_type=#{grant_type}&refresh_token=#{refresh_token}&client_id=#{client_id}&client_secret=#{client_secret}"
  end

  def generate_refresh_token_url(token) when not is_integer(token) do
    {:error, [field: :token, message: "Token is invalid and not string"]}
  end

  def generate_refresh_token_url(_) do
    {:error, [field: :code, message: "Code is invalid or can't be blank"]}
  end

  def token(code) when not is_nil(code) and is_bitstring(code) do
    decode = URI.decode(code)
    body = %{
      code: decode,
      client_id: Application.get_env(:server, LinkedIn)[:client_id],
      client_secret: Application.get_env(:server, LinkedIn)[:client_secret],
      redirect_uri: Application.get_env(:server, LinkedIn)[:redirect_uri],
      grant_type: "authorization_code"
    }

    data = URI.encode_query(body)
    headers = [{"Content-type", "application/x-www-form-urlencoded"}]
    @httpoison.post(@linkedin_token_url, data, headers)
    |> parse_body_response()
  end

  def token(code) when is_integer(code), do: {:error, [field: :code, message: "Code is invalid and not string"]}
  def token(_), do: {:error, [field: :code, message: "Code is invalid or can't be blank"]}

  def refresh_token(token) when not is_nil(token) and is_bitstring(token) do
    body = %{
      client_id: Application.get_env(:server, LinkedIn)[:client_id],
      client_secret: Application.get_env(:server, LinkedIn)[:client_secret],
      grant_type: "refresh_token",
      refresh_token: token
    }

    data = URI.encode_query(body)
    headers = [{"Content-type", "application/x-www-form-urlencoded"}]
    @httpoison.post(@linkedin_token_url, data, headers)
    |> parse_body_response()
  end

  def refresh_token(token) when is_integer(token), do: {:error, [field: :token, message: "Token is invalid and not string"]}
  def refresh_token(_), do: {:error, [field: :token, message: "Token is invalid or can't be blank"]}

  def verify_token(token) when not is_nil(token) and is_bitstring(token) do
    headers = [{"Authorization", "Bearer #{token}"}, {"Accept", "application/json"}]

    {:ok, data} =
      "#{@linkedin_email_url}"
      |> @httpoison.get(headers)
      |> parse_body_response()

    case data["elements"] do
      nil ->
        {:error, "Invalid access token"}
      _ ->
        if email =
          data["elements"]
          |> List.last
          |> get_in(["handle~", "emailAddress"]), do: email, else: nil
    end
  end

  def verify_token(token) when is_integer(token), do: {:error, [field: :token, message: "Token is invalid and not string"]}
  def verify_token(_), do: {:error, [field: :token, message: "Token is invalid or can't be blank"]}

  def user_profile(token) when not is_nil(token) and is_bitstring(token) do
    headers = [{"Authorization", "Bearer #{token}"}, {"Accept", "application/json"}]

    "#{@linkedin_profile_url}"
    |> @httpoison.get(headers)
    |> parse_body_response()
  end

  def user_profile(token) when is_integer(token), do: {:error, [field: :token, message: "Token is invalid and not string"]}
  def user_profile(_), do: {:error, [field: :token, message: "Token is invalid or can't be blank"]}

  def user_email(token) when not is_nil(token) and is_bitstring(token) do
    headers = [{"Authorization", "Bearer #{token}"}, {"Accept", "application/json"}]

    "#{@linkedin_email_url}"
    |> @httpoison.get(headers)
    |> parse_body_response()
  end

  def user_email(token) when is_integer(token), do: {:error, [field: :token, message: "Token is invalid and not string"]}
  def user_email(_), do: {:error, [field: :token, message: "Token is invalid or can't be blank"]}

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

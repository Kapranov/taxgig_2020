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
  @linkedin_profile_url "https://api.linkedin.com/v2/me?projection=(localizedFirstName,localizedLastName,profilePicture(displayImage~:playableStreams))"
  @avatar_url "https://robohash.org/set_set3/bgset_bg2/dky6Sd"

  def generate_url do
    client_id = Application.get_env(:server, LinkedIn)[:client_id]
    redirect_uri = Application.get_env(:server, LinkedIn)[:redirect_uri]
    state = Application.get_env(:server, LinkedIn)[:state] || "pureagency"
    scope = Application.get_env(:server, LinkedIn)[:scope] || "r_liteprofile%20r_emailaddress%20"

    url = "#{@linkedin_auth_url}&client_id=#{client_id}&redirect_uri=#{redirect_uri}&state=#{state}&scope=#{scope}"
    {:ok, %{"url" => url}}
  end

  def generate_refresh_token_url(token) when not is_nil(token) and is_bitstring(token) do
    grant_type = "refresh_token"
    refresh_token = token
    client_id = Application.get_env(:server, LinkedIn)[:client_id]
    client_secret = Application.get_env(:server, LinkedIn)[:client_secret]

    url = "#{@linkedin_token_url}&grant_type=#{grant_type}&refresh_token=#{refresh_token}&client_id=#{client_id}&client_secret=#{client_secret}"

    {:ok, %{"code" => url}}
  end

  def generate_refresh_token_url(_) do
    {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Unable to retrieve access token: authorization code not found"
      }}
  end

  def token(code) when not is_nil(code) and is_bitstring(code) do
    decode = URI.decode(code)
    headers = [{"Content-type", "application/x-www-form-urlencoded"}]
    body = URI.encode_query(%{
      code: decode,
      client_id: Application.get_env(:server, LinkedIn)[:client_id],
      client_secret: Application.get_env(:server, LinkedIn)[:client_secret],
      redirect_uri: Application.get_env(:server, LinkedIn)[:redirect_uri],
      grant_type: "authorization_code"
    })

    {:ok, data} =
      @httpoison.post(@linkedin_token_url, body, headers)
      |> parse_body_response()

      {:ok, %{
          "access_token" => data["access_token"],
          "error" => data["error"],
          "error_description" => data["error_description"],
          "expires_in" => data["expires_in"]
        }}
  end

  def token(_) do
    {:ok, %{
        "error" => "invalid_request",
        "error_description" => "Unable to retrieve access token: authorization code not found"
      }}
  end

  def refresh_token(token) when not is_nil(token) and is_bitstring(token) do
    headers = [{"Content-type", "application/x-www-form-urlencoded"}]
    body = URI.encode_query(%{
      client_id: Application.get_env(:server, LinkedIn)[:client_id],
      client_secret: Application.get_env(:server, LinkedIn)[:client_secret],
      grant_type: "refresh_token",
      refresh_token: token
    })

    {:ok, data} =
      @httpoison.post(@linkedin_token_url, body, headers)
      |> parse_body_response()

    {:ok, %{
        "error" => data["error"],
        "error_description" => data["error_description"]
      }}
  end

  def refresh_token(_) do
    {:ok, %{
        "error" => "invalid_grant",
        "error_description" => "The provided authorization grant or refresh token is invalid, expired or revoked."
      }}
  end

  def verify_token(token) when not is_nil(token) and is_bitstring(token) do
    headers = [{"Authorization", "Bearer #{token}"}, {"Accept", "application/json"}]

    {:ok, data} =
      "#{@linkedin_email_url}"
      |> @httpoison.get(headers)
      |> parse_body_response()

    if is_nil(data["message"]) do
      {:ok, %{"email" => info_email(data)}}
    else
      {:ok, %{
          "error" => data["message"],
          "error_description" => "serviceErrorCode #{data["serviceErrorCode"]} and #{data["status"]} status"
        }}
    end
  end

  def verify_token(_) do
    {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}
  end

  def user_profile(token) when not is_nil(token) and is_bitstring(token) do
    headers = [{"Authorization", "Bearer #{token}"}, {"Accept", "application/json"}]

    {:ok, data} =
      "#{@linkedin_profile_url}"
      |> @httpoison.get(headers)
      |> parse_body_response()

    if is_nil(data["message"]) do
      {:ok, %{
          "avatar" => info_image(data),
          "first_name" => data["localizedFirstName"],
          "last_name" => data["localizedLastName"]
        }}
    else
      {:ok, %{
          "error" => data["message"],
          "error_description" => "serviceErrorCode #{data["serviceErrorCode"]} and #{data["status"]} status"
        }}
    end
  end

  def user_profile(_) do
    {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}
  end

  def user_email(token) when not is_nil(token) and is_bitstring(token) do
    headers = [{"Authorization", "Bearer #{token}"}, {"Accept", "application/json"}]

    {:ok, data} =
      "#{@linkedin_email_url}"
      |> @httpoison.get(headers)
      |> parse_body_response()

    if is_nil(data["message"]) do
      {:ok, %{
          "email" => info_email(data)
        }}
    else
      {:ok, %{
          "error" => data["message"],
          "error_description" => "serviceErrorCode #{data["serviceErrorCode"]} and #{data["status"]} status"
        }}
    end
  end

  def user_email(_) do
    {:ok, %{
        "error" => "Invalid access token",
        "error_description" => "serviceErrorCode 65600 and 401 status"
      }}
  end

  defp info_image(data) do
    avatar =
      data
      |> get_in(["profilePicture", "displayImage~", "elements"])
      |> List.last()
      |> get_in(["identifiers"])
      |> List.last()
      |> get_in(["identifier"])

    if is_nil(avatar), do: @avatar_url, else: avatar
  end

  defp info_email(data) do
    email =
      data
      |> get_in(["elements"])
      |> List.last
      |> get_in(["handle~", "emailAddress"])

    if is_nil(email), do: nil, else: email
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

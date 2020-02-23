defmodule ServerWeb.Provider.HTTPoison.InMemory do
  @moduledoc """
  In memory for test enviroment.
  """

  @headers_one [{"Authorization", "Bearer wrong_token"}, {"Accept", "application/json"}]
  @headers_two [{"Authorization", "Bearer ok_token"}, {"Accept", "application/json"}]
  @google_token "https://www.googleapis.com/oauth2/v3/userinfo?access_token=wrong_token"
  @google_email "https://www.googleapis.com/userinfo/v2/me?access_token=wrong_token"

  # @linked_email "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))"
  # @linked_token "https://www.linkedin.com/oauth/v2/accessToken"
  # @linked_token "https://api.linkedin.com/v2/me?oauth2_access_token=wrong_token"

  def get(@google_token), do: {:error, :bad_request}
  def get(@google_email), do: {:error, :bad_request}
  def get(_url), do: {:ok, %{body: Jason.encode!(%{name: "josh"})}}

  def get(_url, @headers_one), do: {:ok, %{body: Jason.encode!(%{error: :bad_request})}}
  def get(_url, @headers_two), do: {:ok, %{body: Jason.encode!(%{name: "josh"})}}
  def get(_url, _options), do: {:ok, %{body: Jason.encode!(%{name: "josh"})}}

  def post(_url, _token), do: {:ok, %{body: Jason.encode!(%{access_token: "token1"})}}
  def post(_url, _token, _options), do: {:ok, %{body: Jason.encode!(%{access_token: "token1"})}}

  def process_request_options(options) do
    basic_auth = {"username", "password"}
    Keyword.update(
      options,
      :hackney,
      Keyword.new(basic_auth: basic_auth),
      &Keyword.put_new(&1, :basic_auth, basic_auth))
  end

  def process_request_headers(headers) do
    [{"Content-Type", "application/json"} | headers]
  end
end

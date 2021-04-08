defmodule ServerWeb.HTTPoison.FacebookBehaviour do
  @moduledoc """
  Because we are mocking the api requests in ServerWeb.Provider.OauthFacebook
  we have to have a separate module to delegate the functions
  we use to the actual HTTPoison module, so that's all we do here.
  """

  @typep code :: binary()
  @typep token :: binary()
  @typep url :: binary()

  @callback generate_url(url) :: String.t()
  @callback generate_refresh_token_url(token) :: {:ok, map()} | {:error, binary() | map()}
  @callback token(code) :: {:ok, map()} | {:error, binary() | map()}
  @callback refresh_token(token) :: {:ok, map()} | {:error, binary() | map()}
  @callback verify_token(token) :: {:ok, map()} | {:error, binary() | map()}
  @callback user_profile(token) :: {:ok, map()} | {:error, binary() | map()}
end

defmodule ServerWeb.HTTPoison.FacebookBehaviour do
  @moduledoc """
  Because we are mocking the api requests in ServerWeb.Provider.OauthFacebook
  we have to have a separate module to delegate the functions
  we use to the actual HTTPoison module, so that's all we do here.
  """
end

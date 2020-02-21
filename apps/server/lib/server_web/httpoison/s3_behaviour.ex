defmodule ServerWeb.HTTPoison.S3Behaviour do
  @moduledoc """
  AWS S3 mocking the api requests in Core.Uploaders.S3
  we have to have a separate module to delegate the functions
  we use to the actual HTTPoison module, so that's all we do here.
  """

  @typep upload :: Core.Upload.t()

  @type file_spec :: {:file | :url, String.t()}

  @callback put_file(upload) :: {:ok, map()} | {:error, binary() | map()}
  @callback put_file(upload) :: :ok | {:ok, file_spec()} | {:error, String.t()} | :wait_callback
end

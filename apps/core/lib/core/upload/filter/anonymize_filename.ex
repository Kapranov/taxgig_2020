defmodule Core.Upload.Filter.AnonymizeFilename do
  @moduledoc """
  Replaces the original filename with a pre-defined text or randomly generated string.

  Should be used after `Core.Upload.Filter.Dedupe`.
  """

  @behaviour Core.Upload.Filter

  alias Core.{
    Config,
    Upload
  }

  @spec filter(%Upload{}) :: {:ok, %Upload{}}
  def filter(%Upload{name: name} = upload) do
    extension = List.last(String.split(name, "."))
    name = predefined_name(extension) || random(extension)
    {:ok, %Upload{upload | name: name}}
  end

  @spec predefined_name(String.t()) :: String.t() | nil
  defp predefined_name(extension) do
    with name when not is_nil(name) <- Config.get([__MODULE__, :text]),
      do: String.replace(name, "{extension}", extension)
  end

  @spec random(String.t()) :: String.t()
  defp random(extension) do
    string =
      10
      |> :crypto.strong_rand_bytes()
      |> Base.url_encode64(padding: false)

    string <> "." <> extension
  end
end
